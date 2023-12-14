#include <xc.inc>
extrn pulse_delay, ranging_delay, wait_delay, delay_1s

psect code, abs

main:
    org 0x0
    goto start

    org 0x100          ; Main code starts here at address 0x100
start:
    clrf LATE, A       ; Clear LATE
    movlw 0x0
    movwf TRISE, A     ; Set PORTE as outputs (TRISE = 0)

    ; Toggle motor on and off in a loop
loop:
    call delay_1s         ; Wait for some time
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    bsf LATE, 0, A     ; Turn motor on (set RE0 high)
    call delay_1s         ; Wait for some time
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    call delay_1s
    bcf LATE, 0, A     ; Turn motor off (clear RE0)
    goto loop


    end main
