#include <xc.inc>
    
psect code
 
global pulse_delay, wait_delay

pulse_delay: ; Generate 10 us delay.
movlw 0X33
movwf shortdelay1

pulse_delay_loop:
nop
nop
decfsz shortdelay1, 1
goto pulse_delay_loop
return

wait_delay: ; Generate a 60 ms delay. Made using an online delay generator.
movlw 0xBA
movwf longdelay1
movlw 0xDF
movwf longdelay2
movlw 0x05
movwf longdelay3

wait_delay_loop:
decfsz longdelay1, 1
goto wait_delay_loop
decfsz longdelay2, 1
goto wait_delay_loop
decfsz longdelay3, 1
goto wait_delay_loop
nop
return


