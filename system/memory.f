INCLUDE< temps.f>

( MEMORY ACCESS )

: Q@ ( un --> qq ) PRIM 1&LOADQUAD QW>S ; INLINE

CG" 	lds	temp0q3, %0
	lds	temp0q2, %0 + 1
	lds	temp0q1, %0 + 2
	lds	temp0q0, %0 + 3" (LOADQUAD:I:::)
CG" 	ld	ZH, Y+
	ld	ZL, Y+
	ld	temp0q3, Z
	ldd	temp0q2, Z + 1
	ldd	temp0q1, Z + 2
	ldd	temp0q0, Z + 3" (LOADQUAD::::)

: Q! ( qq un --> ) PRIM 2$SAVEQUAD ; INLINE

CG" 	sts	%0, temp0q3
	sts	%0 + 1, temp0q2
	sts	%0 + 2, temp0q1
	sts	%0 + 3, temp0q0" (SAVEQUAD:IR::0:)
CG" 	ldi	temp0q0, low(%1)
	ldi	temp0q1, high(%1)
	ldi	temp0q2, byte3(%1)
	ldi	temp0q3, byte4(%1)
	sts	%0, temp0q3
	sts	%0 + 1, temp0q2
	sts	%0 + 2, temp0q1
	sts	%0 + 3, temp0q0" (SAVEQUAD:II:::)
CG" 	sts	%0, zero_reg
	sts	%0 + 1, zero_reg
	sts	%0 + 2, zero_reg
	sts	%0 + 3, zero_reg" (SAVEQUAD:II::0:)
CG" 	sts	%0, one_reg
	sts	%0 + 1, zero_reg
	sts	%0 + 2, zero_reg
	sts	%0 + 3, zero_reg" (SAVEQUAD:II::1:)
CG" 	ld	ZH, Y+
	ld	ZL, Y+
	ld	temp0l, Y+
	st	Z, temp0l
	ld	temp0l, Y+
	std	Z + 1, temp0l
	ld	temp0l, Y+
	std	Z + 2, temp0l
	ld	temp0l, Y+
	std	Z + 3, temp0l" (SAVEQUAD::::)
CG" 	ldi	ZH, high(%0)
	ldi	ZL, low(%0)
	ld	temp0l, Y+
	st	Z, temp0l
	ld	temp0l, Y+
	std	Z + 1, temp0l
	ld	temp0l, Y+
	std	Z + 2, temp0l
	ld	temp0l, Y+
	std	Z + 3, temp0l" (SAVEQUAD:I:::)

: D@ ( un --> w ) PRIM 1&LOADWORD W>S ; INLINE

CG" 	lds	temp0h, %0
	lds	temp0l, %0 + 1" (LOADWORD:I:::)
CG" 	lds	temp0h, %0
	lds	temp0l, %0 + 1" (LOADWORD:I:255::)
CG" 	ld	ZH, Y+
	ld	ZL, Y+
	ld	temp0h, Z
	ldd	temp0l, Z + 1" (LOADWORD::::)
CG" 	movw	ZH:ZL, temp0h:temp0l
	ld	temp0h, Z
	ldd	temp1l, Z + 1" (LOADWORD:R:0::)

: D! ( w un --> ) PRIM 2&SAVEWORD ; INLINE

CG" 	sts	%0, temp0h
	sts	%0 + 1, temp0l" (SAVEWORD:IR::0:)
CG" 	sts	%0, temp0h
	sts	%0 + 1, temp0l" (SAVEWORD:IR:255:0:)
CG" 	sts	%0, zero_reg
	sts	%0 + 1, zero_reg" (SAVEWORD:II::0:)
CG" 	ldi	temp0l, low(%1)
	ldi	temp0h, high(%1)
	sts	%0, temp0h
	sts	%0 + 1, temp0l" (SAVEWORD:II:::)
CG" 	ld	temp0h, Y+
	ld	temp0l, Y+
	sts	%0, temp0h
	sts	%0 + 1, temp0l" (SAVEWORD:I:::)
