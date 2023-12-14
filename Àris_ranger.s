#include <xc.inc>

psect udata_acs
 
tflag:	    ds 1 
time_one_L: ds 1
time_one_H: ds 1
time_two_L: ds 1
time_two_H: ds 1
    
psect code, class = CODE, abs

extrn pulse_delay, wait_delay
 
global ranger_main, time_one_L, time_one_H
 
rst:
    org 0x00	; Reset vector 
    goto ranger_main  
    
interrupt:
  
    org	    0x08
    call    flash
    btfss   flag, 0, A		; Is the 1st msb flag byte set?
    goto    interrupt_one	; No, the first rangefinder is being used
    goto    interrupt_two	; Yes, the second rangefinder is being used
    
