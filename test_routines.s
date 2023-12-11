#include <xc.inc>
    
psect code, abs

extrn pulse_delay, wait_delay 
 
org 0x00
start:
    goto check_rising_edge
 
org 0x08    
test_ipt_handler:
    goto rising_edge_ipt
;    btfss   PIR4, 1	; Check if interrupt has already occurred. 
;    goto    rising_edge_ipt	; NO, start the timer on the rising edge.
;    goto    falling_edge_ipt	; YES, stop the timer and move the values into memory.

check_rising_edge:
    bsf	    PIE4, 0	; Enable CCP4 interrupt
    bsf	    INTCON, 7	; Enable global interrupt
    bsf	    INTCON, 6   ; Enable peripheral interrupt
    bcf	    PIR4, 1	; CCP4IF, clear the interrupt flag 
    movlw   0x00
    movwf   TRISH	; Make all pins on PORTH outputs.
    bsf	    LATH, 3	; Set pin 3 to be high.
    call    pulse_delay 
    bcf	    LATH, 3	; Set pin 3 to be low.
    movlw   0xFF
    movwf   TRISH	; Make all pins on PORTH inputs.
    clrf    CCP4CON
    movlw   0x05	; Interrupt on rising edge.
    movwf   CCP4CON
    call    wait_delay
    
rising_edge_ipt:
    movlw   0x00
    movf    TRISB	; Set all pins on PORTB as outputs.
    movlw   0xFF
    movf    LATB	; Set all pins on PORTB high.
    goto $		; Stay on current line.


;rising_edge_ipt:
;    clrf    CCP4CON
;    movlw   0x04    
;    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
;			; trigger on the falling edge now.
;    retfie
    
falling_edge_ipt:
    bsf	    T1CON, 0	; Turn TMR1 off
    movlw   0x00
    movf    TRISB	; Set all pins on PORTB as outputs.
    movff   TMR1H, LATB ; Output time on PORTB pins.
    goto $