CG" 	ld	ZH, Y+
	ld	ZL, Y+
	ld	temp0l, Y+
	st	Z, temp0l
	ld	temp0l, Y+
	std	Z + 1, temp0l" (SAVEWORD::::)
CG" 	ld	temp1h, Y+
	ld	temp1l, Y+
	movw	ZH:ZL, temp1h:temp1l
	st	Z, temp1h
	std	Z + 1, temp1l" (SAVEWORD:R:0::)
  
: @  ( un --> b ) PRIM 1&LOADBYTE CW>S ; INLINE

CG" 	lds	temp0l, %0		; Load byte from %0" (LOADBYTE:I:::)
CG" 	movw	ZH:ZL, temp0h:temp0l	; Load byte from top of stack
	ld	temp0l, Z" (LOADBYTE:R:0::)
CG" 	ld	ZH, Y+			; Load byte from top of stack
	ld	ZL, Y+
	ld	temp0l, Z" (LOADBYTE::::)

: ! ( b un --> ) PRIM 2*SAVEBYTE ; INLINE

CG" 	sts	%0, zero_reg" (SAVEBYTE:II::0:)
CG" 	sts	%0, one_reg" (SAVEBYTE:II::1:)
CG" 	sts	%0, two_reg" (SAVEBYTE:II::2:)
CG" 	ldi	temp0l, low(%1)
	sts	%0, temp0l" (SAVEBYTE:II:::)
CG" 	sts	%0, temp0l" (SAVEBYTE:IR::0:)
CG" 	ld	temp1l, Y+
	movw	ZH:ZL, temp0h:temp0l
	st	Z, temp1l" (SAVEBYTE:R:0::)
CG" 	ld	temp0l, Y+
	sts	%0, temp0l" (SAVEBYTE:I:::)
CG" 	ld	ZH, Y+
	ld	ZL, Y+
	ld	temp0l, Y+
	st	Z, temp0l" (SAVEBYTE::::)

: P@ ( un --> b ) S>W
A"
	movw	ZH:ZL, temph:templ
	lpm	templ, Z" CW>S ; INLINE

: P@+ ( un --> un+1 b ) S>W
A"
	movw	ZH:ZL, temph:templ
	lpm	templ, Z+
	movw	temp1h:temp1l, ZH:ZL" W>S-1 CW>S ; INLINE

: FILL ( un uc-len b --> ) CS>W-2 CS>W
A"
	ld	ZH, Y+
	ld	ZL, Y+
sys_@1:
	st	Z+, temp2l
	dec	temp0l
	brne	sys_@1" ;
	
: BL ( --> 32 ) 32 ; INLINE-FOREVER
	
: BLANK ( un uc-len --> ) BL FILL ; INLINE

: ERASE ( --> ) 0 FILL ; INLINE

: CMOVE ( un1 un2 uc-len --> ) CS>W
A"
	ld	ZH, Y+
	ld	ZL, Y+
	ld	XH, Y+
	ld	XL, Y+
sys_@1:
	ld	temp1l, X+
	st	Z+, temp1l
	dec	temp0l
	brne	sys_@1" ;

: <CMOVE ( un1 un2 uc-len --> ) CS>W

A"
	ld	ZH, Y+
	ld	ZL, Y+
	ld	XH, Y+
	ld	XL, Y+
	add	ZL, temp0l
	adc	ZH, zero_reg
	add	XL, temp0l
	adc	XH, zero_reg
sys_@1:
	ld	temp1l, -X
	st	-Z, temp1l
	dec	temp0l
	brne	sys_@1" ;

: PMOVE ( un1p un2 uc-len --> ) CS>W
A"
	ld	XH, Y+
	ld	XL, Y+
	ld	ZH, Y+
	ld	ZL, Y+
sys_@1:
	lpm	temp1l, Z+
	st	X+, temp1
	dec	temp0l
	brne	sys_@1" ;
