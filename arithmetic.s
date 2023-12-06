#include <xc.inc>
    
psect usrf ; Defining a psect

extrn time1, time2
    
const1: ds 1
const2: ds 1
    
distance_conversion:
    movff time1, dist1
    movff time2, dist2
    
    
    

    
