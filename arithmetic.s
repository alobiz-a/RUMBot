#include <xc.inc>
    
psect usrf ; Defining a psect

extrn time1, time2
    
const1: ds 1
const2: ds 1
    
distance_conversion:
    movff time1, dist1
    movff time2, dist2
    
    
    
    decimal:  
	; Converts 16 bit Hex number to a number in decimal based on
	; a configurable conversion factor
	; Hex input is in LENH:LENL
	; Number in k can be configured
	; The output is a 16 bit hex number where its digits is a decimal
	
	movff	LENH, ARG1H	; Extract first bit
	movff	LENL, ARG1L
	
	movlw	0x05		; Multiply by our number k
	movwf	ARG2H
	movlw	0xBD
	movwf	ARG2L		
	
	call	multiply	; Following is the conversion routine
	movff	RES3, ANSH
	rlncf	ANSH, F		; left shift 4 bits
	rlncf	ANSH, F
	rlncf	ANSH, F
	rlncf	ANSH, F

	call	extract_next	; Extract next bit, combine it with first bit
	movf	RES3,W
	addwf	ANSH,1
	
	call	extract_next	; Extract next bit
	movff	RES3, ANSL
	rlncf	ANSL, F		; left shift 4 bits
	rlncf	ANSL, F
	rlncf	ANSL, F
	rlncf	ANSL, F

	call	extract_next	; Extract next bit, combine it with previous bit
	movf	RES3,W
	addwf	ANSL,1
	
	
	return
    