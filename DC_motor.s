#include <xc.inc>
extrn pulse_delay, ranging_delay, wait_delay, delay_1s
global	setup_DCmotor, vertical_motion

psect dc_motor_code, class = CODE 
 
    
setup_DCmotor:
    clrf LATE, A       ; Clear LATE
    movlw 0x0
    movwf TRISE, A     ; Set PORTE as outputs (TRISE = 0)

    ; Toggle motor on and off in a loop
vertical_motion:
    call delay_1s         ; Wait for some time
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    bsf LATE, 0, A     ; Turn motor on (set RE0 high)
    call wait_delay      ; Wait for some time
    call wait_delay
    call wait_delay
    call wait_delay
    call wait_delay
    bcf LATE, 0, A     ; Turn motor off (clear RE0)
    return




