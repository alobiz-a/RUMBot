#include <xc.inc>
extrn pulse_delay, wait_delay
    
;psect code, abs 
global rangers_main, ranger1_time1, ranger1_time2, ranger2_time1, ranger2_time2

ranger1_time1 equ 0x200
ranger1_time2 equ 0x201
ranger2_time1 equ 0x202
ranger2_time2 equ 0x203 
 
psect	ranger_code,class=CODE; Defining a psect
 
rangers_main:
    ; Measure the pulse length of each rangefinder.
    ;                     ________
    ; Pulse over time ___|        |_____
    ;                    <-------->
    ;************RANGER 1;************
    call ccp_init
    call trig_one 
    movff CCPR1H, ranger1_time1
    movff CCPR1L, ranger1_time2
    ;************RANGER 2;************
    call ccp_init
    call trig_two
    movff CCPR1H, ranger2_time1
    movff CCPR1L, ranger2_time2
    return 
    
ccp_init:
    clrf CCP4CON
    movlw 0x05	; interrupt on rising edge
    movwf CCP4CON
    bcf PIR4, 1 ; CCP4IF 
    return
;    
trig_one: 
    ; Create a 10 us pulse at the RB3 pin which is connected to the 
    ; first ultrasonic sensor 
    movlw 0x00
    movwf TRISH ; Set all pins as outputs.
    bsf LATH, 3 ; Set pin 3 on PORTH high.
    call pulse_delay ; 10us
    bcf LATH, 3 ; Set pin 3 on PORTH low.
    movlw 0xFF
    movwf TRISH ; Set all pins as inputs
    call wait_delay ; 60ms (max time we give to start trigger)
    return

trig_two: 
    ; Create a 10 us pulse at the RB4 pin which is connected to the 
    ; first ultrasonic sensor 
    movlw 0x00
    movwf TRISH ; Set all pins as outputs.
    bsf LATH, 4 ; Set pin 3 on PORTH high.
    call pulse_delay 
    bcf LATH, 4 ; Set pin 3 on PORTH low.
    movlw 0xFF
    movwf TRISH ; Set all pins as inputs
    call wait_delay
    return    
        
ranger_interrupt:
    btfss PIR4, 1 ; CCP4IF, check if the interrupt was previously triggered to 
		  ; determine if the CCP set up should change to trigger on the
		  ; falling edge
    goto rising_edge
    bcf T1CON, 0 ; TMR1ON, turn Timer 1 off
    retfie f
       
rising_edge:
    clrf CCP4CON
    movlw 0x04 ; Set the CCP4 control byte to capture mode and to trigger on
	       ; the falling edge now.
    movwf CCP4CON
    bcf T1CON, 0 ; TMR1ON, turn Timer 1 off.
    movlw 0x77 ; 0b00110111, initialize the clock running at F_osc/4 with a 
	       ; pre-scale of 8.
    movwf T1CON ; Turn Timer 1 on.
    call wait_delay
    return
