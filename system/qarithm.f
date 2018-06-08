INCLUDE< temps.f>
INCLUDE< stack.f>

( ARITHMETIC QUAD )

: Q+ ( qq1 qq2 --> qq1 + qq2 ) PRIM 2#ADDQUAD QW>S ; INLINE

CG" 	add	temp0q0, one_reg
	adc	temp0q1, zero_reg
	adc	temp0q2, zero_reg
	adc	temp0q3, zero_reg" (ADDQUAD:IR:1:0:)

CG" 	add	temp0q0, two_reg
	adc	temp0q1, zero_reg
	adc	temp0q2, zero_reg
	adc	temp0q3, zero_reg" (ADDQUAD:IR:2:0:)

CG" 	subi	temp0q0, low(-(%0))
	sbci	temp0q1, high(-(%0))
	sbci	temp0q2, byte3(-(%0))
	sbci	temp0q3, byte4(-(%0))" (ADDQUAD:IR::0:)
	
CG" 	ld	temp0q3, Y+
	ld	temp0q2, Y+
	ld	temp0q1, Y+
	ld	temp0q0, Y+
	ld	temp1q3, Y+
	ld	temp1q2, Y+
	ld	temp1q1, Y+
	ld	temp1q0, Y+
	add	temp0q0, temp1q0
	adc	temp0q1, temp1q1
	adc	temp0q2, temp1q2
	adc	temp0q3, temp1q3" (ADDQUAD::::)

CG" 	ld	temp1q3, Y+
	ld	temp1q2, Y+
	ld	temp1q1, Y+
	ld	temp1q0, Y+
	add	temp0q0, temp1q0
	adc	temp0q1, temp1q1
	adc	temp0q2, temp1q2
	adc	temp0q3, temp1q3" (ADDQUAD:R:0::)

: Q- ( qq1 qq2 --> qq1 - qq2 ) PRIM 2#SUBQUAD QW>S ; INLINE

CG" 	sub	temp0q0, one_reg
	sbc	temp0q1, zero_reg
	sbc	temp0q2, zero_reg
	sbc	temp0q3, zero_reg" (SUBQUAD:IR:1:0:)

: Q* ( q1 q2 --> q1 * q2 ) PRIM 2#MULQUAD QW>S ;

CG" 	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	ld	r21, Y+
	ld	r20, Y+
	ld	r19, Y+
	ld	r18, Y+
	call	`(Q*)`
	movw	temp0q1:temp0q0, r23:r22
	movw	temp0q3:temp0q2, r25:r24" (MULQUAD::::)

CG"
	mul	r22, r18
	movw	r26, r0
	mul	r23, r19
	movw	r30, r0
	mul	r24, r18
	add	r30, r0
	adc	r31, r1
	mul	r22, r20
	add	r30, r0
	adc	r31, r1
	mul	r25, r18
	add	r31, r0
	mul	r24, r19
	add	r31, r0
	mul	r23, r20
	add	r31, r0
	mul	r22, r21
	add	r31, r0
	eor	r25, r25
	mul	r23, r18
	add	r27, r0
	adc	r30, r1
	adc	r31, r25
	mul	r22, r19
	add	r27, r0
	adc	r30, r1
	adc	r31, r25
	movw	r22, r26
	movw	r24, r30" (Q*)
	
: QU* ( uq1 uq2 --> uq1 * uq2 ) PRIM 2#UMULQUAD QW>S ;

CG" 	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	ld	r21, Y+
	ld	r20, Y+
	ld	r19, Y+
	ld	r18, Y+
	call	`(QU*)`
	movw	temp0q1:temp0q0, r23:r22
	movw	temp0q3:temp0q2, r25:r24" (UMULQUAD::::)

CG" 	ldi	r22, low(%0)
	ldi	r23, high(%0)
	ldi	r24, byte3(%0)
	ldi	r25, byte4(%0)
	ld	r21, Y+
	ld	r20, Y+
	ld	r19, Y+
	ld	r18, Y+
	call	`(QU*)`
	movw	temp0q1:temp0q0, r23:r22
	movw	temp0q3:temp0q2, r25:r24" (UMULQUAD:I:::)
	
( 22/23/24/25 - 1st 18/19/20/21 - 2nd ) 

CG" 	push	YH
	push	YL
	mul	r22, r18
	movw	r26, r0
	mul	r23, r19
	movw	r30, r0
	mul	r24, r18
	add	r30, r0
	adc	r31, r1
	mul	r22, r20
	add	r30, r0
	adc	r31, r1
	mul	r25, r18
	add	r31, r0
	mul	r24, r19
	add	r31, r0
	mul	r23, r20
	add	r31, r0
	mul	r22, r21
	add	r31, r0
	eor	r25, r25
	mul	r23, r18
	add	r27, r0
	adc	r30, r1
	adc	r31, r25
	mul	r22, r19
	add	r27, r0
	adc	r30, r1
	adc	r31, r25
	movw	r22, r26
	movw	r24, r30
	pop	YL
	pop	YH" (QU*)
	 
: Q/MOD ( q1 q2 --> q1 mod q2, q1 / q2) PRIM 2#DIVMODQUAD ( QW>S QW>S-1 ) ;
: Q/ QSWAP QDROP ;
: QMOD QDROP ;

CG" 	ld	r21, Y+
	ld	r20, Y+
	ld	r19, Y+
	ld	r18, Y+
	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	push	YH
	push	YL
	call	`(Q/MOD)`
	pop	YL
	pop	YH
	st	-Y, r22
	st	-Y, r23
	st	-Y, r24
	st	-Y, r25
	st	-Y, r18
	st	-Y, r19
	st	-Y, r20
	st	-Y, r21" (DIVMODQUAD::::)

