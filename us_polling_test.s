#include <xc.inc>
    
psect ranger_code, class = CODE
    
extrn pulse_delay, ranging_delay, wait_delay

trigger_flag set 0x20	    ; Define a flag to reflect if the first range finder
			    ; has been activated or not.

time_one_H:	ds 1
time_one_L:	ds 1
time_two_H:	ds 1
time_two_L:	ds 1
			
org 0x00
start:
    goto    ranger_main
    
ranger_main:
    bcf	    trigger_flag, 0
    call    trigger_one
    bsf	    trigger_flag, 0
    call    trigger_two
    return
    
trigger_one:
    ; Trigger the first ultrasonic range finder
    movlw   0x00
    movwf   TRISG	    ; Make all pins on PORTH outputs
    bsf	    LATG, 3	    ; Set pin 3 to be high
    call    pulse_delay 
    bcf	    LATG, 3	    ; Set pin 3 to be low
    movlw   0xFF
    movwf   TRISG	    ; Make all pins on PORTH inputs
    call    ranging_delay
    movlw   0x00		
    movwf   time_one_H	    ; Sets  counter to be 0 initially 
    movwf   time_one_L
    btfss   PORTG, 3	    ; Check if pin 3 on PORTG is high.
    goto    $-1
    call    measure_pulse_one
    return
    
measure_pulse_one:	
    btfss   PORTG, 3
    goto    yield_pulse	    ; Pulse is finished so return to main function
    incf    time_one_L 
    btfsc   STATUS, 0	    ; test carry bit, add to LENH
    incf    time_one_H
    goto    measure_pulse_one
    
trigger_two:
    ; Trigger the second ultrasonic range finder.
    movlw   0x00
    movwf   TRISG	; Make all pins on PORTH outputs.
    bsf	    LATG, 4	; Set pin 3 to be high.
    call    pulse_delay 
    bcf	    LATG, 4	; Set pin 3 to be low.
    movlw   0xFF
    movwf   TRISG	; Make all pins on PORTH inputs
    call    ranging_delay
    call    measure_pulse_two
    return
    
measure_pulse_two:	
    btfss   PORTG, 3
    goto    yield_pulse	    ; Pulse is finished so return to main function
    incf    time_one_L 
    btfsc   STATUS, 0	    ; test carry bit, add to LENH
    incf    time_one_H
    goto    measure_pulse_one
    
yield_pulse:
    return