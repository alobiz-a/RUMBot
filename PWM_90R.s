#include <xc.inc>

global PWM_90R
    
psect	udata_acs   ; named variables in access ram
DCounter1:  ds	1
DCounter2:  ds	1
DCounter3:  ds	1
DCounter4:  ds	1   ; used to be DCounter2 EQU 0X0D
DCounter5:  ds	1

psect	pwm_delay_code,class=CODE


PWM_90R:       
    call DutyCycle    ;  1.75 ms                                         
    call Period	;   18.25 ms
    ;goto PWM_loop_90R - 11.12.23 I COMMENTED THIS OUT
    return

    
DutyCycle:
    movlw 0X8C
    movwf DCounter1
    movlw 0X2A
    movwf DCounter2
    bsf	    LATC, 5
    call DC_loop
    bcf	    LATC, 5
    return
    
DC_loop:
    decfsz DCounter1, 1
    goto DC_loop
    decfsz DCounter2, 1
    goto DC_loop
    return
    
Period:
    movlw 0X01
    movwf DCounter3
    movlw 0X77
    movwf DCounter4
    movlw 0X02
    movwf DCounter5
    call P_loop
    return
    
P_loop:
    decfsz DCounter3, 1
    goto P_loop
    decfsz DCounter4, 1
    goto P_loop
    decfsz DCounter5, 1
    goto P_loop
    nop
    nop ;*******Deleted to compensate for the extra instruction I have when calling it***
    return








