#include <xc.inc>
    
extrn pulse_delay, wait_delay

flag	set 0x20
    
psect udata_acs

time_H:		ds 1
time_L:		ds 1

global	ranger_main, time_H, time_L
    
psect ranger_code, class = CODE, abs
    
org 0x00
start:
    goto    ranger_main
    
interrupt_handler:
    org 0x08
    btfss   flag, 0
    goto    rising_edge
    goto    falling_edge
    
ranger_main:
    call    ranger_init
    call    trigger
    call    wait_delay
    goto    ranger_main
    
ranger_init:
    bsf	    INTCON, 6	; Enable peripheral interrupt
    bsf	    INTCON, 7	; Enable global interrupt
    bsf	    PIE4, 1	; Set CCP4 interrupt
    bsf     IPR4, 1     ; Set CCP4 interrupt as high priority
    clrf    PIR4	; Clear interrupt flag register
    clrf    flag	; Clear sequence flag register
    return
    
trigger:
    ; Initialize the CC64 interrupt and trigger the ultrasonic range finder.
    movlw   0x00
    movwf   TRISG	; Make all pins on PORTG outputs.
    bsf     LATG, 3	; Set pin 3 to be high.
    call    pulse_delay 
    bcf     LATG, 3	; Set pin 3 to be low.
    movlw   0xFF
    movwf   TRISG	; Make all pins on PORTG inputs
    clrf    CCP4CON    
    movlw   0x05	; Set the CCP control byte to capture mode and to
			; trigger on the rising edge (CCP4M = 0101)
    movwf   CCP4CON
    call    wait_delay
    return
 
rising_edge:
    bcf	    PIE4, 1	; Temporarily disable interrupts on CCP4
    clrf    CCP4CON
    movlw   0x04
    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
			; trigger on the falling edge (CCP4M = 0100)
    clrf    CCPTMRS1
    movlw   0x00
    movwf   CCPTMRS1	; CCP4 is based on TMR1	
    clrf    T1CON
    movlw   0x31
    movwf   T1CON	; Set TMR1 to use F_osc/4 prescaled by a factor of 8
    movwf   TRISD	; Make all pins on PORTD outputs.
    bsf     LATD, 3	; Set pin 3 to be high.
    call    wait_delay	; Illuminate to verify interrupt operation
    bcf     LATD, 3	; Set pin 3 to be low.
    bsf	    PIE4, 1	; Re-enable interrupts on CCP5
    
falling_edge:
    bcf	    PIE4, 1	    ; Temporarily disable interrupts on CCP6
    bsf	    T1CON, 0	    ; Turn off TMR1
    bsf	    PIE4, 1	    ; Re-enable interrupts on CCP6
    movff   TMR1H, time_H
    movff   TMR1L, time_L
    movlw   0x00
    bsf	    PIE4, 1	; Re-enable interrupts on CCP4
    return
    
;    
;falling_one:
;    bcf	    PIE4,   1	; Temporarily disable interrupts
;    bsf     T1CON, 0         ; Turn TMR1 off
;    movff   TMR1L, time_one_L
;    movff   TMR1H, time_one_H
;    
;    goto    ranger_main
;    


