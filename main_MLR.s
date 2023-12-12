; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
extrn	main_LCD_loop, LCD_Setup
extrn	PWM_90R, PWM_45R, PWM_0, PWM_45L, PWM_90L
extrn	Delay_3s
extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
    
psect	udata_acs   ; named variables in access ram
MD1:  ds	1   ; the motor delay counters
MD2:  ds	1
MD3:  ds	1
    
psect	code, abs ; absolute address
	
rst:	; reset vector	
	org 0x0
 	goto	setup



	; ******* Programme FLASH read Setup Code ***********************
org	0x100
setup:	
    
    bcf	CFGS	; point to Flash program memory  
    bsf	EEPGD 	; access Flash program memory
    clrf	PORTC      ; clear portc (set pins to a low voltage/0 state) to configure motor
    clrf	TRISC
    call	LCD_Setup	; setup LCD
    call	UART_Setup
    goto	start


start:
    call Set_Mdelay_counter ;initialise the counters
    ;call Check_running_on
    ;call PWM_90R
    call M_loop_90R1
    ;call Check_running_off
    call main_LCD_loop
    ;call Delay_3s   ; cos why not
    ;******
    call Set_Mdelay_counter ;initialise the counters
    call M_loop_45R1
    call main_LCD_loop
    ;call Delay_3s
    ;******
    call Set_Mdelay_counter ;initialise the counters
    call M_loop_01
    call main_LCD_loop
    ;call Delay_3s
    ;******
    call Set_Mdelay_counter ;initialise the counters
    call M_loop_45L1
    call main_LCD_loop
    ;call Delay_3s
    ;******
    call Set_Mdelay_counter ;initialise the counters
    call M_loop_90L1
    call main_LCD_loop
    ;call Delay_3s
    ;******
    goto start ;so that it doesn't clear the LCD each time
    
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


Check_running_on:
    movlw   0x00
    movwf   TRISD
    movlw   0xFF
    movwf   LATD
    return
Check_running_off:
    clrf    LATD
    clrf    PORTD      ; clear portc (set pins to a low voltage/0 state) to configure motor

    
;M_loop:
;    decfsz MD1, 1
;    goto M_loop
;    decfsz MD2, 1
;    goto M_loop
;    decfsz MD3, 1
;    goto M_loop
;    return
    
;M_loop_90R:
;    call PWM_90R
;    decfsz MD1, 1
;    goto M_loop_90R
;    decfsz MD2, 1
;    goto M_loop_90R
;    decfsz MD3, 1
;    goto M_loop_90R
;    return
    
end	rst
    
