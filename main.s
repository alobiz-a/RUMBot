#include <xc.inc>

psect	code, abs

cblock 0x20 ; Define variables used
delay1
delay2
delay3
endc

init: 
    org 0x00 ; Reset vector
    goto main

loop:
    call trig_one
    call delay_long
    goto loop
    
trig_one: ; Create a 10 us pulse at the RB3 pin which is connected to the first
	  ; ultrasonic sensor 
    bcf TRISB, 3 ; Set pin 3 as output. 
    movlw 0xBF
    movf LATB
    call delay_short ; Call the 10 us delay subroutine.
    bsf TRISB, 3 ; Set pin 3 as input.
    return
     
trig_two: ; Create a 10 us pulse at the RB3 pin which is connected to the second
	  ; ultrasonic sensor
    bcf TRISB, 4 ; Set pin 4 as output. 
    movlw 0xFA 
    movf LATB ; Set output
    call delay_short ; Call the 10 us delay subroutine.
    bsf TRISB, 4 ; Set pin 4 as input.
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
    