
Code:

Hundreds	equ 0x20
Tens		equ 0x21
units		equ 0x22
working		equ 0x23
numtocon	equ 0x24
count		equ 0x25
   	
	ORG 0x0000 ;reset vector 

	goto start


Start
		clrf	Hundreds
		clrf	Tens
		clrf	Units

		movlw	d'159'	  ;load w with the number to covert
		movwf	numtocon  ;save the number in variable	

		movlw	d'8'
		movwf	count		
ShiftLoop
;test lowerbcd		
		movfw	units
		andlw	b'1111'
		movwf	working
		movlw	d'5'
		subwf	working,0
		SKPC		
		Goto	TestUpperNibble
		movlw	d'3'
		addwf	units
TestUpperNibble		
		movfw	units
		andlw	b'11110000'
		movwf	working
		movlw	H'50'
		subwf	working,0
		SKPC		
		goto	Shiftbit
		movlw	H'30'
		addwf	units
shiftbit
		rlf	units,1
		rlf	hundreds,1
		SKPNC
		bsf	hundreds,0
		rlf	numtocon,1
		SKPNC	
		bsf	Units,0
		decfsz	count
		goto	ShiftLoop
		movfw	Units
		Movwf	Tens
		swapf	Tens,1
		movlw	b'1111'
		andwf	Units,1
		andwf	Tens,1
		movlw	d'48'
		addwf	Hundreds
		addwf	Tens
		addwf	Units


;your code here to display variables on LCD




