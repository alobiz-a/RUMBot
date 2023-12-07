#include <xc.inc>

extrn DutyCycle_90L_DELAY, Period_delay_90L, DutyCycle_45L_DELAY, Period_delay_45L 
extrn DutyCycle_0_DELAY, Period_delay_0
extrn DutyCycle_90R_DELAY, Period_delay_90R, DutyCycle_45R_DELAY, Period_delay_45R 
    
psect	udata_acs   ; named variables in access ram   
counter_low:	ds 1	; reserve 1 byte for variable LCD_cnt_l
counter_high:	ds 1	; reserve 1 byte for variable LCD_cnt_h
DCounter1:  ds	1
DCounter2:  ds	1
DCounter3:  ds	1
DCounter4:  ds	1   ; used to be DCounter2 EQU 0X0D
DCounter5:  ds	1

WaitCounter1:	ds  1
WaitCounter2:	ds  1

psect	pwm_code, class = CODE

setup_PWM:; cofigure pin RC1
    clrf PORTC      ; clear portc (set pins to a low voltage/0 state)
    clrf TRISC
    bsf LATC, 5
    
;**********************ORIGINAL BASIC PWM LOOP********************************* 
;PWM_loop:       
;    bsf LATC, 5	    ; Output latch, writes a 1 to port RC5
;    call DutyCycle_delay    ;  1.75 ms                                         
;    bcf	    LATC, 5	; clears pin RC5
;    call Period_delay	;   18.25 ms
;    goto PWM_loop 

    
;*****************Modify DutyCycle_delay and Period_delay**************************
Initialise_WaitCounters: ; general: wait the same amount of time between each turn
    MOVLW 0Xf0
    MOVWF WaitCounter1
    MOVLW 0X02
    MOVWF WaitCounter2

L_45_deg:
    call Initialise_WaitCounters
PWM_LOOP_45L:
    bsf	    LATC, 5	; clears pin RC5
    call DutyCycle_45L_DELAY    ;  1.75 ms  - clears the pin in there   (maybe change it tohere for niceness)                                    
    call Period_delay_45L	;   18.25 ms
    DECFSZ WaitCounter1, 1
    GOTO PWM_LOOP_45L
    DECFSZ WaitCounter2, 1
    GOTO PWM_LOOP_45L
    NOP
    
R_90_deg:
    call Initialise_WaitCounters
PWM_LOOP_90R:
    bsf	    LATC, 5	; clears pin RC5
    call DutyCycle_90R_DELAY    ;  1.75 ms  - clears the pin in there   (maybe change it tohere for niceness)                                    
    call Period_delay_90R	;   18.25 ms
    DECFSZ WaitCounter1, 1
    GOTO PWM_LOOP_90R
    DECFSZ WaitCounter2, 1
    GOTO PWM_LOOP_90R
    NOP

    
L_90_deg:
    call Initialise_WaitCounters
PWM_LOOP_90L:
    bsf	    LATC, 5	; clears pin RC5
    call DutyCycle_90L_DELAY    ;  1.75 ms  - clears the pin in there   (maybe change it tohere for niceness)                                    
    call Period_delay_90L	;   18.25 ms
    DECFSZ WaitCounter1, 1
    GOTO PWM_LOOP_90L
    DECFSZ WaitCounter2, 1
    GOTO PWM_LOOP_90L
    NOP
    

    
Neutral_0_deg:
    call Initialise_WaitCounters
PWM_LOOP_0:
    bsf	    LATC, 5	; clears pin RC5
    call DutyCycle_0_DELAY    ;  1.75 ms  - clears the pin in there   (maybe change it tohere for niceness)                                    
    call Period_delay_0	;   18.25 ms
    DECFSZ WaitCounter1, 1
    GOTO PWM_LOOP_0
    DECFSZ WaitCounter2, 1
    GOTO PWM_LOOP_0
    NOP
    
R_45_deg:
    call Initialise_WaitCounters
PWM_LOOP_45R:
    bsf	    LATC, 5	; clears pin RC5
    call DutyCycle_45R_DELAY    ;  1.75 ms  - clears the pin in there   (maybe change it tohere for niceness)                                    
    call Period_delay_45R	;   18.25 ms
    DECFSZ WaitCounter1, 1
    GOTO PWM_LOOP_45R
    DECFSZ WaitCounter2, 1
    GOTO PWM_LOOP_45R
    NOP
    

    
