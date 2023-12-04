; Assembly code for pic18 to control a servo motor in 30 degree increments

#include <xc.inc>


    org 0x0000
    goto setup_PMW

; initialization
setup_PMW:
    ;configures PORTC as output, 
    ;sets up the CCP1 module for PWM operation, 
    ;configures Timer2 (including its period) for PWM signal generation, 
    ;starts Timer2
    ;RESULT: PWM signal generated on the CCP1 pin, with a frequency determined by the settings in T2CON and PR2.
    
    clrf portc      ; clear portc (set pins to a low voltage/0 state)
    movlw 0x00      ; set portc as output
    movwf TRISC	    ; move the value in the working register (0x00) to the Tri-State Control register for PORTC
    ; This configures all pins in port C as outputs
    movlw 0b00001100 ; move value to register (in order to configure CCP1 pin)
    movwf ccp1con   
    movlw 0x0f      ; configure timer2 for pwm frequency of 50hz
    movwf T2CON	    ; 
    movlw 0x4c      ; load pr2 for a pwm frequency of 50hz
    movwf pr2	    ; PR2 is used with T2CON to get the period right

    bsf t2con, tmr2on ; turn on timer2


rotate_servo:
    ; rotate servo in 30 degree increments, until 180 degrees attained
    ; The literal values correspond to the pulse widths needed to move the servo to specific angles (duty clycles)
    movlw 0x1f ; approx. duty cycle for 0 degrees
    movwf ccpr1l
    call delay ; To allow time for the motor to reach that position

    movlw 0x23 ; approx. duty cycle for 30 degrees
    movwf ccpr1l
    call delay

    movlw 0x27 ; approx. duty cycle for 60 degrees
    movwf ccpr1l
    call delay

    movlw 0x2b ; approx. duty cycle for 90 degrees
    movwf ccpr1l ; this register is part of the PWM control register. It sets the duty cycle of the PWM signal to determine the motor's position
    call delay

    movlw 0x2f ; approx. duty cycle for 120 degrees
    movwf ccpr1l
    call delay

    movlw 0x33 ; approx. duty cycle for 150 degrees
    movwf ccpr1l
    call delay

    movlw 0x37 ; approx. duty cycle for 180 degrees
    movwf ccpr1l
    call delay

    goto rotate_servo ; continuous loop for the motor to move between these angles continuously

; delay routine
delay:
    ; implement a delay loop here according to your requirement
    ; Create a nested delay to increase delay duration
    movlw D'250'
    movwf FSR0L
outer_loop:
    movlw D'250'
    movwf FSR1L
inner_loop:
    decfsz FSR1L, F
    goto inner_loop
    decfsz FSR0L, F
    goto outer_loop
    return
    return

    end
