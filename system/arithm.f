INCLUDE< temps.f>
INCLUDE< stack.f>

: >> ( b1 b2 --> b1 shr b2 ) PRIM 2%SHRBYTE CW>S ; INLINE-FOREVER

CG" 	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_@1			; jump to done
shr_@2:
	lsr	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_@2			; if not zero do shift again
shr_@1:
	mov	temp0l, temp1l		; copy shifted value to work reg" (SHRBYTE:R:0::)

CG" 					; Value to shift in temp0l
	ldi	temp1l,low(%0)		; Load shift counter to temp1l
	cp	temp1l, zero_reg	; if shift counter is 0
	breq	shr_@1			; jump to done
shr_@2:
	lsr	temp0l			; shift right
	dec	temp1l			; decrement shift counter
	brne	shr_@2			; if not zero do shift again
shr_@1:" (SHRBYTE:IR::0:)

CG" 					; Shift counter is 0, do nothing" (SHRBYTE:IR:0:0:)

CG" 	lsr	temp0l			; Value to shift in temp0l" (SHRBYTE:IR:1:0:)

CG" 	lsr	temp0l			; Value to shift in temp0l
	lsr	temp0l			; and shift again" (SHRBYTE:IR:2:0:)

CG"	ldi	temp0l, 0		; if shift counter is 255 then 
					; result is 0" (SHRBYTE:IR:255:0:)

: << ( b1 b2 --> b1 shl b2 ) PRIM 2%SHLBYTE CW>S ; INLINE-FOREVER

CG" 	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_@1			; jump to done
shr_@2:
	lsl	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_@2			; if not zero do shift again
shr_@1:
	mov	temp0l, temp1l		; copy shifted value to work reg" (SHLBYTE:R:0::)

CG" 					; Value to shift in temp0l
	ldi	temp1l,low(%0)		; Load shift counter to temp1l
	cp	temp1l, zero_reg	; if shift counter is 0
	breq	shr_@1			; jump to done
shr_@2:
	lsl	temp0l			; shift right
	dec	temp1l			; decrement shift counter
	brne	shr_@2			; if not zero do shift again
shr_@1:" (SHLBYTE:IR::0:)

CG" 					; Shift counter is 0, do nothing" (SHLBYTE:IR:0:0:)

CG" 	lsl	temp0l			; Value to shift in temp0l" (SHLBYTE:IR:1:0:)

CG" 	lsl	temp0l			; Value to shift in temp0l
	lsl	temp0l			; and shift again" (SHLBYTE:IR:2:0:)

CG"	ldi	temp0l, 0		; if shift counter is 255 then 
					; result is 0" (SHLBYTE:IR:255:0:)

: BV ( b1 --> 1 shl b1 ) 1 SWAP << ; INLINE

: + ( b1 b2 --> b1 + b2 ) PRIM 2%ADDBYTE CW>S ; INLINE

CG" 	inc	temp0l			; increment top of stack" (ADDBYTE:IR:1:0:) 

CG" 	ld	temp0l, Y+		; load top of stack to work reg
	inc	temp0l			; increment top of stack" (ADDBYTE:I:1::) 

CG" 	subi	temp0l, low(-(%0))	; Add imm value to temp0l" (ADDBYTE:IR::0:)

CG" 	ld	temp0l, Y+
	subi	temp0l, low(-(%0))	; Add imm value to (top-1) value" (ADDBYTE:I:::)

CG" 	ld	temp0l, Y+		; Top of stack to temp0l
	ld	temp1l, Y+		; Value under top of stack to temp1l
	add	temp0l, temp1l		; Add (top) and (top-1)" (ADDBYTE::::)

CG" 	ld	temp1l, Y+
	add	temp0l, temp1l" (ADDBYTE:R:0::)

CG" 					; Do nothing" (ADDBYTE:IR:0:0:)

CG" 	subi	temp0l, low(-(%0))	; add 2 to temp0l" (ADDBYTE:IR:2:0:)

CG" 	subi	temp0l, low(-(%0))	; add 255 to temp0l" (ADDBYTE:IR:255:0:)

: - ( b1 b2 --> b1 - b2 ) PRIM 2%SUBBYTE CW>S ; INLINE

CG" 	dec	temp0l			; Decrement top of stack" (SUBBYTE:IR:1:0:)
CG" 	sub	temp0l, two_reg		; Substract 2 from top of stack" (SUBBYTE:IR:2:0:)
CG" 	subi	temp0l, low(%0)		; Substract %0 from top of stack" (SUBBYTE:IR::0:)
CG" 					; Substract 0, do nothing" (SUBBYTE:IR:0:0:)
CG" 	mov	temp0l, temp%1l
	subi	temp0l, low(%0)" (SUBBYTE:IR:::)
CG" 	dec	temp%1l
	mov	temp0l, temp%1l" (SUBBYTE:IR:1::)
CG" 	ld	temp0l, Y+
	subi	temp0l, low(%0)" (SUBBYTE:I:::)
CG" 	ld	temp0l, Y+
	dec	temp0l" (SUBBYTE:I:1::)
CG" 	ld	temp1l, Y+
	ld	temp0l, Y+
	sub	temp0l, temp1l" (SUBBYTE::::)
