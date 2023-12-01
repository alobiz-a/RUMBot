#include <xc.inc>

psect usrf ; Defining a psect

cblock 0x20 ; Define variables used
delay1
delay2
delay3
endc

usrf_main: ; This would be shortened to rf but I want to avoid any
	   ; confusion with radio frequency  
    usrf_init:
	call trig_one ; Activate the first rangefinder
	call delay_long ; Wait for the pulse to finish.
	call trig_two ; Activate the second rangefinder.
	call convert ; Convert the time delay to metres. 

    trig_one: ; Create a 10 us pulse at the RB3 pin which is connected to the first
	      ; ultrasonic sensor 	
      movlw 0x00
      movwf TRISH ; Set all pins as outputs.
      bsf LATH, 3 ; Set pin 3 on PORTH high.
      call delay_short
      bsf LATH, 3 ; Set pin 3 on PORTH low.
      movlw 0xFF
      movwf TRISH ; Set all pins as inputs
      
      
;     movlw TRISH, 3 ; Set all pins as output. 
;     movlw 0xBF
;     movf LATH
;     call delay_short ; Call the 10 us delay subroutine.
;     bsf TRISH, 3 ; Set pin 3 as input.
;     return 

loop:
    call trig_one
    call delay_long
    goto loop 
    

     
trig_two: ; Create a 10 us pulse at the RB3 pin which is connected to the second
	  ; ultrasonic sensor
    bcf TRISH, 4 ; Set pin 4 as output. 
    movlw 0xFA 
    movf LATH ; Set output
    call delay_short ; Call the 10 us delay subroutine.
    bsf TRISH, 4 ; Set pin 4 as input.
    return
    
delay_short: ; Generate a 10 us delay. Clock frequency is 16 MHz so each
	     ; instruction takes 4*(1/16e6) = 2.5 us to complete
    nop
    nop
    nop
    nop
    return
    
delay_long: ; Generate a 60 ms delay. Made using an online delay generator.
    movlw 0xAB ; 171
    movwf delay1
    movlw 0x38 ; 56
    movwf delay2
    movlw 0x02 ; 2
    movwf delay3
    call delay_loop
    delay_loop:
	decfsz delay1, 1
	goto delay_loop
	decfsz delay2, 1
	goto delay_loop
	decfsz delay3, 1
	goto delay_loop
	nop
	nop
	return
    
	
start_timer:
    movlw 0b10000111
    movwf T1CON
    bsf TMR1IE
    bsf GIE
    movlw 
    movwf 0xFF