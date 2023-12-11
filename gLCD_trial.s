#include <xc.inc>

psect gLCD_code, class = CODE
    
cblock  0x000

d1	    ; Delay routine work files.
d2
d3				
GWORK1	    ; gLCD work files.
GWORK2
GWORK3
GPAGENUM    ; Holds the current page number.			
TABWORK	    ; Tables work file.

endc

    
org 0x00    
start:
    goto gLCD_main
    
gLCD_main:
    B