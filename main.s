; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
extrn	main_LCD_loop, LCD_Setup
extrn	time_H, time_L, dist_H, dist_L
    
psect	udata_acs   ; named variables in access ram
;MD1:  ds	1   ; the motor delay counters
;MD2:  ds	1
;MD3:  ds	1
    
psect	code, abs ; absolute address
	
rst:	; reset vector	
	org 0x0
 	goto	setup



	; ******* Programme FLASH read Setup Code ***********************
org	0x100
setup:	
    
    bcf	CFGS	; point to Flash program memory  
    bsf	EEPGD 	; access Flash program memory
    call	LCD_Setup	; setup LCD
    ;call	UART_Setup
    goto	start


start:
    call    range_main
    call    format_for_display; converts the high and low time bytes into distances to display
    call    main_LCD_loop
    goto $