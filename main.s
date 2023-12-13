; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
extrn	main_LCD_loop, LCD_Setup
;extrn	PWM_90R, PWM_45R, PWM_0, PWM_45L, PWM_90L
;extrn	Delay_3s
;extrn	UART_Setup, UART_Transmit_Message  ; external uart subroutines
    
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
;    clrf	PORTC      ; clear portc (set pins to a low voltage/0 state) to configure motor
;    clrf	TRISC
    call	LCD_Setup	; setup LCD
    ;call	UART_Setup
    goto	start


start:
    call main_LCD_loop
    goto start