#include <xc.inc>

psect code ; Defining a psect
    
extrn pulse_delay, 
 
global ultra2_main, ultra2_time1, ultra2_time2
 
ultra2_main:
    ; This would be named rf but I wanted to avoid any confusion with radio 
    ; frequency

    trig_two: 
    ; Create a 10 us pulse at the RB3 pin which is connected to the 
    ; first ultrasonic sensor 	
    movlw 0x00
    movwf TRISH ; Set all pins as outputs.
    bsf LATH, 3 ; Set pin 3 on PORTH high.
    call pulse_delay 
    bsf LATH, 3 ; Set pin 3 on PORTH low.
    movlw 0xFF
    movwf TRISH ; Set all pins as inputs
    goto measure_pulse
   
    interrupt_handler:
    org 0x08
    movff CCPR1H, ultra2_time1
    movff CCPR1L, ultra2_time2
    clrf CCP1CON
    retfie 
    
    measure_pulse:
    ; Measure the length of the return pulse using Timer1.
    ;                     ________
    ; Pulse over time ___|        |_____
    ;                    <-------->
    btfsc CCP1CON, CCP4IF ; Check if CCP1 interrupt flag is set
    return ; Exit if the interrupt flag is not set
    movlw 0xB3 ; Bits 7:6 set the IO port as the coordinator. The timer is 
	       ; prescaled by 8 to prevent overflows. 
    movwf T1CON
    bsf TMR1IE
    clrf CCP1CON ; Clear CCP module
    movlw 0x84 ; Bit 7 enables CCP and bits 3:0 means that it is triggered
	       ; on falling edges.
    movwf CCP1CON ; Setting up CCP timer in capture mode
    goto $
    end trig_two
    
return 
    


