#include <xc.inc>

global DutyCycle_90L_DELAY, Period_delay_90L, DutyCycle_45L_DELAY, Period_delay_45L 
global DutyCycle_0_DELAY, Period_delay_0
global DutyCycle_90R_DELAY, Period_delay_90R, DutyCycle_45R_DELAY, Period_delay_45R 
    

psect	udata_acs   ; named variables in access ram
DCounter1:  ds	1
DCounter2:  ds	1
DCounter3:  ds	1
DCounter4:  ds	1   ; used to be DCounter2 EQU 0X0D
DCounter5:  ds	1

psect	pwm_delay_code,class=CODE
;*******************GENERAL******CODE***********************
DutyCycle_LOOP:
    bsf	    LATC, 5
    DECFSZ DCounter1, 1
    GOTO DutyCycle_LOOP
    DECFSZ DCounter2, 1
    GOTO DutyCycle_LOOP
    bcf	    LATC, 5
    RETURN
    
P_LOOP:
    DECFSZ DCounter3, 1
    GOTO P_LOOP
    DECFSZ DCounter4, 1
    GOTO P_LOOP
    DECFSZ DCounter5, 1
    GOTO P_LOOP
    NOP
    ;NOP *******Deleted to compensate for the extra instruction i have when calling it***
    RETURN

;********************-90 deg*******************************
DutyCycle_90L_DELAY:
    MOVLW 0Xc5
    MOVWF DCounter1
    MOVLW 0X15
    MOVWF DCounter2
    CALL DutyCycle_LOOP

Period_delay_90L:
    MOVLW 0Xc9
    MOVWF DCounter3
    MOVLW 0X8b
    MOVWF DCounter4
    MOVLW 0X02
    MOVWF DCounter5
    CALL  P_LOOP
    
;*******************-45 deg***********************************
 DutyCycle_45L_DELAY:
    MOVLW 0Xf7
    MOVWF DCounter1
    MOVLW 0X1a
    MOVWF DCounter2
    CALL DutyCycle_LOOP

Period_delay_45L:
    MOVLW 0X97
    MOVWF DCounter3
    MOVLW 0X86
    MOVWF DCounter4
    MOVLW 0X02
    MOVWF DCounter5
    
;************************0 deg**************************************
 DutyCycle_0_DELAY:
    MOVLW 0X28
    MOVWF DCounter1
    MOVLW 0X20
    MOVWF DCounter2

Period_delay_0:
    MOVLW 0X65
    MOVWF DCounter3
    MOVLW 0X81
    MOVWF DCounter4
    MOVLW 0X02
    MOVWF DCounter5
;********************45 deg********************************
DutyCycle_45R_DELAY:
    MOVLW 0X5a
    MOVWF DCounter1
    MOVLW 0X25
    MOVWF DCounter2
    CALL DutyCycle_LOOP
    
Period_delay_45R:
    MOVLW 0X33
    MOVWF DCounter3
    MOVLW 0X7c
    MOVWF DCounter4
    MOVLW 0X02
    MOVWF DCounter5
    CALL P_LOOP
;*******************90 deg****************************
DutyCycle_90R_DELAY:
    MOVLW 0X8c
    MOVWF DCounter1
    MOVLW 0X2a
    MOVWF DCounter2
    CALL DutyCycle_LOOP
    
Period_delay_90R:
    MOVLW 0X01
    MOVWF DCounter3
    MOVLW 0X77
    MOVWF DCounter4
    MOVLW 0X02
    MOVWF DCounter5
    CALL P_LOOP
    
    
    
;********************INITIAL CODE JUST 45 deg********************************
;DutyCycle_delay:
;    MOVLW 0X5a
;    MOVWF DCounter1
;    MOVLW 0X25
;    MOVWF DCounter2
;DC_LOOP:
;    DECFSZ DCounter1, 1
;    GOTO DC_LOOP
;    DECFSZ DCounter2, 1
;    GOTO DC_LOOP
;    NOP
;    RETURN
;    
;Period_delay:
;    MOVLW 0X33
;    MOVWF DCounter3
;    MOVLW 0X7c
;    MOVWF DCounter4
;    MOVLW 0X02
;    MOVWF DCounter5
;P_LOOP:
;    DECFSZ DCounter3, 1
;    GOTO P_LOOP
;    DECFSZ DCounter4, 1
;    GOTO P_LOOP
;    DECFSZ DCounter5, 1
;    GOTO P_LOOP
;    NOP
;    NOP
;    RETURN


