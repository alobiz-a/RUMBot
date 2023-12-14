
#include <xc.inc>
    
extrn pulse_delay, wait_delay
global ranger_main, time_one_L, time_one_H
    
psect udata_acs
 
occured:    ds 1 ; Has an interrupt happened (c.a.d. we on the rising or falling edge)?
time_one_L: ds 1    ;low bit for ranger 1
time_one_H: ds 1    ;high bit for ranger 1

    
psect code, class = CODE, abs
 
rst:
    org 0x00	; Reset vector 
    clrf    PORTG
    goto ranger_main

    
interrupt:
    org	    0x08
    btfss   occured, 0, A		; Has an interrupt already happened?
    goto    interrupt_rise	; No, go to rising edge interrupt
    goto    interrupt_fall	; Yes, go to falling edge interrupt
    ;might need to check if correct CCP module

ranger_main:
    
    ;call    trigger_ranger
    call    interrupt_setup ;Initialise the interrupts (ensure everything is cleared)
    call    trigger_test
    call    wait_delay
    call    wait_delay
    call    wait_delay
    goto    ranger_main	;stay here until an interrupt causes us to jump out
    
interrupt_setup:
    ; Initialize interrupts and flags
    bsf	    INTCON, 6	; Enable all unmasked interrupts
    bsf	    INTCON, 7	; Enable peripheral interrupt
    bsf	    CCP4IE	; Enable interrupts
    ;A. QUESTION do we need to disable IPEN?
    ;clrf    PIR4	; Clear all interrupt flags
    bsf	    IPR4, 1	; Set CCP4 interrupt as high priority
    clrf    occured	; Clear flag byte: an interrupt has not yet occured
    return

trigger_test:
    bsf     LATG, 3     ; Set pin 3 to be high
    call    pulse_delay ; 10 us delay
    bcf     LATG, 3	; Set pin 3 to be low.
    
trigger_ranger:
    ;********Setting the pins*******
    movlw   0x00
    movwf   TRISG	; Make all pins on PORTG outputs
    ;********Send pulse*************
    bsf     LATG, 3     ; Set pin 3 to be high
    call    pulse_delay ; 10 us delay
    bcf     LATG, 3	; Set pin 3 to be low.
    ;********Set pins as inputs*********
    movlw   0xFF	
    movwf   TRISG	; Make all pins on PORTG inputs
    ;********Set up to capture on rising edge******
    clrf    CCP4CON	
    movlw   0x05		
    movwf   CCP4CON	; Set the CCP4 control byte to capture mode and to 
    			; trigger on the rising edge (CCP4M = 0101)
    ;********Set PORTG to digital**************( A. PUT IN SETUP!!)*******
    banksel ANCON2	;points to it
    clrf    ANCON2	; 0 = digital
    banksel 0		; default
    ;***********SET PORTE AS OUTPUT FOR DEBUGGING PURPOSES************
    clrf    TRISE	
    movff   PORTG, LATE	; Display what's happening on G to E to prove we can read
;    goto    tstlp   ;INFINITE?????
;    call    wait_delay
    ;*************************(ABOVE GOES IN SETUP)***********************
    return

    
interrupt_rise:

    ;***********Clear interrupt flag and 
    bcf	    CCP4IE	;clear interrupt flag for these instructions
    bcf	    CCP4IF	;added
    call    flash   ;for debugging
    bsf   occured, 0 ; An interrupt has occured	
    ;**********TRIGGER ON FALLING EDGE************************
    clrf    CCP4CON
    movlw   0x04    
    movwf   CCP4CON 
    ;*********START TIMERS**********
    movlw   0x00
    movwf   CCPTMRS1	; CCP4 is based off of TMR1
    clrf    TMR1H   ;clear timers just in case
    clrf    TMR1L
    movlw   0x33    ; that's turning on the timer	- CHANGED TO 0X33 FROM 0X31
    movwf   T1CON	; Set TMR1 to use F_osc/4 prescaled by a factor of 8, INITIALISE TIMER
    bsf	    CCP4IE 	; Re-enable the CCP4 interrupt (INTERRUPT ENABLE bit) - A. CHECK W MARK! 
    bcf	    CCP4IF
    retfie	f
   
interrupt_fall:
    ;***********Clear interrupt flag and 
    bcf	    CCP4IE	;clear interrupt flag for these instructions
    call    flash   ;for debugging
    ;***********Turn off timer************
    bsf	    T1CON, 0		; Turn off TMR1
    movff   CCPR4H, time_one_H	; Move timer high byte into high byte storage
    movff   CCPR4L, time_one_L	; Move timer low byte into low byte storage
    bcf	    CCP4IF  ; need to add! 
    bcf    occured,0	; Clear flag byte: an interrupt has not yet occured
    
    retfie  f    


 
    
       
flash:
    clrf    LATA
    movlw   0x00
    movwf   TRISA	; Make all pins on PORTB outputs
    bsf     LATA, 4     ; Set pin 4 to be high
    call    pulse_delay ; 10 us delay
    call    pulse_delay ; 10 us delay
    call    pulse_delay ; 10 us delay
    bcf     LATA, 4	; Set pin 4 to be low.
    clrf    LATA
    
    return
    

    end ranger_main


