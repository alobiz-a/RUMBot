#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message, UART_Transmit_Hex  ; external subroutines
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	goto	start
	
	; ******* Main programme ****************************************
start: 	
	movlw	0x37
	call UART_Transmit_Hex

	goto	start		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst


