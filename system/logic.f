INCLUDE< temps.f>

( LOGICAL BYTE )

: AND ( b1 b2 --> b1 and b2 ) PRIM 2%ANDBYTE CW>S ; INLINE

CG" 	andi	temp0l, low(%0)" (ANDBYTE:IR::0:)
CG" 	andi	temp%1l, low(%0)" (ANDBYTE:IR:::)
CG" 	ld	temp0l, Y+
	andi	temp0l, low(%0)" (ANDBYTE:I:::)
CG" 	ld	temp1l, Y+
	and	temp0l, temp1l" (ANDBYTE:R:0::)
CG" 	ld	temp0l, Y+
	ld	temp1l, Y+
	and	temp0l, temp1l" (ANDBYTE::::)

: OR  ( b1 b2 --> b1 or b2 )  PRIM 2%ORBYTE  CW>S ; INLINE

CG" 	ld	temp1l, Y+
	or	temp0l, temp1l" (ORBYTE:R:0::)
CG" 	ori	temp0l, low(%0)" (ORBYTE:IR::0:)
CG" 	ld	temp0l, Y+
	ld	temp1l, Y+
	or	temp0l, temp1l" (ORBYTE::::)

: NOT ( b1 b2 --> b1 and b2 ) PRIM 1%NOTBYTE CW>S ; INLINE

CG" 	com	temp0l" (NOTBYTE:R:0::)
CG" 	ld	temp0l, Y+
	com	temp0l" (NOTBYTE::::)

: XOR ( b1 b2 --> b1 and b2 ) PRIM 2%XORBYTE CW>S ; INLINE
