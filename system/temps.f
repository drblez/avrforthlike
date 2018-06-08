( Works with WORD temporary registers )

: S=W ( --> ) PRIM TOP_W0 ; INLINE-FOREVER

: S1=W ( --> ) PRIM TOP-ONE_W0 ; INLINE-FOREVER

: S2=W ( --> ) PRIM TOP-TWO_W0 ; INLINE-FOREVER

: S1=W-1 ( --> ) PRIM TOP-ONE_W1 ; INLINE-FOREVER

: S2=W-2 ( --> ) PRIM TOP-TWO_W2 ; INLINE-FOREVER

: S>W ( w --> ) PRIM POP_W0 ; INLINE-FOREVER

: S>W-1 ( w --> ) PRIM POP_W1 ; INLINE-FOREVER

: S>W-2 ( w --> ) PRIM POP_W2 ; INLINE-FOREVER

: W>S ( --> w ) PRIM PUSH_W0 ; INLINE-FOREVER

: W>S-1 ( --> w ) PRIM PUSH_W1 ; INLINE-FOREVER

: W>S-2 ( --> w ) PRIM PUSH_W2 ; INLINE-FOREVER

( Works with BYTE temporary registers )

: CS=W ( --> ) PRIM TOP_B0 ; INLINE-FOREVER

: CS1=W ( --> ) PRIM TOP-ONE_B0 ; INLINE-FOREVER

: CS2=W ( --> ) PRIM TOP-TWO_B0 ; INLINE-FOREVER

: CS1=W-1 ( --> ) PRIM TOP-ONE_B1 ; INLINE-FOREVER

: CS2=W-2 ( --> ) PRIM TOP-TWO_B2 ; INLINE-FOREVER

: CS>W ( b --> ) PRIM POP_B0 ; INLINE-FOREVER

: CS>W-1 ( b --> ) PRIM POP_B1 ; INLINE-FOREVER

: CS>W-2 ( b --> ) PRIM POP_B2 ; INLINE-FOREVER

: CW>S ( --> b ) PRIM PUSH_B0 ; INLINE-FOREVER

: CW>S-1 ( --> b ) PRIM PUSH_B1 ; INLINE-FOREVER

: CW>S-2 ( --> b ) PRIM PUSH_B2 ; INLINE-FOREVER

( Works with QUAD temporary registers )

: QS=W ( --> ) PRIM TOP_Q0 ; INLINE-FOREVER

: QS1=W ( --> ) PRIM TOP-ONE_Q0 ; INLINE-FOREVER

: QS2=W ( --> ) PRIM TOP-TWO_Q0 ; INLINE-FOREVER

: QS1=W-1 ( --> ) PRIM TOP-ONE_Q1 ; INLINE-FOREVER

: QS2=W-2 ( --> ) PRIM TOP-TWO_Q2 ; INLINE-FOREVER

: QS>W ( qq --> ) PRIM POP_Q0 ; INLINE-FOREVER

: QS>W-1 ( qq --> ) PRIM POP_Q1 ; INLINE-FOREVER

: QS>W-2 ( qq --> ) PRIM POP_Q2 ; INLINE-FOREVER

: QW>S ( --> qq ) PRIM PUSH_Q0 ; INLINE-FOREVER

: QW>S-1 ( --> qq ) PRIM PUSH_Q1 ; INLINE-FOREVER

: QW>S-2 ( --> qq ) PRIM PUSH_Q2 ; INLINE-FOREVER

( Some codegen words )

CG" 	ldi	temp%0l, low(%1) 	; Load imm to temp reg"		(IMM_B:RI:::)
CG" 	st	-Y, temp%0l		; Push temp to stack"		(PUSH_B:R:::)
CG" 	ld	temp%0l, Y+		; Pop from stack to temp reg"	(POP_B:R:::)
CG" 	ld	temp%0l, Y		; Get stack top value"		(TOP_B:R:::)

CG" 	ldi	temp%0l, low(%1)	; Load low part of double imm
	ldi	temp%0h, high(%1)	; Load high part of double imm"	(IMM_W:RI:::)
CG" 	st	-Y, temp%0l		; Push low part to stack
	st	-Y, temp%0h		; Push high part to stack"	(PUSH_W:R:::)
CG" 	ld	temp%0h, Y+		; Pop high part from stack
	ld	temp%0l, Y+		; Pop low part from stack"	(POP_W:R:::)
CG" 	ldd	temp%0l, Y + 1          ; Get low part from stack
	ld	temp%0h, Y		; Get high part from stack"	(TOP_W:R:::)
	
CG" 	ldi	temp%0q0, low(%1)
 	ldi	temp%0q1, high(%1)
 	ldi	temp%0q2, byte3(%1)
 	ldi	temp%0q3, byte4(%1)" (IMM_Q:RI:::)
CG" 	ldd	temp%0q0, Y + 3
	ldd	temp%0q1, Y + 2
	ldd	temp%0q2, Y + 1
	ld	temp%0q3, Y"		(TOP_Q:R:::)
CG" 	ld	temp%0q3, Y+
	ld	temp%0q2, Y+
	ld	temp%0q1, Y+
	ld	temp%0q0, Y+"		(POP_Q:R:::)
CG" 	st	-Y, temp%0q0
	st	-Y, temp%0q1
	st	-Y, temp%0q2
	st	-Y, temp%0q3"		(PUSH_Q:R:::)
CG" 	call	`(PUSH_Q:R:::)"		(PUSH_Q:R:::)NOINLINE

CG" 	push	r0			; Save all regs
	push	r1
	push	r2
	push	r3
	push	r4
	push	r5
	push	r6
	push	r7
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12
	push	r13
	push	r14
	push	r15
	push	r16
	push	r17
	push	r18
	push	r19
	push	r20
	push	r21
	push	r22
	push	r23
	push	r24
	push	r25
	push	r26
	push	r27
	push	r28
	push	r29
	ijmp" (PUSHALLREGS)

CG" 	pop	r29			; Restore of regs
	pop	r28
	pop	r27
	pop	r26
	pop	r25
	pop	r24
	pop	r23
	pop	r22
	pop	r21
	pop	r20
	pop	r19
	pop	r18
	pop	r17
	pop	r16
	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	r11
	pop	r10
	pop	r9
	pop	r8
	pop	r7
	pop	r6
	pop	r5
	pop	r4
	pop	r3
	pop	r2
	pop	r1
	pop	r0
	ijmp" (POPALLREGS)
	
CG" 	push	r0			; Start of interrupt word
	in	r0, SREG		; Save SREG
	push	ZH
	push	ZL
	ldi	ZL, low(%0_startint)	; Point of return from PUSHALLREGS
	ldi	ZH, high(%0_startint)
	jmp	`(PUSHALLREGS)`
%0_startint:" (STARTINT:I:::)

CG" 	ldi	ZL, low(%0_retint)	; Point of return from POPALLREGS
	ldi	ZH, high(%0_retint)
	jmp	`(POPALLREGS)`
%0_retint:
	pop	ZL
	pop	ZH
	out	SREG, r0		; Restore SREG
	pop	r0
	reti				; Return from interrupt" (RETINT:I:::)

CG" 	movw	temp0h:temp0l, temp%0h:temp%0l" (MOVTMPW:RR::0:)
CG" 	movw	temp%1h:temp%1l, temp0h:temp0l" (MOVTMPW:RR:0::)

CG" 	mov	temp0l, temp%0l" (MOVTMPB:RR::0:)
