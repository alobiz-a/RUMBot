#include <xc.inc>
    
psect delay_code, class = CODE
 
global pulse_delay, ranging_delay, wait_delay

pd1:	ds 1
rd1:	ds 1
rd2:	ds 1
wd1:	ds 1
wd2:	ds 1
wd3:	ds 1

;org 0x00
pulse_delay: ; Generate 10 us delay.
    movlw   0X22
    movwf   pd1

pulse_delay_loop:
    nop
    nop
    decfsz  pd1, 1
    goto    pulse_delay_loop
    return
    
ranging_delay: ; Generate a 500 us delay.
    movlw   0x61
    movwf   rd1
    movlw   0x0b
    movwf   rd2

ranging_delay_loop:
    decfsz  rd1, 1
    goto    ranging_delay_loop
    decfsz  rd2, 1
    goto    ranging_delay_loop
    return    

wait_delay: ; Generate a 60 ms delay. Made using an online delay generator.
    movlw   0xBA
    movwf   wd1
    movlw   0xDF
    movwf   wd2
    movlw   0x05
    movwf   wd3

wait_delay_loop:
    decfsz  wd1, 1
    goto    wait_delay_loop
    decfsz  wd2, 1
    goto    wait_delay_loop
    decfsz  wd3, 1
    goto    wait_delay_loop
    nop
    return

 end