
; main file to control the motor, the LCD and the ranger
#include <xc.inc>
    
extrn	ranger_main, which_interrupt	; in ranger_routines.s

extrn	format_for_display  ; in conversion.s
extrn	display_on_LCD	; in dist_on_LCD.s
extrn	LCD_Setup   ; in LCD_routines.s
extrn	UART_Setup, send_dists_UART  ; in UART_routines.s
extrn	time_H, time_L 
extrn	Set_Mdelay_counter, M_loop_90R1, M_loop_45R1, M_loop_01, M_loop_45L1, M_loop_90L1 ; from Servo_loops.s
extrn	Delay_3s
extrn	setup_DCmotor, vertical_motion

    
    
psect	udata_acs   ; named variables in access ram

;no variables needed   
psect	code, abs ; absolute address
	
	

rst:
    org 0x00	; Reset vector 
    clrf    PORTG
    goto setup

    
interrupt:
    org	    0x08
    btfss   CCP4IF  ;get out of routine if it is an anomalous interrupt  
    retfie  f;is this necessary?
    bcf	    CCP4IF  ;clear flag (so that not constantly interrupting
    goto    which_interrupt ;rising or falling



setup:
    org	0x100
    ;******* Program FLASH read Setup Code ***********************
    bcf		CFGS	; point to Flash program memory  
    bsf		EEPGD 	; access Flash program memory
    clrf	PORTC      ; clear portc (set pins to a low voltage/0 state) to configure motor
    clrf	TRISC
    call	LCD_Setup
    call	UART_Setup
    call	setup_DCmotor
    goto	main


main:
    call    vertical_motion
    ;*********90L**********
    call    Set_Mdelay_counter
    call    M_loop_90L1
    call    ranger_main
    call    format_for_display
    call    display_on_LCD
    call    send_dists_UART
    ;***********45L*********
    call    Set_Mdelay_counter
    call    M_loop_45L1
    call    ranger_main
    call    format_for_display
    call    display_on_LCD
    call    send_dists_UART
    ;***********0*********
    call    Set_Mdelay_counter
    call    M_loop_01
    call    ranger_main
    call    format_for_display
    call    display_on_LCD
    call    send_dists_UART
    ;***********45R*********
    call    Set_Mdelay_counter
    call    M_loop_45R1
    call    ranger_main
    call    format_for_display
    call    display_on_LCD
    call    send_dists_UART
    ;**********90R**********
    call    Set_Mdelay_counter
    call    M_loop_90L1
    call    ranger_main
    call    format_for_display
    call    display_on_LCD
    call    send_dists_UART
    ;**********************
    call    vertical_motion
    
    goto    main



