CG"	in	r0, SREG
	push	r0
	cli
sys_@1:
	sbic	EECR, EEWE
	rjmp	sys_@1
	out	EEARH, temp0h
	out	EEARL, temp0l
	out	EEDR, temp1l
	sbi	EECR, EEMWE
	sbi	EECR, EEWE
	pop	r0
	out	SREG, r0" (EEPROM!)

: EEPROM! ( c addr --> write c to eeprom at addr ) S>W CS>W-1 A" {(EEPROM!)}" ;

: EEPROM-WRITE-BLOCK ( ram-addr eeprom-addr n-len --> ) S>W-2 S>W S>W-1
A"
	movw	YH:YL, temp1h:temp1l
	movw	XH:XL, temp2h:temp2l
sys_@1:
	ld	temp1l, Y+
	call	`(EEPROM!)`
	subi	temp0l, low(-1)
	sbci	temp0h, high(-1)
	sbiw	XH:XL, 1
	brne	sys_@1
" ;

CG" 	in	r0, SREG
	push	r0
	cli
sys_@1:
	sbic	EECR, EEWE
	rjmp	sys_@1
	out	EEARH, temp0h
	out	EEARL, temp0l
	sbi	EECR, EERE
	in	temp1l, EEDR
	pop	r0
	out	SREG, r0" (EEPROM@)

: EEPROM@ ( addr --> c ) S>W A" {(EEPROM@)}" CW>S-1 ;

: EEPROM-READ-BLOCK ( eeprom-addr ram-addr n-len --> ) S>W-2 S>W-1 S>W
A"
	movw	YH:YL, temp1h:temp1l
	movw	XH:XL, temp2h:temp2l
sys_@1:
	call	`(EEPROM@)`
	st	-Y, temp1l
	subi	temp0l, low(-1)
	sbci	temp0h, high(-1)
	sbiw	XH:XL, 1
	brne	sys_@1
" ;
