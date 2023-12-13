#include <xc.inc>
			  
extrn pulse_delay, wait_delay
        
flag_reg set 0x20	    ; Define a flag to reflect if the first range finder
			    ; has been activated or not.
psect udata_acs
time_one_H:	ds 1
time_one_L:	ds 1
time_two_H:	ds 1
time_two_L:	ds 1
			    
global ranger_main, time_one_H, time_one_L, time_two_H, time_two_L 

;psect ranger_code, class = CODE, abs
psect ranger_code, class = CODE, abs
org 0x00
start:
    goto    ranger_main


interrupt_handler:
    org 0x08
    ; Interrupt vector
    btfss   flag_reg, 0	    ; Check if the first range finder has been used
    goto    interrupt_one   ; NO, measure the first range finder
    goto    interrupt_two   ; YES, measure the second range finder
    return  

;org 0x100
;org 0x2
ranger_main:
    org	    0x11A
    call    ranger_init
    call    trigger_one	    ; Trigger the first range finder
    bsf	    flag_reg,	0   ; Set the flag_reg bit to show that the first range
			    ; finder has been activated
    call    trigger_two
    goto    ranger_main
    return
    
ranger_init:
    clrf    time_one_H
    clrf    time_one_L
    clrf    time_two_H
    clrf    time_two_L
    bsf	    INTCON, 7	; Enable global interrupt
    bsf	    INTCON, 6   ; Enable peripheral interrupt
    bsf	    PIE4,   1	; Enable CCP4 interrupt
    bsf	    PIE4,   2	; Enable CCP5 interrupt
    bsf	    IPR4,   1	; Set CCP4 interrupt as high priority
    bsf	    IPR4,   2	; Set CCP5 interrupt as high priority
    clrf    flag_reg	; Clear flag register
    return 
        
interrupt_one:
    bcf	    PIE4,	1   ; Pause any other interrupts from CCP4
    bcf	    PIR4,	1   ; CCP4IF, clear the interrupt flag
    btfss   flag_reg,	1   ; Check if interrupt has already occurred
    goto    rising_one	    ; NO, start timer on the rising edge
    goto    falling_one	    ; YES, stop timer and move values into memory
        
interrupt_two:
    bcf	    PIE4,	2   ; Pause any other interrupts from CCP5
    bcf	    PIR4,	2   ; CCP5IF, clear the interrupt flag 	
    btfss   flag_reg,	2   ; Check if interrupt has already occurred
    goto    rising_two	    ; NO, start the timer on the rising edge
    goto    falling_two	    ; YES, stop timer and move values into memory
   
rising_one:
    clrf    CCP4CON
    movlw   0x04    
    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
			; trigger on the falling edge now
    clrf    CCPTMRS1 
    movlw   0x00	; CCP4 is based off of TMR1
    movwf   CCPTMRS1		
    bsf	    PIE4,   1	; Re-enable interrupts from CCP4
    movlw   0x31	; Set the TMR1 to use F_osc/4 prescaled by 8
    movwf   T1CON	; Start the timer
    return
    
falling_one:
    bcf	    PIE4,   1		; Disable CCP4 interrupts to prevent any further
				; interrupts
    bsf	    T1CON, 0		; Turn TMR1 off
    movff   TMR1L, time_one_L	; Move high byte into memory
    movff   TMR1H, time_one_H	; Move low byte into memory
    goto    ranger_main
    
    
rising_two:
    bcf	    PIE4,   1	; Disable CCP4 interrupts to prevent any further
			; interrupts
    clrf    CCP5CON
    movlw   0x04    
    movwf   CCP5CON	; Set the CCP5 control byte to capture mode and to 
			; trigger on the falling edge now
    clrf    CCPTMRS1 
    movlw   0x00	; CCP5 is based off of TMR1
    movwf   CCPTMRS1	
    movlw   0x31	; Set the TMR1 to use F_osc/4 prescaled by 8
    movwf   T1CON
    return
    
falling_two:
    bcf	    PIE4,   2		; Disable CCP4 interrupts to prevent any further
				; interrupts
    bsf	    T1CON,  0		; Turn TMR1 off
    movff   TMR1L, time_two_L	; Move high byte into memory
    movff   TMR1H, time_two_H	; Move low byte into memory
    return
    
trigger_one:
    ; Initialize the CCP interrupt and trigger the ultrasonic range finder.
    bcf	    PIR4,   1	; CCP4IF, clear the interrupt flag 
    clrf    CCP4CON
    movlw   0x00
    movwf   TRISG	; Make all pins on PORTG outputs.
    bsf	    LATG,   3	; Set pin 3 to be high.
    call    pulse_delay 
    bcf	    LATG,   3	; Set pin 3 to be low.
    movlw   0xFF
    movwf   TRISG	; Make all pins on PORTG inputs
    movlw   0x05	; Interrupt on rising edge.
    movwf   CCP4CON
    call    wait_delay
    return

trigger_two:
    ; Initialize the CCP4 capture module interrupt and trigger the ultrasonic 
    ; range finder.
    bcf	    PIR4,   2	; CCP5IF, clear the interrupt flag 	
    clrf    CCP5CON
    movlw   0x00
    movwf   TRISG	; Make all pins on PORTH outputs.
    bsf	    LATG,   4	; Set pin 4 to be high.
    call    pulse_delay 
    bcf	    LATG,   4	; Set pin 4 to be low.
    movlw   0xFF
    movwf   TRISG	; Make all pins on PORTH inputs.
    movlw   0x05	; Interrupt on rising edge.
    movwf   CCP5CON
    call    wait_delay
    return

    


