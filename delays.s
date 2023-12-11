#include <xc.inc>

global Delay_3s
    
DCounter1 EQU 0X0C
DCounter2 EQU 0X0D
DCounter3 EQU 0X0E


Delay_3s:
    movlw 0X03
    movwf DCounter1
    movlw 0X82
    movwf DCounter2
    movlw 0XF4
    movwf DCounter3
loop:
    decfsz DCounter1, 1
    goto loop
    decfsz DCounter2, 1
    goto loop
    decfsz DCounter3, 1
    goto loop
    return
