INCLUDE< temps.f>
INCLUDE< stack.f>
INCLUDE< logic.f>

: (?BRANCH) PRIM 1%?BRANCH ; INLINE-FOREVER

CG" 	ld	temp0l, Y+
	cp	temp0l, zero_reg
	breq	%0" (?BRANCH::::)
CG" ;	1 is true" (?BRANCH:I:1::)
CG" 	cp	temp0l, zero_reg
	breq	%1" (?BRANCH:R:0::)
CG" ;	255 is true" (?BRANCH:I:255::)
CG" 	rjmp	%1" (?BRANCH:I:0::)

: (UNTIL) (?BRANCH) ; INLINE-FOREVER

: (DO) ( b1 b2 --> ) PRIM STARTDO PRIM 2%SET_LOOP_B ; INLINE-FOREVER

: (LOOP) ( --> ) PRIM INC_LOOP_ONE_B PRIM COMP_LOOP_B ; INLINE-FOREVER
	
: (+LOOP) ( c --> ) PRIM 1%INC_LOOP_PLUS_B PRIM COMP_LOOP_B ; INLINE-FOREVER

: (LOOP-CLEAN) ( --> ) PRIM ENDDO ; INLINE-FOREVER
	
: I ( --> b ) PRIM GET_CNT_B0 CW>S ; INLINE-FOREVER

: DI ( --> w ) PRIM GET_CNT_W0 W>S ; INLINE-FOREVER
	
: J ( --> b ) PRIM GET_CNT_B1 CW>S ; INLINE-FOREVER

: K ( --> b ) PRIM GET_CNT_B2 CW>S ; INLINE-FOREVER

: (UNTIL-BIT-SET) ( b1 b2 --> ) PRIM 2%UNTIL_BIT_SET ; INLINE-FOREVER

CG" 	sbrc	temp0l, %0" (UNTIL_BIT_SET:IR::0:)
CG" 	ld	temp0l, Y+
	sbrc	temp0l, %0" (UNTIL_BIT_SET:I:::)

: (UNTIL-BIT-CLEAR) ( b1 b2 --> ) PRIM 2%UNTIL_BIT_CLEAR ; INLINE-FOREVER

CG" 	sbrs	temp0l, %0" (UNTIL_BIT_CLEAR:IR::0:)
CG" 	ld	temp0l, Y+
	sbrs	temp0l, %0" (UNTIL_BIT_CLEAR:I:::)

: RETURN ( --> ) PRIM BRANCHTOEXIT ; INLINE-FOREVER

: RETINT ( --> ) PRIM BRANCHTOEXIT ; INLINE-FOREVER

: PUSH-L1 ( --> ) A"
	push	l1_reg
	push	l1_end" ; INLINE-FOREVER

: PUSH-L2 ( --> ) A"
	push	l2_reg
	push	l2_end" ; INLINE-FOREVER

: PUSH-L3 ( --> ) A"
	push	l3_reg
	push	l3_end" ; INLINE-FOREVER

: POP-L1 ( --> ) A"
	pop	l1_end
	pop	l1_reg" ; INLINE-FOREVER

: POP-L2 ( --> ) A"
	pop	l2_end
	pop	l2_reg" ; INLINE-FOREVER

: POP-L3 ( --> ) A"
	pop	l3_end
	pop	l3_reg" ; INLINE-FOREVER

: ?BIT-IS-CLEAR ( b1bit b2port --> )
  (UNTIL-BIT-SET)
A"
	rjmp	sys_@1
	mov	temp0l, ff_reg
	rjmp	sys_@2
sys_@1:
	mov	temp0l, zero_reg
sys_@2:
" CW>S ; INLINE-FOREVER

: (SWITCH) ( b --> ) CS>W 

A"
	ldi	temp1l, 2
	mul	temp1l, temp0l
	add	ZL, r0
	adc	ZH, r1
	ijmp
"
; INLINE-FOREVER