;#include <xc.inc>
;    
;
;    
;extrn pulse_delay, wait_delay
;        
;trigger_flag set 0x20           ; Define a flag to reflect if the first range finder
;                                ; has been activated or not.
;psect udata_acs
;time_one_H:       ds 1
;time_one_L:       ds 1
;time_two_H:      ds 1
;time_two_L:       ds 1
;                                                 
;global ranger_main, time_one_H, time_one_L, time_two_H, time_two_L 
;
;psect ranger_code, class = CODE, abs
;
;org 0x00
;start:
;    goto    ranger_main
;
;org 0x08
;interrupt_handler:
;    ; Interrupt vector
;    btfss   trigger_flag, 0 ; Check if the first range finder has been used.
;    goto    interrupt_one   ; NO, measure the first range finder.
;    goto    interrupt_two   ; YES, measure the second range finder.
;    return  
;
;org 0x100
;ranger_main:
;    call    ranger_init
;    clrf    trigger_flag
;    call    trigger_one
;    bsf     trigger_flag, 0
;    call    trigger_two
;    goto    ranger_main
;    
;ranger_init:
;    clrf	 PIR4
;    bsf          PIE4,   1           ; Enable CCP4 interrupt
;    bsf          PIE4,   2           ; Enable CCP5 interrupt
;    bsf          INTCON, 6	     ; Enable peripheral interrupt
;    bsf          INTCON, 7	     ; Enable global interrupt
;    bsf          IPR4,   1           ; Set CCP4 interrupt as high priority
;    bsf          IPR4,   2           ; Set CCP5 interrupt as high priority
;    return 
;    
;    
;interrupt_one:
;    btfss   PIR4, 1		; Check if interrupt has already occurred. 
;    goto    rising_one          ; NO, start the timer on the rising edge.
;    goto    falling_one         ; YES, stop the timer and move the values into memory.
;        
;    
;rising_one:
;    bcf	    PIE4,   1	; Temporarily disable interrupts
;    clrf    CCP4CON
;    movlw   0x04    
;    movwf   CCP4CON       ; Set the CCP4 control byte to capture mode and to 
;			  ; trigger on the falling edge now.
;    clrf    CCPTMRS1 
;    movlw   0x00  ; CCP4 is based off of TMR1.
;    movwf   CCPTMRS1     
;    movlw   0x31  ; Set the TMR1 to use F_osc/4 prescaled by 8.
;    movwf   T1CON
;    bsf	    PIE4, 1	; Re-enable
;    retfie
;    
;falling_one:
;    bcf	    PIE4,   1	; Temporarily disable interrupts
;    bsf     T1CON, 0         ; Turn TMR1 off
;    movff   TMR1L, time_one_L
;    movff   TMR1H, time_one_H
;    
;    goto    ranger_main
;    
;interrupt_two:
;    btfss   PIR4, 2 ; Check if interrupt has already occurred. 
;    goto    rising_two          ; NO, start the timer on the rising edge.
;    goto    falling_two        ; YES, stop the timer and move the values into memory.
;    
;rising_two:
;    clrf    CCP5CON
;    movlw   0x04    
;    movwf   CCP5CON       ; Set the CCP5 control byte to capture mode and to 
;                                             ; trigger on the falling edge now.
;    clrf    CCPTMRS1 
;    movlw   0x04  ; CCP5 is based off of TMR1.
;    movwf   CCPTMRS1     
;    movlw   0x31  ; Set the TMR1 to use F_osc/4 prescaled by 8.
;    movwf   T1CON
;    retfie
;    
;falling_two:
;    bcf	    PIE4,   2	; Temporarily disable interrupts
;    bsf     T1CON, 0         ; Turn TMR1 off
;    movff   TMR1L, time_two_L
;    movff   TMR1H, time_two_H
;    
;    return
;
;; exponential overshoot decreases the rising time
;    
;; this might be benefical
;    
;; increases inductance and capacitance
;    
;trigger_one:
;    ; Initialize the CCP interrupt and trigger the ultrasonic range finder.
;    bcf     PIR4, 1             ; CCP4IF, clear the interrupt flag 
;    clrf    CCP4CON
;    movlw   0x00
;    movwf   TRISG              ; Make all pins on PORTH outputs.
;    bsf     LATG, 3            ; Set pin 3 to be high.
;    call    pulse_delay 
;    bcf     LATG, 3            ; Set pin 3 to be low.
;    movlw   0xFF
;    movwf   TRISG              ; Make all pins on PORTH inputs
;    movlw   0x05  ; Interrupt on rising edge.
;    movwf   CCP4CON
;    call    wait_delay
;    return
;
;trigger_two:
;    ; Initialize the CCP4 capture module interrupt and trigger the ultrasonic 
;    ; range finder.
;    bcf     PIR5, 1             ; CCP5IF, clear the interrupt flag 
;    clrf    CCP5CON
;    movlw   0x00
;    movwf   TRISG		; Make all pins on PORTH outputs.
;    bsf     LATG, 4		; Set pin 4 to be high.
;    call    pulse_delay 
;    bcf     LATG, 4		; Set pin 4 to be low.
;    movlw   0xFF
;    movwf   TRISG		; Make all pins on PORTH inputs.
;    movlw   0x05		; Interrupt on rising edge.
;    movwf   CCP5CON
;    call    wait_delay
;    return

