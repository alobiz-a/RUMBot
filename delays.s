#include <xc.inc>
    

global pulse_delay, ranging_delay, wait_delay, Delay_3s, delay_1s

psect	udata_acs   ; named variables in access ram    
pd1:	ds 1
rd1:	ds 1
rd2:	ds 1
wd1:	ds 1
wd2:	ds 1
wd3:	ds 1
D1:  ds	1
D2:  ds	1
D3:  ds	1
sd1:	ds 1
sd2:	ds 1
sd3:	ds 1
psect delay_code, class = CODE
 

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
    
Delay_3s:   ; 3s delay
    movlw 0X03
    movwf D1
    movlw 0X82
    movwf D2
    movlw 0XF4
    movwf D3
loop3:
    decfsz D1, 1
    goto loop3
    decfsz D2, 1
    goto loop3
    decfsz D3, 1
    goto loop3
    return
    
    
delay_1s:   ; 1s delay
    movlw 0XFF
    movwf sd1
    movlw 0X2B
    movwf sd2
    movlw 0X52
    movwf sd3
LOOP_1s:
    decfsz sd1, 1
    goto LOOP_1s
    decfsz sd2, 1
    goto LOOP_1s
    decfsz sd3, 1
    goto LOOP_1s
    nop
    nop
    return
    
    
 end


