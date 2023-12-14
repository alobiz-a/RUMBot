#include <xc.inc>
global	    Hex_to_dec

psect data, abs
TEMP:           ds 1    ; Temporary storage for the hex value
HIGH_NIBBLE:    ds 1    ; High nibble of the hex value
LOW_NIBBLE:     ds 1    ; Low nibble of the hex value
RESULT_HIGH:    ds 1    ; Result of high nibble multiplication
DECIMAL_RESULT: ds 1    ; Final decimal result

psect convert_code, class = CODE


Hex_to_dec:
    ;Assume the value is stored in w
    movwf TEMP, A      ; Store it in TEMP

    ; Extract the high nibble (the first digit)
    movf TEMP, W, A
    andlw 0xF0         ; Mask the lower nibble
    swapf WREG, W, A   ; Swap nibbles
    andlw 0x0F         ; Mask the higher nibble
    movwf HIGH_NIBBLE  ; Store the high nibble

    ; Multiply the high nibble by 16
    movlw 16
    mulwf HIGH_NIBBLE, A
    movwf RESULT_HIGH, A

    ; Extract the low nibble (the second digit)
    movf TEMP, W, A
    andlw 0x0F         ; Mask the high nibble
    movwf LOW_NIBBLE   ; Store the low nibble

    ; Add the high and low parts
    movf RESULT_HIGH, W, A
    addwf LOW_NIBBLE, W, A
    ; decimal result now stored in w
    
;*************************** CHANGEEEE ********************************

Hex16_to_dec_format:  
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