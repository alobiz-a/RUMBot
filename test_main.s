; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
extrn	ranger_main, which_interrupt	; in ranger_routines.s

extrn	format_for_display  ; in conversion.s
extrn	display_on_LCD	; in dist_on_LCD.s
extrn	LCD_Setup   ; in LCD_routines.s
extrn	UART_Setup, send_dists_UART  ; in UART_routines.s
extrn	time_H, time_L ; CHANGE TO EXT
;ADD DELAYS!!!
    
    
psect	udata_acs   ; named variables in access ram
;time_H:	    ds 1    ; reserve 1 byte to store the distance measured at each step
;time_L:	    ds 1    ; store nibble to transmit to display
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
    ;******* Program FLASH read Setup Code ***********************
    bcf		CFGS	; point to Flash program memory  
    bsf		EEPGD 	; access Flash program memory
    call	LCD_Setup
    call	UART_Setup
    goto	main


main:
    call    ranger_main
;    movlw   0x02
;    movwf   time_H
;    movlw   0x02
;    movwf   time_L
    call    format_for_display
    call    display_on_LCD
    call    send_dists_UART
    goto    main


