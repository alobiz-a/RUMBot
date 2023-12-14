#include <xc.inc>

psect udata_acs
 
flag:	    ds 1 
time_one_L: ds 1
time_one_H: ds 1
time_two_L: ds 1
time_two_H: ds 1
    
psect code, class = CODE, abs

extrn pulse_delay, wait_delay
 
global ranger_main, time_one_L, time_one_H, time_two_L, time_two_H
 
rst:
    org 0x00	; Reset vector 
    call ranger_main
    goto $
    
interrupt:
    org	    0x08
    btfss   flag, 0, A		; Is the 1st msb flag byte set?
    goto    interrupt_one	; No, the first rangefinder is being used
    goto    interrupt_two	; Yes, the second rangefinder is being used
    
init:
    ; Initialize interrupts and flags
    bsf	    INTCON, 6	; Enable all unmasked interrupts
    bsf	    INTCON, 7	; Enable peripheral interrupt
    ;bsf	    PIE4, 1	; Enable CCP4 interrupt
    bsf	    CCP4IE
    ;bsf	    PIE4, 2	; Enable CCP5 interrupt
    bsf	    CCP5IE
    ;bsf	    RCON, 7	; Enable interrupt priority
    bcf	    IPEN
    bsf	    IPR4, 1	; Set CCP4 interrupt as high priority
    bsf	    IPR4, 2	; Set CCP5 interrupt as high priority
    clrf    PIR4	; Clear all interrupt flags
    clrf    flag	; Clear flag byte
    return
    
trigger_one:
;    movlw   0x00
;    movwf   TRISG	; Make all pins on PORTG outputs
;    bsf     LATG, 3     ; Set pin 3 to be high
;    call    pulse_delay ; 10 us delay
;    bcf     LATG, 3	; Set pin 3 to be low.
    movlw   0xFF	
    movwf   TRISG	; Make all pins on PORTG inputs
    clrf    CCP4CON	
    movlw   0x05	
    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
    			; trigger on the rising edge (CCP4M = 0101)
tst:
    banksel ANCON2
    clrf    ANCON2
    banksel 0
    clrf    TRISE
tstlp:
    movff   PORTG, LATE
    goto    tstlp
    call    wait_delay
    return

trigger_two:
    movlw   0x00
    movwf   TRISG	; Make all pins on PORTG outputs
    bsf     LATG, 4     ; Set pin 4 to be high
    call    pulse_delay ; 10 us delay
    bcf     LATG, 4	; Set pin 4 to be low.
    movlw   0xFF	
    movwf   TRISG	; Make all pins on PORTG inputs
    clrf    CCP5CON	
    movlw   0x05	
    movwf   CCP5CON	; Set the CCP5 control byte to capture mode and to 
			; trigger on the rising edge (CCP4M = 0101)
    call    wait_delay
    return
    
interrupt_one:
    bcf	    PIE4,   1	; Disable CCP4 interrupt
    call    flash
    btfss   flag, 1	; Is the 2nd msb of the flag byte set?
    goto    rising_one	; No, the rising edge has been detected
    goto    falling_one	; Yes, the falling edge has been detected
    return
    
interrupt_two:
    bcf	    PIE4,   2	; Disable CCP5 interrupt
    call    flash
    btfss   flag, 2	; Is the 2nd msb of the flag byte set?
    goto    rising_one	; No, the rising edge has been detected
    goto    falling_one	; Yes, the falling edge has been detected
    return
    
flash:
    movlw   0x00
    movwf   TRISB	; Make all pins on PORTB outputs
    bsf     LATB, 4     ; Set pin 4 to be high
    call    pulse_delay ; 10 us delay
    call    pulse_delay ; 10 us delay
    call    pulse_delay ; 10 us delay
    bcf     LATB, 4	; Set pin 4 to be low.
    return
    
rising_one:
    clrf    CCP4CON
    clrf    TMR1H
    clrf    TMR1L
    movlw   0x04    
    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
			; trigger on the falling edge (CCP4M = 0100)
    movlw   0x00
    movwf   CCPTMRS1	; CCP4 is based off of TMR1
    movlw   0x31	
    movwf   T1CON	; Set TMR1 to use F_osc/4 prescaled by a factor of 8
    bsf	    PIE4, 1	; Re-enable the CCP4 interrupt
    call    wait_delay
    return
    
rising_two:
    clrf    CCP5CON
    clrf    TMR1H
    clrf    TMR1L
    movlw   0x04    
    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
			; trigger on the falling edge (CCP4M = 0100)
    movlw   0x00
    movwf   CCPTMRS1	; CCP4 is based off of TMR1
    movlw   0x31	
    movwf   T1CON	; Set TMR1 to use F_osc/4 prescaled by a factor of 8
    bsf	    PIE4, 1	; Re-enable the CCP4 interrupt
    bsf	    PIE4, 2	; Re-enable the CCP5 interrupt
    call    wait_delay
    return
    
falling_one:
    bsf	    T1CON, 0		; Turn off TMR1
    movff   TMR1L, time_one_L	; Move timer low byte into low byte storage
    movff   TMR1H, time_one_H	; Move timer high byte into high byte storage
    retfie	    

falling_two:
    bsf	    T1CON, 0		; Turn off TMR1
    movff   TMR1L, time_one_L	; Move timer low byte into low byte storage
    movff   TMR1H, time_one_H	; Move timer high byte into high byte storage
    retfie
    
ranger_main:
    call    init
    call    trigger_one	
    bsf	    flag, 0	; Set final bit of the flag byte
    ;call    trigger_two
    return
    
    end rst