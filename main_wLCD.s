#include <xc.inc>

extrn	LCD_Setup, LCD_Write_Message, LCD_Send_Byte_I, LCD_Send_Byte_D, ClearLCD ; external LCD subroutines - A. CHANGE
extrn	trig_one, ultra1_time1, ultra1_time2, interrupt_handler, rising_edge_interrupt
	
psect	udata_acs   ; reserve data space in access ram
distanceStore:	    ds 1    ; reserve 1 byte to store the distance measured at each step
LCD_tmp:	    ds 1    ; store nibble to transmit to display
counter:	    ds 1
delay_count:	    ds 1 ; reserve 1 byte for delay counter
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
    
;psect	code, abs ; absolute address
psect	main_code,class=CODE
	
rst:	; reset vector	
	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	org	0x100
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	goto	main_loop
	

	; ******* Main programme ****************************************
main_loop:

LCD_line1:
	movlw   0X80		; Address of first line
	call    LCD_Send_Byte_I 

	movlw   0x0
	call    LCD_Send_Byte_D
	call    LCD_load_line1
LCD_line2:
	movlw   0xC0	; Write to second line
	call    LCD_Send_Byte_I	; move the cursor to the second line

	movlw   0x5			; The value in the working reg is set to 0 - A. NOW 5
	call    LCD_Send_Byte_D	; Display this on the second line (a blank space)
	;movlw	0x6D ;CHANGE WITH VALUE OBTAINED FROM MEASUREMENT!!!
	movlw	ultra1_time1
	call	LCD_load_line2

	;movf    ANSH, W, A	    ; Move what's in the ANSL register to W 
	;call    LCD_Write_Hex
	;movf    ANSL, W, A
	;call    LCD_Write_Hex
	return
	
;******************Write "Range (mm):" to line 1********************************
LCD_load_line1:
	lfsr	0, myArray	; Load FSR0 with address in RAM	
	movlw	low highword(myTable)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter, A		; our counter register
loop: 	
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop		; keep going until finished		

	movlw	myTable_l	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, myArray
	call	LCD_Write_Message

	goto	LCD_line2		
	
;**********************Write the distance measured to line 2*********************************
LCD_load_line2:			; Writes byte stored in W as hex
	movwf	distanceStore, A
	swapf	distanceStore, W, A	; high nibble first
	call	LCD_Hex_Nib
	movf	distanceStore, W, A	; then low nibble
LCD_Hex_Nib:			; writes low nibble as hex character
	andlw	0x0F
	movwf	LCD_tmp, A
	movlw	0x0A
	cpfslt	LCD_tmp, A
	addlw	0x07		; number is greater than 9 
	addlw	0x26
	addwf	LCD_tmp, W, A
	call	LCD_Send_Byte_D ; write out ascii
	return		

	


    
;************ a delay subroutine if you need one, times around loop in delay_count***********
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst


