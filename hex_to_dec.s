#include <xc.inc>
     
extrn time_one_H, time_one_L
 
global dist_H, dist_L

psect	udata_acs  	
	
d_pulse:	ds 1    
    
result_LL:	ds 1	; The low byte of the product 
result_MM:	ds 1	; The middle byte of the product
result_LH:	ds 1	; Intermediate byte
result_HL:	ds 1	; Intermediate byte
result_HH:	ds 1	; The high byte of the product 
    
dist_L:		ds 1	; Low byte of the conversion
dist_H:		ds 1	; High byte of the conversion
    
bit_count:	ds 1
dgt_count:	ds 1
    
conv:		ds 1
    
dgt_0:		ds 1	; Units of um
dgt_1:		ds 1	; Tens of um
dgt_2:		ds 1	; Hundreds of um
dgt_3:		ds 1	; Units of mm
dgt_4:		ds 1	; Tens of mm
dgt_5:		ds 1	; Hundreds of mm
dgt_6:		ds 1	; Units of m
dgt_7:		ds 1	; Tens of m

psect hex_code, class = CODE

;rst:
;;    org 0x00		; Reset vector
;    goto time_to_dist
    
    
time_to_dist:
    ; 8 bit by 16 bit multiplication results in a 24 bit number
    clrf    STATUS
    movlw   0x56		
    movwf   d_pulse		; Tick distance ~ 86 um
    movf    time_one_L
    mulwf   d_pulse		; d_pulse * time_h -> PRODH:PRODL
    movff   PRODL, result_LL
    movff   PRODH, result_LH
    movf    time_one_H
    mulwf   d_pulse		; d_pulse * time_h -> PRODH:PRODL
    movff   PRODL, result_HL
    movff   PRODH, result_HH
    movf    result_LH
    addwf   result_MM		; Add first medium product byte
    movf    result_HL
    addwf   result_MM		; Add second medium product byte
    btfss   STATUS, 0
    incf    result_HH
    return
 
;
;    
;BCD_conv:
;    clrf    dgt_0
;    clrf    dgt_1
;    clrf    dgt_2
;    movlw   0x08
;    movwf   bit_count
;    
;BCD_loop:
;    
;   	
;
;	
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


;your code here to display variables on LCD    

    
;BCD_conv:
;    clrf    dgt_0
;    clrf    dgt_1
;    clrf    dgt_2
;    clrf    dgt_3
;    clrf    dgt_4
;    clrf    dgt_5
;    clrf    dgt_6
;    clrf    dgt_7
;    movlw   0x18    ; 24 bits to go through
;    movwf   bit_count
;    movlw   0x08
;    movwf   dgt_count
;    
;bit_loop:
;    rlcf    result_LL		; Shift most significant bit into carry
;    rlcf    result_MM
;    rlcf    result_HH
;    lfsr    0, dgt_0
;    
;dgt_loop:    
;    rlcf    INDF0   ;Shift digit 1 bit left
;    movlw   0x0A
;    subwf   INDF0   ;Check and adjust for decimal overflow
;    btfsc   STATUS,0
;    movwf   INDF0
;    movf    POSTINC0
;    decfsz  dgt_count
;    goto    dgt_loop
;    decfsz  bit_count 
;    goto    bit_loop
;    return    
;    
