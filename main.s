#include <xc.inc>
    
psect usrf ; Defining a psect

cblock 0x20 ; Define variables used
delay1
delay2
delay3
time1
time2
endc

usrf_main: ; This would be shortened to rf but I wanted to avoid any
	   ; confusion with radio frequency  
	   
    usrf_init:
	call trig_one ; Activate the first rangefinder
	call delay_long ; Wait for the pulse to finish.
	call trig_two ; Activate the second rangefinder.

    trig_one: ; Create a 10 us pulse at the RB3 pin which is connected to the 
	      ; first ultrasonic sensor 	
	movlw 0x00
	movwf TRISH ; Set all pins as outputs.
	bsf LATH, 3 ; Set pin 3 on PORTH high.
	call delay_short
	bsf LATH, 3 ; Set pin 3 on PORTH low.
	movlw 0xFF
	movwf TRISH ; Set all pins as inputs
	call measure_pulse

    trig_two: ; Create a 10 us pulse at the RB4 pin which is connected to the 
	      ; second ultrasonic sensor 	
	movlw 0x00
	movwf TRISH ; Set all pins as outputs.
	bsf LATH, 4 ; Set pin 3 on PORTH high.
	call delay_short
	bsf LATH, 4 ; Set pin 3 on PORTH low.
	movlw 0xFF
	movwf TRISH ; Set all pins as inputs
	call measure_pulse
	
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
	
    measure_pulse: ; Measure the length of the return pulse using Timer1.
		   ;                     ________
		   ; Pulse over time ___|        |_____
		   ;                    <-------->
	movlw 0xB3 ; Bits 7:6 set the IO port as the coordinator. The timer is 
		   ; prescaled by 8 to prevent overflows. 
	movwf T1CON
	clrf CCP4CON ; Clear CCP module
	movlw 0x84 ; Bit 7 enables CCP and bits 3:0 means that it is triggered
		   ; on falling edges.
	movwf CCP1CON ; Setting up CCP timer in capture mode. 
	movff CCPR1H, time1
	movff CCPR1L, time2
	bcf CCP1IF
	return
	