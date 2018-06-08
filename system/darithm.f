INCLUDE< temps.f>
INCLUDE< stack.f>

( ARITHMETIC WORD )

: D+ ( w1 w2 --> w1 + w2 ) PRIM 2&ADDWORD W>S ; INLINE

CG" 	add	temp0l, one_reg
	adc	temp0h, zero_reg" (ADDWORD:IR:1:0:)
CG" 	subi	temp%1l, low(-(%0))
	sbci	temp%1h, high(-(%0))
	movw	temp0h:temp0l, temp%1h:temp%1l" (ADDWORD:IR:::)
CG" 	ld	temp0h, Y+
	ld	temp0l, Y+
	subi	temp0l, low(-(%0))
	sbci	temp0h, high(-(%0))"(ADDWORD:I:::)
CG" 	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h" (ADDWORD:R:0::)
CG" 	ld	temp0h, Y+
	ld	temp0l, Y+
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h" (ADDWORD::::)
CG" 	add	temp0l, temp%0l
	adc	temp0h, temp%0h" (ADDWORD:RR::0:)

: D- ( w1 w2 --> w1 - w2 ) PRIM 2&SUBWORD W>S ; INLINE

CG" 	ld	temp1h,	Y+
	ld	temp1l, Y+
	sub	temp1l, temp0l
	sbc	temp1h, temp0h
	movw	temp0h:temp0l, temp1h:temp1l" (SUBWORD:R:0::)
CG" 	subi	temp0l, 1
	sbci	temp0h, 0" (SUBWORD:IR:1:0:)
CG" 	subi	temp0l, low(%0)
	sbci	temp0h, high(%0)" (SUBWORD:IR::0:)
CG" 	sub	temp0l, temp%0l
	sbc	temp0h, temp%0h" (SUBWORD:RR::0:)
CG" 	ld	temp0h, Y+
	ld	temp0l, Y+
	ld	temp1h, Y+
	ld	temp1l, Y+
	sub	temp0l, temp1l
	sbc	temp0h, temp1h" (SUBWORD::::)
	
: D1+ ( w --> w + 1 ) 1. D+ ; INLINE-FOREVER
: D1- ( w --> w - 1 ) 1. D- ; INLINE-FOREVER

: D* ( n1 n2 --> n1 * n2 ) S>W-1 S>W A"
; r17:r16 = r23:r22 * r21:r20
	movw	r23:r22, temph:templ
	movw	r21:r20, temp1h:temp1l
	mul	r22, r20
	movw	r17:r16, r1:r0
	mul	r23, r20
	add	r17, r0
	mul	r21, r22
	add	r17, r0" W>S ;

: D/MOD ( n1 n2 --> n1 mod n2, n1 / n2) S>W-1 S>W
A"
	mov	d16s,dd16sH
	eor	d16s,dv16sH
	sbrs	dd16sH,7
	rjmp	d16s_@1
	com	dd16sH
	com	dd16sL		
	subi	dd16sL,low(-1)
	sbci	dd16sL,high(-1)
d16s_@1:
	sbrs	dv16sH,7
	rjmp	d16s_@2
	com	dv16sH
	com	dv16sL		
	subi	dv16sL,low(-1)
	sbci	dv16sL,high(-1)
d16s_@2:
	clr	drem16sL
	sub	drem16sH,drem16sH
	ldi	dcnt16s,17
d16s_@3:
	rol	dd16sL
	rol	dd16sH
	dec	dcnt16s
	brne	d16s_@5
	sbrs	d16s,7
	rjmp	d16s_@4
	com	dres16sH
	com	dres16sL
	subi	dres16sL,low(-1)
	sbci	dres16sH,high(-1)
d16s_@4:	
	rjmp	d16s_@9
d16s_@5:
	rol	drem16sL
	rol	drem16sH
	sub	drem16sL,dv16sL
	sbc	drem16sH,dv16sH
	brcc	d16s_@6
	add	drem16sL,dv16sL
	adc	drem16sH,dv16sH
	clc
	rjmp	d16s_@3
d16s_@6:
	sec
	rjmp	d16s_@3
d16s_@9:
	movw	temp1h:temp1l, drem16sH:drem16sL" W>S-1 W>S ;

: D/ ( n1 n2 --> n1 / n2 ) D/MOD DSWAP DDROP ; INLINE

: DMOD ( n1 n2 --> n1 mod n2) D/MOD DDROP ; INLINE

: D2* ( n1 --> n2 ) S>W A"
	lsl	templ
	ror	temph" W>S ; INLINE


: D2/ S>W ( n1 --> n2 ) A"
	asr	temph
	ror	templ" W>S ; INLINE

: DNEGATE ( n --> -n ) S>W-1 A"
	mov	templ, zero_reg
	mov	temph, zero_reg
	sub	templ, temp1l
	sbc	temph, temp1h" W>S ; INLINE

: DABS ( n1 --> n2 ) S>W-1 A"
	cp	temp1l, zero_reg
	cpc	temp1h, zero_reg
	brmi	abs_@1
	movw	temph:templ, temp1h:temp1l
	rjmp	abs_@2
abs_@1:	mov	templ, zero_reg
	mov	temph, zero_reg
	sub	templ, temp1l
	sbc	temph, temp1h
abs_@2:
" W>S ;
