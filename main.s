#include <xc.inc>

extrn	LCD_Setup, LCD_Write_Message, LCD_Write_Hex, LCD_Send_Byte_I,LCD_Send_Byte_D, LCD_clear ; external LCD subroutines - A. CHANGE
extrn	PWM_setup, outputcheck ; external motor subroutines - A. CHANGE 
extrn	US_main ; external ultrasound subroutines

	
psect	udata_acs   ; reserve data space in access ram
; A. fill later on with counters etc.
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'R','a','n','g','e',' ','(','m','m',')',':',0x0a
					; message, plus carriage return
	myTable_l   EQU	12	; length of data
	align	2
    
psect	code, abs ; absolute address
	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	org	0x100
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	goto	start
	
main:
	goto	start

			    ; Main code starts here at address 0x100
; A. define an interrupt de
start:
	movlw 	0x0
	movwf	TRISB, A	    ; Port C all outputs
	bra 	test
loop:
	movff 	0x06, PORTB
	incf 	0x06, W, A
test:
	movwf	0x06, A	    ; Test for end of loop condition
	movlw 	0x63
	cpfsgt 	0x06, A
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

	end	rst
