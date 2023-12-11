#include <xc.inc>
    
psect delay_code, class = CODE
 
global pulse_delay, wait_delay

sd1: ds 1
ld1: ds 1
ld2: ds 1
l3: ds 1

org 0x00
pulse_delay: ; Generate 10 us delay.
    movlw   0X22
    movwf   sd1

pulse_delay_loop:
    nop
    nop
    decfsz  sd1, 1
    goto    pulse_delay_loop
    return

wait_delay: ; Generate a 60 ms delay. Made using an online delay generator.
    movlw   0xBA
    movwf   ld1
    movlw   0xDF
    movwf   ld2
    movlw   0x05
    movwf   ld3

wait_delay_loop:
    decfsz  ld1, 1
    goto    wait_delay_loop
    decfsz  ld2, 1
    goto    wait_delay_loop
    decfsz  ld3, 1
    goto    wait_delay_loop
    nop
    return


