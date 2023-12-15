#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message, UART_Transmit_Hex, UART_Transmit_Byte  ; external subroutines
extrn	decimal
extrn	ANSH, ANSL
global	time_one_H,time_one_L
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
LENH:		ds 1	
LENL:		ds 1

    
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
	;movlw	0x37
	;call UART_Transmit_Hex
	;movlw	0x0A
	;call UART_Transmit_Byte

	call	decimal
	call	UART_Transmit_Byte
	;call	decimal
	movf	ANSL, 0
	call	UART_Transmit_Hex
	movlw	0x0A
	call UART_Transmit_Byte

	goto	$		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst


