( Bits )

: SET-BIT ( c1 c2 --> ) PRIM 2%SETBIT ; INLINE-FOREVER

CG" 	sbi	%0, %1			; Set bit %1 of i/o reg %0" (SETBIT:II:::)
CG" 	sbi	%0, 0			; Set bit 0 of i/o reg %0" (SETBIT:II::0:)
CG" 	sbi	%0, 1			; Set bit 1 of i/o reg %0" (SETBIT:II::1:)
CG" 	sbi	%0, 2			; Set bit 2 of i/o reg %0" (SETBIT:II::2:)

CG" 	in	temp1l, %0		; Load i/o reg %0 to temp1l
	mov	temp2l, one_reg
sbi_@0:	lsl	temp2l
	dec	temp0l
	brne	sbi_@0			; Loop until shift count <> 0
	or	temp2l, temp1l		; Set bit
	out	%0, temp2l		; Out r0 to i/o reg %0" (SETBIT:IR::0:)

: CLR-BIT ( c1 c2 --> ) PRIM 2%CLRBIT ; INLINE-FOREVER

CG" 	cbi	%0, %1			; Clear bit %1 of i/o reg %0" (CLRBIT:II:::)
CG" 	cbi	%0, 0			; Clear bit 0 of i/o reg %0" (CLRBIT:II::0:)
CG" 	cbi	%0, 1			; Clear bit 1 of i/o reg %0" (CLRBIT:II::1:)
CG" 	cbi	%0, 2			; Clear bit 2 of i/o reg %0" (CLRBIT:II::2:)

CG" 	in	temp1l, %0		; Load i/o reg %0 to temp1l
	mov	temp2l, one_reg
sbi_@0:	lsl	temp2l
	dec	temp0l
	brne	sbi_@0			; Loop until shift count <> 0
	com	temp2l			; Inverse temp2l
	and	temp2l, temp1l		; Clear bit
	out	%0, temp2l		; Out r0 to i/o reg %0" (CLRBIT:IR::0:)
