;#include <xc.inc>
;     
;extrn time_H, time_L
; 
;global dist_H, dist_L
;
;psect	udata_acs  	
;	
;d_pulse:	ds 1    
;    
;result_LL:	ds 1	; The low byte of the product 
;result_MM:	ds 1	; The middle byte of the product
;result_LH:	ds 1	; Intermediate byte
;result_HL:	ds 1	; Intermediate byte
;result_HH:	ds 1	; The high byte of the product 
;    
;dist_L:		ds 1	; Low byte of the conversion
;dist_H:		ds 1	; High byte of the conversion
;    
;dgt_0:		ds 1	; Units of um
;dgt_1:		ds 1	; Tens of um
;dgt_2:		ds 1	; Hundreds of um
;dgt_3:		ds 1	; Units of mm
;dgt_4:		ds 1	; Tens of mm
;dgt_5:		ds 1	; Hundreds of mm
;dgt_6:		ds 1	; Units of m
;dgt_7:		ds 1	; Tens of m
;
;psect hex_code, class = CODE
;
;org 0x00
;start:
;    goto time_to_dist
;    goto dist_to_ascii
;    
;time_to_dist:
;    ; 8 bit by 16 bit multiplication results in a 24 bit number
;    clrf    STATUS
;    movlw   0x56		
;    movwf   d_pulse		; Tick distance ~ 86 um
;    movf    time_L
;    mulwf   d_pulse		; d_pulse * time_h -> PRODH:PRODL
;    movff   PRODL, result_LL
;    movff   PRODH, result_LH
;    movf    time_H
;    mulwf   d_pulse		; d_pulse * time_h -> PRODH:PRODL
;    movff   PRODL, result_HL
;    movff   PRODH, result_HH
;    movf    result_LH
;    addwf   result_MM		; Add first medium product byte
;    movf    result_HL
;    addwf   result_MM		; Add second medium product byte
;    btfss   STATUS, 0
;    incf    result_HH
;    return
;
;
;bin24dec:
;    call    clr_dgts		; Clear the 
;    movlw   0x18		;24 bits to do
;    movwf   bit_count
;    
;bitlp:
;    rlcf    result_LL		; Shift most significant bit into carry
;    rlcf    result_MM
;    rlcf    result_HH
;    lfsr    FSR0, dgt_0		; load FSR0 with dgt_0
;    movlw   0x08		; 8 digits to do
;    movwf   dgt_cnt
;
;adjlp:
;    rlcf    INDF0	;Shift digit 1 bit left
;    movlw   0x0A
;    subwf   INDF0,w,0	;Check and adjust for decimal overflow
;    btfsc   STATUS,0
;;skpnc
;    movwf   INDF0
;    movf    POSTINC0,w
;    decfsz  digcnt
;    goto    adjlp
;    decfsz  bitcnt ;Next bit
;    goto    bitlp
;    return
;
;clr_dgts:
;    clrf    dgt_0
;    clrf    dgt_1
;    clrf    dgt_2
;    clrf    dgt_3
;    clrf    dgt_4
;    clrf    dgt_5
;    clrf    dgt_6
;    clrf    dgt_7
;return 
;
;;dist_BCD:
;;    ; Convert a 32 bit number into a string of ASCII denary digits for output
;;    ; to the LCD made using a modified version of the double dabble algorithm
;;    ; which converts binary into binary coded digits which are then converted
;;    ; to ASCII.
;;    clrf    dgt_0
;;    clrf    dgt_1
;;    clrf    dgt_2
;;    clrf    dgt_3
;;    clrf    dgt_4
;;    clrf    dgt_5
;;    clrf    dgt_6
;;    clrf    dgt_7
;;    movlw   0x18
;;    movf    counter_1
;;    goto    shift_1
;;    
;;ADJBCD:  	
;;    MOVLW   DIGIT1
;;    MOVWF   FSR
;;    MOVLW   7
;;    MOVWF   COUNTER2
;;    MOVLW   3    
;;    
;;shift_1: 
;;    call