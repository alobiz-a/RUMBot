#include <xc.inc>
 
extrn	setup_PWM, PWM_loop
    
psect	code, abs ; absolute address
	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	org	0x100
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	setup_PWM	; setup LCD
	call	PWM_loop	;k