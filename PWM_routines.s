#include <xc.inc>

global PWM_90R, PWM_45R, PWM_0, PWM_45L, PWM_90L
    
psect	udata_acs   ; named variables in access ram
DCounter1:  ds	1
DCounter2:  ds	1
DCounter3:  ds	1
DCounter4:  ds	1   ; used to be DCounter2 EQU 0X0D
DCounter5:  ds	1

psect	pwm_delay_code,class=CODE



PWM_90R:;**************************************************************       
DutyCycle_90R:
    movlw 0X8C
    movwf DCounter1
    movlw 0X2A
    movwf DCounter2
    bsf	    LATC, 5
    call DC_loop
    bcf	    LATC, 5    ;  1.75 ms                                         

Period:;18.25
    movlw 0X01
    movwf DCounter3
    movlw 0X77
    movwf DCounter4
    movlw 0X02
    movwf DCounter5
    call P_loop

    return
;*******************************************************************
    
PWM_45R:;**************************************************************       
DutyCycle_45R:
    movlw 0X5A
    movwf DCounter1
    movlw 0X25
    movwf DCounter2
    bsf	    LATC, 5
    call DC_loop
    bcf	    LATC, 5
Period_45R:
    movlw 0X33
    movwf DCounter3
    movlw 0X7C
    movwf DCounter4
    movlw 0X02
    movwf DCounter5
    call P_loop

    return   
;**********************************************************
PWM_0:;**************************************************************       
DutyCycle_0:
    movlw 0X28
    movwf DCounter1
    movlw 0X20
    movwf DCounter2
    bsf	    LATC, 5
    call DC_loop
    bcf	    LATC, 5
Period_0:
    movlw 0X65
    movwf DCounter3
    movlw 0X81
    movwf DCounter4
    movlw 0X02
    movwf DCounter5
    call P_loop

    return 
    
PWM_45L:;**************************************************************       
DutyCycle_45L:
    movlw 0Xf7
    movwf DCounter1
    movlw 0X1a
    movwf DCounter2
    bsf	    LATC, 5
    call DC_loop
    bcf	    LATC, 5
Period_45L:
    movlw 0X97
    movwf DCounter3
    movlw 0X86
    movwf DCounter4
    movlw 0X02
    movwf DCounter5
    call P_loop

    return   
;**********************************************************   
PWM_90L:;**************************************************************       
DutyCycle_90L:
    movlw 0XC5
    movwf DCounter1
    movlw 0X15
    movwf DCounter2
    bsf	    LATC, 5
    call DC_loop
    bcf	    LATC, 5
Period_90L:
    movlw 0XC9
    movwf DCounter3
    movlw 0X8B
    movwf DCounter4
    movlw 0X02
    movwf DCounter5
    call P_loop

    return    
    
;*****LOOOP**DI**LOOP****************************************    
DC_loop:
    decfsz DCounter1, 1
    goto DC_loop
    decfsz DCounter2, 1
    goto DC_loop
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