#include <xc.inc>

global  format_for_display
extrn	time_H,time_L
global	dist_H, dist_L

psect	udata_acs   ; Named variables in access ram

arg1L:	    ds 1    ; Low byte of first argument
arg1M:	    ds 1    ; Middle byte of first argument
arg1H:	    ds 1    ; High byte of first argument
arg2L:	    ds 1    ; Low byte of second argument
arg2H:	    ds 1    ; High byte of second argument
    
res0:	    ds 1    ; Low result byte
res1:	    ds 1
res2:	    ds 1
res3:	    ds 1    ; Highest result byte
    
    
dist_H:	    ds 1	 ; answer for the conversion
dist_L:	    ds 1


psect	mult_code,class=CODE
    
multiply_1616:
    ; Multiply two 16 bit numbers to create a 32 bit number
    movf    arg1L, W	
    mulwf   arg2L	; Multiply two lowest bytes and yields PRODH:PRODL
    movff   PRODL, res0	
    movff   PRODH, res1	
    
    movf    arg1H, W	
    mulwf   arg2H	; Multiply two highest bytes and yields PRODH:PRODL
    movff   PRODL, res2	
    movff   PRODH, res3	

    movf    arg1L, W	; Move the byte into the working register
    mulwf   arg2H	; Multiply one high byte and one low byte
    movf    PRODL, W	
    addwf   res1, 1	; Add the high byte in the working register to res1 byte
    movf    PRODH, W	
    addwfc  res2,  1	; Add the high byte in the working register and the 
			; carry bit to the res2 byte
    clrf    WREG	
    addwfc  res3, 1	; Add the carry bit (empty working register) to res3
			
    movf    arg1H, W	; Move the byte into the working register
    mulwf   arg2L	; Multiply one high byte and one low byte
    movf    PRODL, W	
    addwf   res1, 1	; Add the high byte in the working register to res1 byte
    movf    PRODH, W	
    addwfc  res2,  1	; Add the high byte in the working register and the 
			; carry bit to the res2 byte
    clrf    WREG	
    addwfc  res3, 1	; Add the carry bit (empty working register) to res3
    
    return
    
    
multiply_248:
    ; Multiply a 24 bit and an 8 bit number to create a 32 bit number
    movf    arg1L, W	
    mulwf   arg2L	; Multiply the low byte and yields PRODH:PRODL
    movff   PRODL, res0	
    movff   PRODH, res1	

    movf    arg1H, W	
    mulwf   arg2L	; Multiply the high byte and yields PRODH:PRODL
    movff   PRODL, res2	
    movff   PRODH, res3
    
    movwf   arg1M, W
    mulwf   arg2L	; Multiply the middle byte and yields PRODH:PRODL
    movf    PRODL, W
    addwf   res1, 1	; Add working register to res1
    movf    PRODH, W	
    addwfc  res2, 1	; Add working register and carry bit to res2
    clrf    WREG
    addwfc  res3, 1	; Just add carry bit to res3
    
    return


format_for_display:
    ; Convert the times in time_H:time_L into distances and then convert those
    ; distances into a number where its hexadecimal digits correspond to the 
    ; denary digits of the orginal number
    movff   time_H, ARG1H   ; Move first byte into argument
    movff   time_L, ARG1L   ; Move second byte into argument
    movlw   0x05	    
    movwf   ARG2H	    ; Move first byte of coefficient into argument
    movlw   0xBD	    
    movwf   ARG2L	    ; Move second byte of coefficient into argument
    call    multiply_1616   ; Multiply times by conversion factor to get hex
			    ; distance
    
    movff   res3, dist_H    ; Move high multiplication byte into dist_H
    rlncf   dist_H, F	    ; Shift the byte leftwards by 4
    rlncf   dist_H, F	    ; This moves the first nibble into the second nibble
    rlncf   dist_H, F	    ; and vice versa
    rlncf   dist_H, F
    call    extract_next    ; Extract next byte, combine it with first byte
    movf    res3,W
    addwf   dist_H,1	    ; Add the dist_H and res3 bytes 

    call    extract_next	; Extract next bit
    movff   res3, dist_L
    rlncf   dist_L, F		; Shift the byte leftwards by 4
    rlncf   dist_L, F
    rlncf   dist_L, F
    rlncf   dist_L, F

    call    extract_next	; Extract next bit, combine it with previous bit
    movf    res3,W
    addwf   dist_L,1
    
    return
    
format_for_display:  

	call	extract_next	; Extract next bit, combine it with first bit
	movf	RES3,W
	addwf	dist_H,1
	
	call	extract_next	; Extract next bit
	movff	RES3, dist_L
	rlncf	dist_L, F		; left shift 4 bits
	rlncf	dist_L, F
	rlncf	dist_L, F
	rlncf	dist_L, F

	call	extract_next	; Extract next bit, combine it with previous bit
	movf	RES3,W
	addwf	dist_L,1
	
	
	return
	
	
extract_next:
    movff   res0, arg1L ; Store results in registers for multiplication
    movff   res1, arg1M
    movff   res2, arg1H
    movlw   0x0A
    movwf   ARG2L	 ; Set second argument as 0d10
    call    multiply_248 ; multiplies remainder with dec10
    return
    
end
