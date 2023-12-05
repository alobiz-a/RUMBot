#include <xc.inc>
global setup_PWM, servo_Rotate
    
psect	udata_acs   ; named variables in access ram   
LCD_cnt_l:	ds 1	; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h:	ds 1	; reserve 1 byte for variable LCD_cnt_h
    
psect	code, abs ; absolute address

setup_PWM:; cofigure pin RC1
    clrf PORTC      ; clear portc (set pins to a low voltage/0 state)
    clrf TRISC
    
PWM_loop:       
    bsf LATC, 5	    ; Output latch, writes a 1 to port RC5
    goto DutyCycle_delay    ;                                               
    bcf	    LATC, 5	; clears pin RC5
    goto Period_delay
    
LCD_delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l, A	; now need to multiply by 16
	swapf   LCD_cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l, W, A ; move low nibble to W
	movwf	LCD_cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0

    


