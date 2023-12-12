#include <xc.inc>
    
psect ranger_basic_code, class = CODE
    
extrn pulse_delay, ranging_delay, wait_delay
        
trigger_flag set 0x20	    ; Define a flag to reflect if the first range finder
			    ; has been activated or not.

time_one_H:	ds 1
time_one_L:	ds 1
time_two_H:	ds 1
time_two_L:	ds 1
			    
global ranger_main, time_one_H, time_one_L, time_two_H, time_two_L 
			    
org 0x00
start:
    goto    ranger_main

org 0x100
ranger_main:
    bcf	    trigger_flag, 0
    call    trigger_one
    bsf	    trigger_flag, 0
    call    trigger_two
    return
    
trigger_one:
    movlw   0x00
    movwf   TRISH	; Make all pins on PORTH outputs.
    bsf	    LATH, 3	; Set pin 4 to be high.
    call    pulse_delay 
    bcf	    LATH, 3	; Set pin 4 to be low.
    movlw   0xFF
    movwf   TRISH	; Make all pins on PORTH inputs.
    call    measure_pulse
    return
    
trigger_two:
    movlw   0x00
    movwf   TRISH	; Make all pins on PORTH outputs.
    bsf	    LATH, 4	; Set pin 4 to be high.
    call    pulse_delay 
    bcf	    LATH, 4	; Set pin 4 to be low.
    movlw   0xFF
    movwf   TRISH	; Make all pins on PORTH inputs.
    call    measure_pulse
    return


 
;interrupt_one:
;    btfss   PIR4, 1	; Check if interrupt has already occurred. 
;    goto    rising_one	; NO, start the timer on the rising edge.
;    goto    falling_one	; YES, stop the timer and move the values into memory.
    
;rising_one:
;    clrf    CCP4CON
;    movlw   0x04    
;    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
;			; trigger on the falling edge now.
;    clrf    CCPTMRS1 
;    movlw   0x00	; CCP4 is based off of TMR1.
;    movwf   CCPTMRS1	
;    movlw   0x31	; Set the TMR1 to use F_osc/4 prescaled by 8.
;    movwf   T1CON
;    retfie

    

    

    




    
