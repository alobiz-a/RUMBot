#include <xc.inc>

psect	code, abs
extrn pulse_delay, ranging_delay, wait_delay

rst:		; Reset vector
    org 0x0000
    goto start
    
int_hi: org 0x0008
    goto bs_interrupt_routine
    
    
start:		 ; Initialisation of ports and processes
    bcf		CFGS	; point to Flash program memory  
    bsf		EEPGD 	; access Flash program memory
    clrf	LATE	; turn off PORTE
    ;call	light_up
    ;call	initialise_interrupts
    call	light_up
    call	trigger_ranger
    call	pulse_delay
    goto	start

;***********STEPS*******************
    ;0. Initialise the ranger
    ;1. Trigger Ultrasound: Send trigger pulse to Ultrasound sensors
    ;2. 
;*************ROUTINES**************
initialise_interrupts:
    bsf	    INTCON, 6	; Enable peripheral interrupt
    bsf	    INTCON, 7	; Enable global interrupt
    bsf	    PIE4, 1	; Set CCP4 interrupt
    bsf     IPR4, 1     ; Set CCP4 interrupt as high priority
    clrf    PIR4	; Clear interrupt flag register
    movlw   0x04
    movwf   CCP4CON	; Set the CCP4 control byte to capture mode on the FALLING EDGE
    return

trigger_ranger:
    movlw   0x00
    movwf   TRISG	; Make all pins on PORTG outputs.
    ;*****************************
    bsf     LATG, 3	; Set pin 3 to be high.
    call    pulse_delay
    bcf	    LATG, 3
    movlw   0xFF
    movwf   TRISG	;set all pins to read mode
    ;********************
    return
    
bs_interrupt_routine:
    ;**********LIGHT UP PORTE***********
    movlw   0x00
    movwf   TRISE
    movlw   0xFF
    movwf   LATE
    clrf    PIR4

    retfie  f

light_up:
    movlw   0x00
    movwf   TRISE
    movlw   0xFF
    movwf   LATE
    return
    