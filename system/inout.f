INCLUDE< temps.f>

( Input/output )

: IN  ( bport --> ) PRIM 1%INPORT CW>S ; INLINE

CG" 	in	temp0l, %0" (INPORT:I:::)
CG" 	in	temp0l, %0" (INPORT:I:0::)
CG" 	in	temp0l, %0" (INPORT:I:1::)
CG" 	in	temp0l, %0" (INPORT:I:2::)
CG" 	ld	ZL, Y+
	subi	ZL, -32
	clr	ZH
	ld	temp0l, Z" (INPORT::::)

: OUT ( b1 b2port --> ) PRIM 2%OUTPORT ; INLINE

CG" 	ldi	temp0l, %1
	out	%0, temp0l" (OUTPORT:II:::)
CG" 	out	%0, zero_reg" (OUTPORT:II::0:)
CG" 	ldi	temp0l, %1
	out	%0, temp0l" (OUTPORT:II:0::)
CG" 	out	%0, temp%1l" (OUTPORT:IR:::)
CG" 	out	%0, temp%1l" (OUTPORT:IR::0:)
CG" 	ld	temp0l, Y+
	out	%0, temp0l"  (OUTPORT:I:::)
CG" 	out	1, zero_reg" (OUTPORT:II:1:0:)
CG" 	ld	ZL, Y+
	ld	temp1l, Y+
	subi	ZL, -32
	clr	ZH
	st	Z, temp1l" (OUTPORT::::)

: PORT@ ( bport --> ) IN ; INLINE-FOREVER

: PORT! ( b1 b2port --> ) OUT ; INLINE-FOREVER

