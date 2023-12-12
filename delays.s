#include <xc.inc>

global Delay_3s
    
psect	udata_acs   ; named variables in access ram
D1:  ds	1
D2:  ds	1
D3:  ds	1


psect	delay_code,class=CODE
Delay_3s:
    movlw 0X03
    movwf D1
    movlw 0X82
    movwf D2
    movlw 0XF4
    movwf D3
loop:
    decfsz D1, 1
    goto loop
    decfsz D2, 1
    goto loop
    decfsz D3, 1
    goto loop
    return