;#include <xc.inc>
;			  
;extrn pulse_delay, wait_delay
;    
;;flag_reg set 0x20	    ; Define a flag to reflect if the first range finder
;;			    ; has been activated or not.    
;
;psect udata_acs
;flag_reg:	ds 1	    ; Define a flag to reflect if the first range finder
;			    ; has been activated or not.
;time_one_H:	ds 1
;time_one_L:	ds 1
;time_two_H:	ds 1
;time_two_L:	ds 1
;			    
;global ranger_main, time_one_H, time_one_L, time_two_H, time_two_L 
;
;psect ranger_code, class = CODE, abs
;
;org 0x00
;start:
;    goto   ranger_main
;
;org 0x08
;interrupt_handler:
;    ; Interrupt vector
;;    btfss   flag_reg, 0	    ; Check if the first range finder has been used
;;    goto    interrupt_one   ; NO, measure the first range finder
;    goto    interrupt_two   ; YES, measure the second range finder
;    return  
;
;org 0x100
;ranger_main:
;    call    ranger_init
;;    call    trigger_one	    ; Trigger the first range finder
;;    bsf	    flag_reg,	0   ; Set the flag_reg bit to show that the first range
;;			    ; finder has been activated
;    call    trigger_two
;    goto    ranger_main
;    return
;    
;ranger_init:
;    clrf    time_one_H
;    clrf    time_one_L
;    clrf    time_two_H
;    clrf    time_two_L
;    bsf	    INTCON, 7	; Enable global interrupt
;    bsf	    INTCON, 6   ; Enable peripheral interrupt
;    bsf	    PIE4,   1	; Enable CCP4 interrupt
;    bsf	    PIE4,   2	; Enable CCP5 interrupt
;    bsf	    IPR4,   1	; Set CCP4 interrupt as high priority
;    bsf	    IPR4,   2	; Set CCP5 interrupt as high priority
;    clrf    flag_reg	; Clear flag register
;    return 
;        
;interrupt_one:
;    bcf	    PIE4,	1   ; Pause any other interrupts from CCP4
;    bcf	    PIR4,	1   ; CCP4IF, clear the interrupt flag
;    btfss   flag_reg,	1   ; Check if interrupt has already occurred
;    goto    rising_one	    ; NO, start timer on the rising edge
;    goto    falling_one	    ; YES, stop timer and move values into memory
;        
;interrupt_two:
;    bcf	    PIE4,	2   ; Pause any other interrupts from CCP5
;    bcf	    PIR4,	2   ; CCP5IF, clear the interrupt flag 	
;    btfss   flag_reg,	2   ; Check if interrupt has already occurred
;    goto    rising_two	    ; NO, start the timer on the rising edge
;    goto    falling_two	    ; YES, stop timer and move values into memory
;   
;rising_one:
;    clrf    CCP4CON
;    movlw   0x04    
;    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
;			; trigger on the falling edge now
;    clrf    CCPTMRS1 
;    movlw   0x00	; CCP4 is based off of TMR1
;    movwf   CCPTMRS1		
;    bsf	    PIE4,   1	; Re-enable interrupts from CCP4
;    movlw   0x31	; Set the TMR1 to use F_osc/4 prescaled by 8
;    movwf   T1CON	; Start the timer
;    return
;    
;falling_one:
;    bcf	    PIE4,   1		; Disable CCP4 interrupts to prevent any further
;				; interrupts
;    bsf	    T1CON, 0		; Turn TMR1 off
;    movff   TMR1L, time_one_L	; Move high byte into memory
;    movff   TMR1H, time_one_H	; Move low byte into memory
;    goto    ranger_main
;    
;    
;rising_two:
;    bcf	    PIE4,   1	; Disable CCP4 interrupts to prevent any further
;			; interrupts
;    clrf    CCP5CON
;    movlw   0x04    
;    movwf   CCP5CON	; Set the CCP5 control byte to capture mode and to 
;			; trigger on the falling edge now
;    clrf    CCPTMRS1 
;    movlw   0x00	; CCP5 is based off of TMR1
;    movwf   CCPTMRS1	
;    movlw   0x31	; Set the TMR1 to use F_osc/4 prescaled by 8
;    movwf   T1CON
;    return
;    
;falling_two:
;    bcf	    PIE4,   2		; Disable CCP4 interrupts to prevent any further
;				; interrupts
;    bsf	    T1CON,  0		; Turn TMR1 off
;    movff   TMR1L, time_two_L	; Move high byte into memory
;    movff   TMR1H, time_two_H	; Move low byte into memory
;    return
;    
;trigger_one:
;    ; Initialize the CCP interrupt and trigger the ultrasonic range finder.
;    bcf	    PIR4,   1	; CCP4IF, clear the interrupt flag 
;    clrf    CCP4CON
;    movlw   0x00
;    movwf   TRISG	; Make all pins on PORTG outputs.
;    bsf	    LATG,   3	; Set pin 3 to be high.
;    call    pulse_delay 
;    bcf	    LATG,   3	; Set pin 3 to be low.
;    movlw   0xFF
;    movwf   TRISG	; Make all pins on PORTG inputs
;    movlw   0x05	; Interrupt on rising edge.
;    movwf   CCP4CON
;    call    wait_delay
;    return
;
;trigger_two:
;    ; Initialize the CCP4 capture module interrupt and trigger the ultrasonic 
;    ; range finder.
;    bcf	    PIR4,   2	; CCP5IF, clear the interrupt flag 	
;    clrf    CCP5CON
;    movlw   0x00
;    movwf   TRISG	; Make all pins on PORTH outputs.
;    bsf	    LATG,   4	; Set pin 4 to be high.
;    call    pulse_delay 
;    bcf	    LATG,   4	; Set pin 4 to be low.
;    movlw   0xFF
;    movwf   TRISG	; Make all pins on PORTH inputs.
;    movlw   0x05	; Interrupt on rising edge.
;    movwf   CCP5CON
;    call    wait_delay
;    return

    
