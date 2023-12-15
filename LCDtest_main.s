; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
;SHOULD OUTPUT DIST_L AND DIST_H
extrn	display_on_LCD	; in dist_on_LCD.s
extrn	LCD_Setup   ; in LCD_routines.s
global	dist_H, dist_L
    
    
psect	udata_acs   ; reserve data space in access ram
dist_H:	    ds 1    ; reserve 1 byte to store the distance measured at each step
dist_L:	    ds 1    ; store nibble to transmit to display
;no variables needed   
psect	code, abs ; absolute address
	
	

rst:
    org 0x00	; Reset vector 
    clrf    PORTG
    goto setup

    
setup:
    org	0x100
    	; ******* Programme FLASH read Setup Code ***********************
    bcf	CFGS	; point to Flash program memory  
    bsf	EEPGD 	; access Flash program memory
    call    LCD_Setup
    goto	main


main:
    movlw   0x34
    movwf   dist_H
    movlw   0x93
    movwf   dist_L
    ;call    format_for_display
    call    display_on_LCD
    goto $


