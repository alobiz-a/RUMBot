#include <xc.inc>

global  format_for_display
extrn time_H,time_L
global dist_H, dist_L


psect	udata_acs   ; named variables in access ram

ARG1L:		ds 1	;A. CHANGE - Make variable names more intuitive
ARG2L:		ds 1
ARG1H:		ds 1
ARG1T:		ds 1
ARG2H:		ds 1
    
RES0:		ds 1
RES1:		ds 1
RES2:		ds 1
RES3:		ds 1
    
dist_H:		ds 1	 ; answer for the conversion
dist_L:		ds 1


psect	mult_code,class=CODE

multiply:		; 16 bit by 16 bit multiply routine
	   
	MOVF ARG1L, W
	MULWF ARG2L ; ARG1L * ARG2L->
	; PRODH:PRODL
	MOVFF PRODH, RES1 ;
	MOVFF PRODL, RES0 ;
	;
	MOVF ARG1H, W
	MULWF ARG2H ; ARG1H * ARG2H->
	; PRODH:PRODL
	MOVFF PRODH, RES3 ;
	MOVFF PRODL, RES2 ;
	;
	MOVF ARG1L, W
	MULWF ARG2H ; ARG1L * ARG2H->
	; PRODH:PRODL
	MOVF PRODL, W ;
	ADDWF RES1, F ; Add cross
	MOVF PRODH, W ; products
	ADDWFC RES2, F ;
	CLRF WREG ;
	ADDWFC RES3, F ;
	;
	MOVF ARG1H, W ;
	MULWF ARG2L ; ARG1H * ARG2L->
	; PRODH:PRODL
	MOVF PRODL, W ;
	ADDWF RES1, F ; Add cross
	MOVF PRODH, W ; products
	ADDWFC RES2, F ;
	CLRF WREG ;
	ADDWFC RES3, F ;
	
	return
	
multiply_24:		    ; 24 bit by 8 bit multiply routine
	MOVF	ARG1L, W
	MULWF	ARG2L	    ; ARG1L * ARG2L->
			    ; PRODH:PRODL
	MOVFF	PRODH, RES1   ;
	MOVFF	PRODL, RES0   ;
	;
	MOVF	ARG1T, W
	MULWF	ARG2L	    ; ARG1H * ARG2L->
			    ; PRODH:PRODL
	MOVFF	PRODH, RES3 ;
	MOVFF	PRODL, RES2 ;
			    ;
	MOVF	ARG1H, W
	MULWF	ARG2L	    ; ARG1M * ARG2L->
			    ; PRODH:PRODL
	MOVF	PRODL, W    ;
	ADDWF	RES1, F	    ; Add cross
	MOVF	PRODH, W    ; products
	ADDWFC	RES2, F	    ;
	CLRF	WREG	    ;
	ADDWFC	RES3, F	    ;
			    ;

	return

format_for_display:  
	; Converts 16 bit Hex number to a number in decimal based on
	; a configurable conversion factor
	; Hex input is in Time_H:Time_L
	; Number in k can be configured
	; The output is a 16 bit hex number where reading its digits spells out the wanted decimal
	
	movff	time_H, ARG1H	; Extract first bit
	movff	time_L, ARG1L
	
	movlw	0x05		; Multiply by our number k
	movwf	ARG2H
	movlw	0xBD
	movwf	ARG2L		
	
	call	multiply	; Following is the conversion routine
	movff	RES3, dist_H
	rlncf	dist_H, F		; left shift 4 bits
	rlncf	dist_H, F
	rlncf	dist_H, F
	rlncf	dist_H, F

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
	movff	RES0, ARG1L ;Store results in registers for multiplication
	movff	RES1, ARG1H
	movff	RES2, ARG1T
	
	movlw	0x0A
	movwf	ARG2L
	
	call	multiply_24 ; multiplies remainder with dec10
	
	return
    
end


