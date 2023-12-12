; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
extrn	main_LCD_loop, LCD_Setup
extrn	PWM_90R
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
setup:	
    org	0x100
    bcf	CFGS	; point to Flash program memory  
    bsf	EEPGD 	; access Flash program memory
    clrf	PORTC      ; clear portc (set pins to a low voltage/0 state) to configure motor
    clrf	TRISC
    call	LCD_Setup	; setup LCD
    call	UART_Setup
    goto	start


start:
    call main_LCD_loop
    call Set_Mdelay_counter ;initialise the counters
    call Check_running
    call M_loop_90R
    ;call PWM_90R
    call main_LCD_loop
    call Delay_3s   ; cos why not
    ;******
    call Set_Mdelay_counter ;initialise the counters
    call M_loop_90R
    ;******
    goto start ;so that it doesn't clear the LCD each time
    
    

    
M_loop_90R:
    call PWM_90R
    decfsz MD1, 1
    goto M_loop_90R
    decfsz MD2, 1
    goto M_loop_90R
    decfsz MD3, 1
    goto M_loop_90R
    return
    
    

    
Set_Mdelay_counter:
    movlw 0X01
    movwf MD1
    movlw 0X57
    movwf MD2
    movlw 0Xa3
    movwf MD3
    return

Check_running:
    movlw   0x00
    movwf   TRISE
    movlw   0xFF
    movwf   LATE
    
;M_loop:
;    decfsz MD1, 1
;    goto M_loop
;    decfsz MD2, 1
;    goto M_loop
;    decfsz MD3, 1
;    goto M_loop
;    return
    
end	rst
    
