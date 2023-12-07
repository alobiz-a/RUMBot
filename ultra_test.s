#include <xc.inc>
extrn pulse_delay, wait_delay
    
psect code, abs ; Defining a psect

ultra1_time1 equ 0x200
ultra1_time2 equ 0x201

global ultra1_time1, ultra1_time2

org 0x00
main:
    goto trig_one

org 0x100    
trig_one: 
; Create a 10 us pulse at the RB3 pin which is connected to the 
; first ultrasonic sensor 
movlw 0x00
movwf TRISH ; Set all pins as outputs.
bsf LATH, 3 ; Set pin 3 on PORTH high.
call pulse_delay 
bsf LATH, 3 ; Set pin 3 on PORTH low.
movlw 0xFF
movwf TRISH ; Set all pins as inputs
goto measure_pulse
call wait_delay
goto trig_one
        
org 0x08 
interrupt_handler:
    btfss PIR4, 1 ; CCP4IF, check if the interrupt was previously triggered to 
		  ; determine if the CCP set up should change to trigger on the
		  ; falling edge
    goto rising_edge_interrupt
    bcf T1CON, 0 ; TMR1ON, turn Timer 1 off
    movff CCPR1H, ultra1_time1
    movff CCPR1L, ultra1_time2
    retfie f
    
measure_pulse:
; Measure the length of the return pulse using Timer1.
;                     ________
; Pulse over time ___|        |_____
;                    <-------->
goto $
    
rising_edge_interrupt:
    clrf CCP4CON
    movlw 0x04 ; Set the CCP4 control byte to capture mode and to trigger on
	       ; the falling edge now.
    bcf T1CON, 0 ; TMR1ON, turn Timer 1 off.
    movlw 0x77 ; 0b00110111, initialize the clock running at F_osc/4 with a 
	       ; pre-scale of 8.
    movwf T1CON ; Turn Timer 1 on.
    goto $
    return

