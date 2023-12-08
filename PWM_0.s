#include <xc.inc>
    
psect	udata_acs   ; named variables in access ram
DCounter1:  ds	1
DCounter2:  ds	1
DCounter3:  ds	1
DCounter4:  ds	1   ; used to be DCounter2 EQU 0X0D
DCounter5:  ds	1

psect	pwm_delay_code,class=CODE

setup_PWM:; cofigure pin RC1
    clrf PORTC      ; clear portc (set pins to a low voltage/0 state)
    clrf TRISC

PWM_loop_0:       
    call DutyCycle    ;  1.5 ms                                         
    call Period	;   18.5 ms
    goto PWM_loop_0 

    
DutyCycle:
    movlw 0X28
    movwf DCounter1
    movlw 0X20
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
    movlw 0X65
    movwf DCounter3
    movlw 0X81
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


