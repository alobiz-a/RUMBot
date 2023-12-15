; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
;SHOULD OUTPUT DIST_L AND DIST_H
extrn  format_for_display
global time_H, time_L
extrn	display_on_LCD	; in dist_on_LCD.s
extrn	LCD_Setup   ; in LCD_routines.s
extrn	UART_Setup, send_dists_UART  ; in UART_routines.s
    
    
psect	udata_acs   ; reserve data space in access ram
time_H:	    ds 1    ; reserve 1 byte to store the distance measured at each step
time_L:	    ds 1    ; store nibble to transmit to display
;no variables needed   
psect	code, abs ; absolute address
	
	

rst:
    org 0x00	; Reset vector 
    clrf    PORTG
    goto setup

    
setup:
    org	0x100
    	; ******* Programme FLASH read Setup Code ***********************
    bcf	    CFGS	; point to Flash program memory  
    bsf	    EEPGD 	; access Flash program memory
    call    LCD_Setup
    call    UART_Setup
    goto	main


main:
    movlw   0x11
    movwf   time_H
    movlw   0x02
    movwf   time_L
    call    format_for_display
    call    display_on_LCD
    call    send_dists_UART
    goto $


