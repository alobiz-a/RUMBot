#include <xc.inc>

extrn	LCD_Setup, LCD_Write_Message, LCD_Send_Byte_I, LCD_Send_Byte_D, ClearLCD ; external LCD subroutines - A. CHANGE
	
extrn ultra1_time1, ultra1_time2
    
extrn main_main
    
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
	db	'R','a','n','g','e',' ','(','m','m',')',':', ultra1_time1
					; message, plus carriage return
	myTable_l   EQU	12	; length of data
	align	2

global myTable	
	
final_main:
    call main_main
    call wait_delay
    call wait_delay
    call wait_delay