CG" 	ldi	r18, low(%0)
	ldi	r19, high(%0)
	ldi	r20, byte3(%0)
	ldi	r21, byte4(%0)
	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	push	YH
	push	YL
	call	`(Q/MOD)`
	pop	YL
	pop	YH
	st	-Y, r22
	st	-Y, r23
	st	-Y, r24
	st	-Y, r25
	st	-Y, r18
	st	-Y, r19
	st	-Y, r20
	st	-Y, r21" (DIVMODQUAD:I:::)

CG" 	mov	r21, temp0q3
	mov	r20, temp0q2
	mov	r19, temp0q1
	mov	r18, temp0q0
	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	push	YH
	push	YL
	call	`(Q/MOD)`
	pop	YL
	pop	YH
	st	-Y, r22
	st	-Y, r23
	st	-Y, r24
	st	-Y, r25
	st	-Y, r18
	st	-Y, r19
	st	-Y, r20
	st	-Y, r21" (DIVMODQUAD:R:0::)

CG" 	bst	r25, 7
	mov	r0, r25
	eor	r0, r21
	rcall	divmods_1     	; 0xad2
	sbrc	r21, 7
	rcall	divmods_2      	; 0xac2
	rcall	divmods_3     	; 0xae4
	rcall	divmods_1     	; 0xad2
	adc	r0, r0
	brcc	divmods_4     	; 0xad0
 
divmods_2:
 
	com	r21
	com	r20
	com	r19
	neg	r18
	sbci	r19, 0xFF	; 255
	sbci	r20, 0xFF	; 255
	sbci	r21, 0xFF	; 255
 
divmods_4:
 
	ret
 
divmods_1:
 
	brtc	divmods_4      	; 0xad0
	com	r25
	com	r24
	com	r23
	neg	r22
	sbci	r23, 0xFF	; 255
	sbci	r24, 0xFF	; 255
	sbci	r25, 0xFF	; 255
	ret
 
divmods_3:
 
	ldi	r26, 0x21	; 33
	mov	r1, r26
	sub	r26, r26
	sub	r27, r27
	movw	r30, r26
	rjmp	divmods_5     	; 0xb0a
 
divmods_6:
 
	adc	r26, r26
	adc	r27, r27
	adc	r30, r30
	adc	r31, r31
	cp	r26, r18
	cpc	r27, r19
	cpc	r30, r20
	cpc	r31, r21
	brcs	divmods_5      	; 0xb0a
	sub	r26, r18
	sbc	r27, r19
	sbc	r30, r20
	sbc	r31, r21
 
divmods_5:
 
	adc	r22, r22
	adc	r23, r23
	adc	r24, r24
	adc	r25, r25
	dec	r1
	brne	divmods_6     	; 0xaf0
	com	r22
	com	r23
	com	r24
	com	r25
	movw	r18, r22
	movw	r20, r24
	movw	r22, r26
	movw	r24, r30" (Q/MOD)

: QABS QS>W-1 A"
	cp	temp1q0, zero_reg
	cpc	temp1q1, zero_reg
	cpc	temp1q2, zero_reg
	cpc	temp1q3, zero_reg
	brmi	abs_@1
	movw	temp0q1:temp0q0, temp1q1:temp1q0
	movw	temp0q3:temp0q2, temp1q3:temp1q2
	rjmp	abs_@2
abs_@1:
	mov	temp0q0, zero_reg
	mov	temp0q1, zero_reg
	movw	temp0q3:temp0q2, temp0q1:temp0q0
	sub	temp0q0, temp1q0
	sbc	temp0q1, temp1q1
	sbc	temp0q2, temp1q2
	sbc	temp0q3, temp1q3
abs_@2:
" QW>S ;

: QU/MOD ( uq1 uq2 --> uq1 mod uq2, uq1 / uq2) PRIM 2#UDIVMODQUAD ( QW>S QW>S-1 ) ;

CG" 	ld	r21, Y+
	ld	r20, Y+
	ld	r19, Y+
	ld	r18, Y+
	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	push	YH
	push	YL
	call	`(QU/MOD)`
	pop	YL
	pop	YH
	st	-Y, r22
	st	-Y, r23
	st	-Y, r24
	st	-Y, r25
	st	-Y, r18
	st	-Y, r19
	st	-Y, r20
	st	-Y, r21" (UDIVMODQUAD::::)

CG" 	ldi	r18, low(%0)
	ldi	r19, high(%0)
	ldi	r20, byte3(%0)
	ldi	r21, byte4(%0)
	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	push	YH
	push	YL
	call	`(QU/MOD)`
	pop	YL
	pop	YH
	st	-Y, r22
	st	-Y, r23
	st	-Y, r24
	st	-Y, r25
	st	-Y, r18
	st	-Y, r19
	st	-Y, r20
	st	-Y, r21" (UDIVMODQUAD:I:::)

CG"
	ldi	r26, 0x21	; 33
	mov	r1, r26
	sub	r26, r26
	sub	r27, r27
	movw	r30, r26
	rjmp	udivmod_1     	; 0xad4

udivmod_2:
 
	adc	r26, r26
	adc	r27, r27
	adc	r30, r30
	adc	r31, r31
	cp	r26, r18
	cpc	r27, r19
	cpc	r30, r20
	cpc	r31, r21
	brcs	udivmod_1      	; 0xad4
	sub	r26, r18
	sbc	r27, r19
	sbc	r30, r20
	sbc	r31, r21

udivmod_1:
 
	adc	r22, r22
	adc	r23, r23
	adc	r24, r24
	adc	r25, r25
	dec	r1
	brne	udivmod_2     	; 0xaba
	com	r22
	com	r23
	com	r24
	com	r25
	movw	r18, r22
	movw	r20, r24
	movw	r22, r26
	movw	r24, r30" (QU/MOD)
	

