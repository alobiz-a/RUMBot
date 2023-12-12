;#include <xc.inc>
;    
;psect code, abs
;
;extrn pulse_delay, wait_delay 
; 
;org 0x00
;start:
;    goto test_main
;
;test_main:
;    movlw   0x00
;    movwf   TRISB
;    movlw   0xFF
;    movwf   LATB
;    call wait_delay
;    call wait_delay
;    call wait_delay
;    call wait_delay
;    call wait_delay
;    movlw   0x00
;    movwf   LATB
;    call wait_delay
;    call wait_delay
;    call wait_delay
;    call wait_delay
;    call wait_delay
;    goto test_main
    
; 
;time_one_H:	ds 1
;time_one_L:	ds 1
;time_two_H:	ds 1
;time_two_L:	ds 1 
; 
;org 0x00
;start:
;    goto test_main
;
;;test_main:
;;    movlw   0x00
;;    movwf   TRISB
;;    movlw   0xFF
;;    movwf   LATB
;;    call wait_delay
;;    call wait_delay
;;    call wait_delay
;;    call wait_delay
;;    call wait_delay
;;    movlw   0x00
;;    movwf   LATB
;;    call wait_delay
;;    call wait_delay
;;    call wait_delay
;;    call wait_delay
;;    call wait_delay
;;    goto test_main
;    
;    
;org 0x08
;interrupt_handler:
;    movlw 0x00
;    movwf TRISB
;    movlw   0x00
;    movwf    LATB	; Set all pins on PORTB low.
;    call wait_delay
;    goto $
;
;test_main:
;    movlw 0x00
;    movwf TRISB
;    movlw   0xFF
;    movf    LATB	; Set all pins on PORTB high.
;    call wait_delay
;    bsf	    INTCON, 7	; Enable global interrupt
;    bsf	    INTCON, 6   ; Enable peripheral interrupt
;    movlw   0xFF
;    movwf   TRISG	; Make all pins on PORTG inputs
;    bsf	    PIE4, 1	; Enable CCP4 interrupt
;    bsf	    RCON, 7	; Enable interrupt priorities
;    bsf	    IPR4, 1	; Make CCP4 interrupt high priority
;    clrf    CCP4CON
;    movlw   0x05	; Interrupt on rising edge.
;    movwf   CCP4CON
;    bcf	    PIR4, 1	; CCP4IF, clear the interrupt flag 
;    goto $
;    
;    
;    
;    
;    
;    
;    
;    ;start:
;;    goto    ranger_main
;;
;;org 0x08
;;interrupt_handler:
;;    ; Interrupt vector
;;    movlw   0x00
;;    movf    TRISB	; Set all pins on PORTB as outputs.
;;    movlw   0xFF
;;    movf    LATB	; Set all pins on PORTB low.
;;    goto    interrupt_one   ; NO, measure the first range finder.
;;    return  
;;
;;org 0x100
;;ranger_main:
;;    movlw   0x00
;;    movf    TRISB	; Set all pins on PORTB as outputs.
;;    movlw   0x00
;;    movf    LATB	; Set all pins on PORTB low.
;;    bsf	    PIE4, 0	; Enable CCP4 interrupt
;;    bsf	    INTCON, 7	; Enable global interrupt
;;    bsf	    INTCON, 6   ; Enable peripheral interrupt
;;    call    trigger_one
;;    call    wait_delay
;;    call    wait_delay
;;    call    wait_delay
;;    goto ranger_main
;; 
;;trigger_one:
;;    ; Initialize the CCP interrupt and trigger the ultrasonic range finder.
;;    bcf	    PIR4, 1	; CCP4IF, clear the interrupt flag 
;;    clrf    CCP4CON
;;    movlw   0x00
;;    movwf   TRISG	; Make all pins on PORTH outputs.
;;    bsf	    LATG, 3	; Set pin 3 to be high.
;;    call    pulse_delay 
;;    bcf	    LATG, 3	; Set pin 3 to be low.
;;    movlw   0xFF
;;    movwf   TRISG	; Make all pins on PORTH inputs
;;    movlw   0x05	; Interrupt on rising edge.
;;    movwf   CCP4CON
;;    call    wait_delay
;;    return    
;;    
;;interrupt_one:
;;    movlw   0x00
;;    movf    TRISB	; Set all pins on PORTB as outputs.
;;    movlw   0xFF
;;    movf    LATB	; Set all pins on PORTB high.
;;    btfss   PIR4, 1	; Check if interrupt has already occurred. 
;;    goto    rising_one	; NO, start the timer on the rising edge.
;;    goto    falling_one	; YES, stop the timer and move the values into memory.
;;    
;;rising_one:
;;    movlw   0x00
;;    movf    TRISB	; Set all pins on PORTB as outputs.
;;    movlw   0xFF
;;    movf    LATB	; Set all pins on PORTB high.
;;    clrf    CCP4CON
;;    movlw   0x04    
;;    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
;;			; trigger on the falling edge now.
;;    clrf    CCPTMRS1 
;;    movlw   0x00	; CCP4 is based off of TMR1.
;;    movwf   CCPTMRS1	
;;    movlw   0x31	; Set the TMR1 to use F_osc/4 prescaled by 8.
;;    movwf   T1CON
;;    return
;;    
;;falling_one:
;;    bsf	    T1CON, 0	; Turn TMR1 off
;;    movff   TMR1L, time_one_L
;;    movff   TMR1H, time_one_H
;;    movlw   0x00
;;    movwf   TRISB
;;    movff   TMR1H, LATB
;;;    movlw   0x00
;;;    movf    TRISB	; Set all pins on PORTB as outputs.
;;;    movlw   0x00
;;;    movf    LATB	; Set all pins on PORTB low.
;;    call wait_delay
;;    return
; 
;;org 0x00
;;start:
;;    movlw   0x00
;;    movwf    TRISH	; Set all pins on PORTB as outputs.
;;    goto check_rising_edge
;; 
;;check_rising_edge:
;;    movlw   0xFF
;;    movwf   LATH	; Set all pins on PORTB high.
;;    call wait_delay
;;    call wait_delay
;;    call wait_delay
;;    call wait_delay
;;    movlw 0x00
;;    movwf    LATH
;;    call wait_delay
;;    goto    check_rising_edge		; Stay on current line.
;; 
;    
;;org 0x08    
;;test_ipt_handler:
;;    goto rising_edge_ipt
;;;    btfss   PIR4, 1	; Check if interrupt has already occurred. 
;;;    goto    rising_edge_ipt	; NO, start the timer on the rising edge.
;;;    goto    falling_edge_ipt	; YES, stop the timer and move the values into memory.
;;
;;check_rising_edge:
;;    bsf	    PIE4, 0	; Enable CCP4 interrupt
;;    bsf	    INTCON, 7	; Enable global interrupt
;;    bsf	    INTCON, 6   ; Enable peripheral interrupt
;;    bcf	    PIR4, 1	; CCP4IF, clear the interrupt flag 
;;    movlw   0x00
;;    movwf   TRISH	; Make all pins on PORTH outputs.
;;    bsf	    LATH, 3	; Set pin 3 to be high.
;;    call    pulse_delay 
;;    bcf	    LATH, 3	; Set pin 3 to be low.
;;    movlw   0xFF
;;    movwf   TRISH	; Make all pins on PORTH inputs.
;;    clrf    CCP4CON
;;    movlw   0x05	; Interrupt on rising edge.
;;    movwf   CCP4CON
;;    call    wait_delay
;;    
;;rising_edge_ipt:
;;    movlw   0x00
;;    movf    TRISB	; Set all pins on PORTB as outputs.
;;    movlw   0xFF
;;    movf    LATB	; Set all pins on PORTB high.
;;    goto $		; Stay on current line.
;;
;;
;;;rising_edge_ipt:
;;;    clrf    CCP4CON
;;;    movlw   0x04    
;;;    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
;;;			; trigger on the falling edge now.
;;;    retfie
;;    
;;falling_edge_ipt:
;;    bsf	    T1CON, 0	; Turn TMR1 off
;;    movlw   0x00
;;    movf    TRISB	; Set all pins on PORTB as outputs.
;;    movff   TMR1H, LATB ; Output time on PORTB pins.
;;    goto $