#include <xc.inc>
    
psect ranger_code, class = CODE
    
extrn pulse_delay, wait_delay
        
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

org 0x08
interrupt_handler:
    ; Interrupt vector
    btfss   trigger_flag, 0 ; Check if the first range finder has been used.
    goto    interrupt_one   ; NO, measure the first range finder.
    goto    interrupt_two   ; YES, measure the second range finder.
    return  

org 0x100
ranger_main:
    bsf	    PIE4, 0	; Enable CCP4 interrupt
    bsf	    PIE4, 1	; Enable CCP5 interrupt
    bsf	    INTCON, 7	; Enable global interrupt
    bsf	    INTCON, 6   ; Enable peripheral interrupt
    bcf	    trigger_flag, 0
    call    trigger_one
    bsf	    trigger_flag, 0
    call    trigger_two
    return
 
interrupt_one:
    btfss   PIR4, 1	; Check if interrupt has already occurred. 
    goto    rising_one	; NO, start the timer on the rising edge.
    goto    falling_one	; YES, stop the timer and move the values into memory.
    
rising_one:
    clrf    CCP4CON
    movlw   0x04    
    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
			; trigger on the falling edge now.
    clrf    CCPTMRS1 
    movlw   0x00	; CCP4 is based off of TMR1.
    movwf   CCPTMRS1	
    movlw   0x31	; Set the TMR1 to use F_osc/4 prescaled by 8.
    movwf   T1CON
    retfie
    
falling_one:
    bsf	    T1CON, 0	; Turn TMR1 off
    movff   TMR1L, time_one_L
    movff   TMR1H, time_one_H
    retfie
    
interrupt_two:
    btfss   PIR5, 1	; Check if interrupt has already occurred. 
    goto    rising_two	; NO, start the timer on the rising edge.
    goto    falling_two	; YES, stop the timer and move the values into memory.
    
rising_two:
    clrf    CCP5CON
    movlw   0x04    
    movwf   CCP5CON	; Set the CCP5 control byte to capture mode and to 
			; trigger on the falling edge now.
    clrf    CCPTMRS1 
    movlw   0x04	; CCP5 is based off of TMR1.
    movwf   CCPTMRS1	
    movlw   0x31	; Set the TMR1 to use F_osc/4 prescaled by 8.
    movwf   T1CON
    retfie
    
falling_two:
    bsf	    T1CON, 0	; Turn TMR1 off
    movff   TMR1L, time_two_L
    movff   TMR1H, time_two_H
    retfie

    
trigger_one:
    ; Initialize the CCP interrupt and trigger the ultrasonic range finder.
    bcf	    PIR4, 1	; CCP4IF, clear the interrupt flag 
    clrf    CCP4CON
    movlw   0x00
    movwf   TRISH	; Make all pins on PORTH outputs.
    bsf	    LATH, 3	; Set pin 3 to be high.
    call    pulse_delay 
    bcf	    LATH, 3	; Set pin 3 to be low.
    movlw   0xFF
    movwf   TRISH	; Make all pins on PORTH inputs
    movlw   0x05	; Interrupt on rising edge.
    movwf   CCP4CON
    call    wait_delay
    return

trigger_two:
    ; Initialize the CCP4 capture module interrupt and trigger the ultrasonic 
    ; range finder.
    bcf	    PIR5, 1	; CCP5IF, clear the interrupt flag 
    clrf    CCP5CON
    movlw   0x00
    movwf   TRISH	; Make all pins on PORTH outputs.
    bsf	    LATH, 4	; Set pin 4 to be high.
    call    pulse_delay 
    bcf	    LATH, 4	; Set pin 4 to be low.
    movlw   0xFF
    movwf   TRISH	; Make all pins on PORTH inputs.
    movlw   0x05	; Interrupt on rising edge.
    movwf   CCP5CON
    call    wait_delay
    return

    
