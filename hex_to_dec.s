#include <xc.inc>
     
extrn time_H, time_L
 
global dist_H, dist_L

psect	udata_acs  

; ds reserve space
; equ placeholder
; set ??	
	
d_pulse:	ds 1    
result_LL:	ds 1	; The low byte of the product using the low byte
result_LH:	ds 1	; etc
result_HL:	ds 1	; etc
result_HH:	ds 1	; The high byte of the product using the high byte    
dist_L:		ds 1	; Low byte of the conversion
dist_H:		ds 1	; High byte of the conversion
 
psect hex_code, class = CODE

org 0x00
start:
    goto time_to_dist
    goto dist_to_ascii
    
time_to_dist:
    ; 8 bit by 16 bit multiplication
    movlw   0x56		
    movf    d_pulse		; Tick distance ~ 86 um
    movlw   time_L
    mulwf   d_pulse		; d_pulse * time_h -> PRODH:PRODL
    movff   PRODL, result_LL
    movff   PRODH, result_LH
    movlw   time_H
    mulwf   d_pulse		; d_pulse * time_h -> PRODH:PRODL
    movff   PRODL, result_HL
    movff   PRODH, result_HH
    return

dist_to_ascii:
    ; Convert a 32 bit number into a string of ASCII denary digits for output
    ; to the LCD
    
    
    
;    
;    ;in: BIN
;;out huns. tens, ones
;
;;uses ADD-3 algoerthm
;
;movlw 8
;movwf count
;clrf huns
;clrf tens
;clrf ones
;
;BCDADD3
;
;movlw 5
;subwf huns, 0
;btfsc STATUS, C
;CALL ADD3HUNS
;
;movlw 5
;subwf tens, 0
;btfsc STATUS, C
;CALL ADD3TENS
;
;movlw 5
;subwf ones, 0
;btfsc STATUS, C
;CALL ADD3ONES
;
;decf count, 1
;bcf STATUS, C
;rlf BIN, 1
;rlf ones, 1
;btfsc ones,4 ; 
;CALL CARRYONES
;rlf tens, 1
;
;btfsc tens,4 ; 
;CALL CARRYTENS
;rlf huns,1
;bcf STATUS, C
;
;movf count, 0
;btfss STATUS, Z
;GOTO BCDADD3
;
;
;movf huns, 0 ; add ASCII Offset
;addlw h'30'
;movwf huns
;
;movf tens, 0 ; add ASCII Offset
;addlw h'30'
;movwf tens
;
;movf ones, 0 ; add ASCII Offset
;addlw h'30'
;movwf ones
;
;RETURN
;
;ADD3HUNS
;
;movlw 3
;addwf huns,1
;
;RETURN
;
;ADD3TENS
;
;movlw 3
;addwf tens,1
;
;RETURN
;
;ADD3ONES
;
;movlw 3
;addwf ones,1
;
;RETURN
;
;CARRYONES
;bcf ones, 4
;bsf STATUS, C
;RETURN
;
;CARRYTENS
;bcf tens, 4
;bsf STATUS, C
;RETURN
;    

;bin2dec	
;	clrf	MTEMP		;Reset sign flag
;	call	absa		;Make REGA positive
;	skpnc
;	return			;Overflow
;
;	call	clrdig		;Clear all digits
;
;	movlw	D'32'		;Loop counter
;	movwf	MCOUNT
;
;b2dloop	
;	rlf	REGA0,f		;Shift msb into carry
;	rlf	REGA1,f
;	rlf	REGA2,f
;	rlf	REGA3,f
;
;	movlw	DIGIT10
;	movwf	FSR		;Pointer to digits
;	movlw	D'10'		;10 digits to do
;	movwf	DCOUNT
;
;adjlp	rlf	INDF,f		;Shift digit and carry 1 bit left
;	movlw	D'10'
;	subwf	INDF,w		;Check and adjust for decimal overflow
;	skpnc
;	movwf	INDF
;
;	decf	FSR,f		;Next digit
;	decfsz	DCOUNT,f
;	goto	adjlp
;
;	decfsz	MCOUNT,f	;Next bit
;	goto	b2dloop
;
;	btfsc	MTEMP,0		;Check sign
;	bsf	DSIGN,0		;Negative
;	clrc
;	return
;    
;Hundreds	equ 0x20
;Tens		equ 0x21
;units		equ 0x22
;working		equ 0x23
;numtocon	equ 0x24
;count		equ 0x25
;   	
;	ORG 0x0000 ;reset vector 
;
;	goto start
;
;
;Start
;		clrf	Hundreds
;		clrf	Tens
;		clrf	Units
;
;		movlw	d'159'	  ;load w with the number to covert
;		movwf	numtocon  ;save the number in variable	
;
;		movlw	d'8'
;		movwf	count		
;ShiftLoop
;;test lowerbcd		
;		movfw	units
;		andlw	b'1111'
;		movwf	working
;		movlw	d'5'
;		subwf	working,0
;		SKPC		
;		Goto	TestUpperNibble
;		movlw	d'3'
;		addwf	units
;TestUpperNibble		
;		movfw	units
;		andlw	b'11110000'
;		movwf	working
;		movlw	H'50'
;		subwf	working,0
;		SKPC		
;		goto	Shiftbit
;		movlw	H'30'
;		addwf	units
;shiftbit
;		rlf	units,1
;		rlf	hundreds,1
;		SKPNC
;		bsf	hundreds,0
;		rlf	numtocon,1
;		SKPNC	
;		bsf	Units,0
;		decfsz	count
;		goto	ShiftLoop
;		movfw	Units
;		Movwf	Tens
;		swapf	Tens,1
;		movlw	b'1111'
;		andwf	Units,1
;		andwf	Tens,1
;		movlw	d'48'
;		addwf	Hundreds
;		addwf	Tens
;		addwf	Units
;
;
;;your code here to display variables on LCD