CG" 	ld	temp1l, Y+
	sub	temp0l, temp1l" (SUBBYTE:R:0::)
CG" 	subi	temp0l, 255		; Sub 255 from temp0l" (SUBBYTE:IR:255:0:)


: * ( c1 c2 --> c1 * c2 ) PRIM 2%MULBYTE CW>S ; INLINE

CG" 	ld	temp0l, Y+
	ld	temp1l, Y+
	muls	temp0l, temp1l
	mov	temp0l, r0" (MULBYTE::::)
CG" 	ldi	temp1l, low(%0)
	muls	temp0l, temp1l
	mov	temp0l, r0" (MULBYTE:IR::0:)
CG" 	ldi	temp3l, low(%0)
	muls	temp%1l, temp3l
	mov	temp0l, r0" (MULBYTE:IR:::)
CG" 	ld	temp1l, Y+
	ldi	temp0l, low(%0)
	muls	temp0l, temp1l
	mov	temp0l, r0" (MULBYTE:I:::)

CG" 	ld	temp1l, Y+		; Value under top of stack to temp1l
	muls	temp0l, temp1l		; Top of stack in temp0l
	mov	temp0l, r0		; Move result of muls to temp0l" (MULBYTE:R:0::)

CG" 	mov	temp0l, zero_reg	; Mul to zero" (MULBYTE:IR:0:0:)

CG" 					; Mul to one" (MULBYTE:IR:1:0:)

CG" 	add	temp0l, temp0l		; Mul to two" (MULBYTE:IR:2:0:)

CG" 	ldi	temp1l, 255		; Mul to 255
	muls	temp0l, temp1l
	mov	temp0l, r0		; Result from r0 to temp0l" (MULBYTE:IR:255:0:)

: 1+ ( b --> b + 1 ) 1 + ; INLINE
: 1- ( b --> b - 1 ) 1 - ; INLINE

: /MOD ( c1->t0 c2->t1 --> c1 mod c2, c1 / c2) PRIM 2%DIVMODBYTE CW>S-1 CW>S ;

CG" 	ld	temp1l, Y+
	ld	temp0l, Y+
	call	`(/MOD)`" (DIVMODBYTE::::)

(
	c1 = temp0l 
	c2 = templ1
	c1 mod c2 = temp1l
	c1 / c2 = temp0l
)

CG" 
	mov	dv8s, temp1l
	mov	d8s,dd8s
	eor	d8s,dv8s
	sbrc	dv8s,7
	neg	dv8s
	sbrc	dd8s,7
	neg	dd8s
	sub	drem8s,drem8s
	ldi	dcnt8s,9
d8s_@1:	rol	dd8s
	dec	dcnt8s
	brne	d8s_@2
	sbrc	d8s,7
	neg	dres8s
	rjmp	d8s_@4
d8s_@2:	rol	drem8s
	sub	drem8s,dv8s
	brcc	d8s_@3
	add	drem8s,dv8s
	clc
	rjmp	d8s_@1
d8s_@3:	sec
	rjmp	d8s_@1
d8s_@4:	mov	temp1l, drem8s" (/MOD)

: / ( c1 c2 --> c1 / c2 ) /MOD SWAP DROP ; INLINE

: MOD ( c1 c2 --> c1 / c2 ) /MOD DROP ; INLINE

: 2* ( b --> b * 2 ) 1 << ; INLINE

: 2/ ( b --> b / 2 ) 1 >> ; INLINE

: NEGATE ( c --> -c ) PRIM 1%NEGBYTE CW>S ; INLINE

CG" 	neg	temp0l			; Negate top of stack" (NEGBYTE:R:0::)

CG" 	ldi	temp0l, low(-(%0))	; Negate %0" (NEGBYTE:I:::)

CG" 	mov	temp0l, zero_reg	; Negate zero" (NEGBYTE:I:0::)
CG" 	ldi	temp0l, low(-1)		; Negate one" (NEGBYTE:I:1::)
CG" 	ldi	temp0l, low(-2)		; Negate two" (NEGBYTE:I:2::)
CG" 	ldi	temp0l, low(-255)	; Negate 255" (NEGBYTE:I:255::)

CG" 	ld	temp0l, Y+		; Load top of stack to temp0l
	neg	temp0l			; Negate temp0l" (NEGBYTE::::)

: ABS ( c --> -c if c < 0 else c )
  CS>W-1 A"
	cp	temp1l, zero_reg
	brmi	abs_@1
	mov	templ, temp1l
	rjmp	abs_@2
abs_@1:	mov	templ, zero_reg
	sub	templ, temp1l
abs_@2:" CW>S ;

: MIN ( c1 c2 --> c3 ) CS>W CS>W-1
A"
	cp	templ, temp1l
	brpl	sys_@1
	rjmp	sys_@2
sys_@1:
	mov	templ, temp1l
sys_@2:
" CW>S ; INLINE

: MAX ( c1 c2 --> c3 ) CS>W CS>W-1
A"
	cp	temp1l, templ
	brpl	sys_@1
	rjmp	sys_@2
sys_@1:
	mov	templ, temp1l
sys_@2:
" CW>S ; INLINE
