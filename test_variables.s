#include <xc.inc>
global variable_code, time_one_H
psect udata_acs
time_one_H:	ds 1
psect variable_code, class = CODE
variable_code:
    movlw   0x76    
    movwf   time_one_H


