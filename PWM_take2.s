#include <xc.inc>
global setup_PWM, PWM_loop
    
psect	udata_acs   ; named variables in access ram   
counter_low:	ds 1	; reserve 1 byte for variable LCD_cnt_l
counter_high:	ds 1	; reserve 1 byte for variable LCD_cnt_h
    
psect	pwm_code, class = CODE

setup_PWM:; cofigure pin RC1
    clrf PORTC      ; clear portc (set pins to a low voltage/0 state)
    clrf TRISC
    
PWM_loop:       
    bsf LATC, 5	    ; Output latch, writes a 1 to port RC5
    goto DutyCycle_delay    ;  1.75 ms                                         
    bcf	    LATC, 5	; clears pin RC5
    goto Period_delay	;   18.25 ms
    goto PWM_loop 
    
    
    
    
LCD_delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	counter_low, A	; put whatever was in w into LCD_cnt_l
	swapf   counter_low, F, A	; swap nibbles (equivalent to multiplying/dividing by 16 in binary)
	movlw	0x0f	    
	andwf	counter_low, W, A ; move low nibble to W
	movwf	counter_high, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	counter_low, F, A ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0

    
; Initialize loop counter for 1.75ms delay
; Assuming each loop iteration takes 3 cycles (1 for decrement, 2 for branch)
; Total required iterations = total_cycles_for_delay / 3
DutyCycle_delay:
    movlw HIGH(28000/3)  ; Load the high byte of the loop counter
    movwf counter_high, A
    movlw LOW(28000/3)   ; Load the low byte of the loop counter
    movwf counter_low, A
    bra delay_loop

; Continue with the rest of the program after the delay

;   edit!!!*************************************
    ; Initialize loop counter for 20ms delay
; Each loop iteration takes approximately 3 cycles
Period_delay:
    movlw HIGH(320000/3)  ; Load the high byte of the loop counter
    movwf counter_high, A
    movlw LOW(320000/3)   ; Load the low byte of the loop counter
    movwf counter_low, A
    bra delay_loop

delay_loop:
    decfsz counter_low, F, A  ; Decrement low byte of counter
    goto $+2                  ; Skip next instruction if not zero
    decfsz counter_high, F, A ; Decrement high byte of counter
    goto delay_loop           ; Repeat loop

; Continue with the rest of the program after the delay

