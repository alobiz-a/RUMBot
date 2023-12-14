#include <xc.inc>

psect udata_acs
 
tflag:	    ds 1 
time_one_L: ds 1
time_one_H: ds 1
time_two_L: ds 1
time_two_H: ds 1
    
psect code, class = CODE, abs

extrn pulse_delay, ranging_delay, wait_delay
 
global ranger_main, time_one_L, time_one_H, time_two_L, time_two_H

rst:
    org 0x00	; Reset vector 
    call ranger_main
    goto rst
    
trigger_one:
    banksel ANCON2	; Select bank with ACON2 register
    movlw   0x00
    movwf   ANCON2
    banksel TRISG
    movlw   0x00
    movwf   TRISG	; Make all pins on PORTG outputs
    bsf     LATG, 3     ; Set pin 3 to be high
    call    pulse_delay ; 10 us delay
    bcf     LATG, 3	; Set pin 3 to be low.
    movlw   0xFF	
    movwf   TRISG	; Make all pins on PORTG inputs
    
    

