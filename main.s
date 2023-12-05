#include <xc.inc>
    
psect usrf ; Defining a psect

extrn pulse_delay, wait_delay
extrn ultra1_main, ultra1_time1, ultra1_time2, 
extrn ultra2_main, ultra2_time1, ultra2_time2, 

global usrf_main
    
usrf_main:
    ; This would be shortened to rf but I wanted to avoid any
    ; confusion with radio frequency 
    
    call ultra1_main
    call ultra2_main
    call dist_conv
    return
    
dist_conv:
    goto usrf_main