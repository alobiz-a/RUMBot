; main file to control the motor, the LCD and the ranger
#include <xc.inc>

extrn	PWM_90R, PWM_45R, PWM_0, PWM_45L, PWM_90L
extrn	Delay_3s
global	Set_Mdelay_counter, M_loop_90R1, M_loop_45R1, M_loop_01, M_loop_45L1, M_loop_90L1

psect	udata_acs   ; named variables in access ram
MD1:  ds	1   ; the motor delay counters
MD2:  ds	1
MD3:  ds	1

psect servo_code, class= CODE

;**********************************************************
;CONFIGURE DELAYS
Set_Mdelay_counter:
    movlw 0X01
    movwf MD1
    movlw 0X57
    movwf MD2
    movlw 0Xa3
    movwf MD3
    return  
;******************************************************
M_loop_90R1:
    call PWM_90R
    dcfsnz MD1, 1
    goto M_loop_90R2
    goto M_loop_90R1
M_loop_90R2:
    call PWM_90R
    dcfsnz MD2, 1
    goto M_loop_90R3
    goto M_loop_90R2
M_loop_90R3:
    call PWM_90R
    decfsz MD3, 1
    goto M_loop_90R3
    return
    
;*******************************************
M_loop_45R1:
    call PWM_45R
    dcfsnz MD1, 1
    goto M_loop_45R2
    goto M_loop_45R1
M_loop_45R2:
    call PWM_45R
    dcfsnz MD2, 1
    goto M_loop_45R3
    goto M_loop_45R2
M_loop_45R3:
    call PWM_45R
    decfsz MD3, 1
    goto M_loop_45R3
    return
;**************************************************************
M_loop_01:
    call PWM_0
    dcfsnz MD1, 1
    goto M_loop_02
    goto M_loop_01
M_loop_02:
    call PWM_0
    dcfsnz MD2, 1
    goto M_loop_03
    goto M_loop_02
M_loop_03:
    call PWM_0
    decfsz MD3, 1
    goto M_loop_03
    return
    
;*********************************************************
M_loop_45L1:
    call PWM_45L
    dcfsnz MD1, 1
    goto M_loop_45L2
    goto M_loop_45L1
M_loop_45L2:
    call PWM_45L
    dcfsnz MD2, 1
    goto M_loop_45L3
    goto M_loop_45L2
M_loop_45L3:
    call PWM_45L
    decfsz MD3, 1
    goto M_loop_45L3
    return  

;******************************************************
M_loop_90L1:
    call PWM_90L
    dcfsnz MD1, 1
    goto M_loop_90L2
    goto M_loop_90L1
M_loop_90L2:
    call PWM_90L
    dcfsnz MD2, 1
    goto M_loop_90L3
    goto M_loop_90L2
M_loop_90L3:
    call PWM_90L
    decfsz MD3, 1
    goto M_loop_90L3
    return
