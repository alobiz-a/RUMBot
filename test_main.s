; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
extrn	ranger_main, which_interrupt	; in ranger_routines.s
extrn	format_for_display  ; in conversion.s
extrn	display_on_LCD	; in dist_on_LCD.s
extrn	LCD_Setup   ; in LCD_routines.s
    
    
psect	udata_acs   ; named variables in access ram
;no variables needed   
psect	code, abs ; absolute address
	
	

rst:
    org 0x00	; Reset vector 
    clrf    PORTG
    goto setup

    
interrupt:
    org	    0x08
    btfss   CCP4IF  ;get out of routine if it is an anomalous interrupt  
    retfie  f;is this necessary?
    bcf	    CCP4IF  ;clear flag (so that not constantly interrupting
    goto    which_interrupt ;rising or falling



setup:
    org	0x100
    	; ******* Programme FLASH read Setup Code ***********************
    bcf	CFGS	; point to Flash program memory  
    bsf	EEPGD 	; access Flash program memory
    call    LCD_Setup
    goto	main


main:
    call    ranger_main
    call    format_for_display
    call    display_on_LCD
    goto $


