	.nolist
	.include	"m16def.inc"
	.include	"avrforth.inc"
	.list
	.org	0
	jmp	sys_reset
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
sys_reset:
	ldi	temp, low(1119)
	out	SPL, temp
	ldi	temp, high(1119)
	out	SPH, temp
	ldi	YL, low(224)
	ldi	YH, high(224)
	clr	zero_reg
	ldi	temp, 1
	mov	one_reg, temp
	ldi	temp, 2
	mov	two_reg, temp
	ldi	temp, $ff
	mov	ff_reg, temp
	call	U_STACK_AND_MEMORY_INIT
	call	U_INIT_ALLOCATE
	call	U_MAIN
sys_forever:
	rjmp	sys_forever
sys_bad_int:
	jmp	sys_reset
U_MAIN:
	call	U_T__underALLOCATE
	call	U_T__underARITHM
	call	U_T__underBITS
	call	U_T__underCOMPARE
	ret
U_T__underCOMPARE:
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_5
  	ldi	temp0l, TRUE
  	rjmp	sys_6
sys_5:
	ldi	temp0l, FALSE
sys_6:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cpi	temp0l, low(10)
	brne	sys_7
  	ldi	temp0l, TRUE
  	rjmp	sys_8
sys_7:
	ldi	temp0l, FALSE
sys_8:
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_9
  	ldi	temp0l, TRUE
  	rjmp	sys_10
sys_9:
	ldi	temp0l, FALSE
sys_10:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cp	temp0l, zero_reg
	brne	sys_11
  	ldi	temp0l, TRUE
  	rjmp	sys_12
sys_11:
	ldi	temp0l, FALSE
sys_12:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cpi	temp0l, 1		; Compare top of stack with 1
	brne	sys_13
  	ldi	temp0l, TRUE
  	rjmp	sys_14
sys_13:
	ldi	temp0l, FALSE
sys_14:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cpi	temp0l, 2		; Compare top of stack with 2
	brne	sys_15
  	ldi	temp0l, TRUE
  	rjmp	sys_16
sys_15:
	ldi	temp0l, FALSE
sys_16:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cpi	temp0l, 255		; Compare top of stack with 255
	brne	sys_17
  	ldi	temp0l, TRUE
  	rjmp	sys_18
sys_17:
	ldi	temp0l, FALSE
sys_18:
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_19
  	ldi	temp0l, TRUE
  	rjmp	sys_20
sys_19:
	ldi	temp0l, FALSE
sys_20:
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_21
  	ldi	temp0l, TRUE
  	rjmp	sys_22
sys_21:
	ldi	temp0l, FALSE
sys_22:
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_23
  	ldi	temp0l, TRUE
  	rjmp	sys_24
sys_23:
	ldi	temp0l, FALSE
sys_24:
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_25
  	ldi	temp0l, TRUE
  	rjmp	sys_26
sys_25:
	ldi	temp0l, FALSE
sys_26:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	templ, zero_reg
	brpl	sys_27
	ldi	templ, TRUE
	rjmp	sys_28
sys_27:
	ldi	templ, FALSE
sys_28:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, low(10)		; Substract 10 from top of stack
	cp	templ, zero_reg
	brpl	sys_29
	ldi	templ, TRUE
	rjmp	sys_30
sys_29:
	ldi	templ, FALSE
sys_30:
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	templ, zero_reg
	brpl	sys_31
	ldi	templ, TRUE
	rjmp	sys_32
sys_31:
	ldi	templ, FALSE
sys_32:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Substract 0, do nothing
	cp	templ, zero_reg
	brpl	sys_33
	ldi	templ, TRUE
	rjmp	sys_34
sys_33:
	ldi	templ, FALSE
sys_34:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	dec	temp0l			; Decrement top of stack
	cp	templ, zero_reg
	brpl	sys_35
	ldi	templ, TRUE
	rjmp	sys_36
sys_35:
	ldi	templ, FALSE
sys_36:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	sub	temp0l, two_reg		; Substract 2 from top of stack
	cp	templ, zero_reg
	brpl	sys_37
	ldi	templ, TRUE
	rjmp	sys_38
sys_37:
	ldi	templ, FALSE
sys_38:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, 255		; Sub 255 from temp0l
	cp	templ, zero_reg
	brpl	sys_39
	ldi	templ, TRUE
	rjmp	sys_40
sys_39:
	ldi	templ, FALSE
sys_40:
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	templ, zero_reg
	brpl	sys_41
	ldi	templ, TRUE
	rjmp	sys_42
sys_41:
	ldi	templ, FALSE
sys_42:
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	templ, zero_reg
	brpl	sys_43
	ldi	templ, TRUE
	rjmp	sys_44
sys_43:
	ldi	templ, FALSE
sys_44:
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	templ, zero_reg
	brpl	sys_45
	ldi	templ, TRUE
	rjmp	sys_46
sys_45:
	ldi	templ, FALSE
sys_46:
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	templ, zero_reg
	brpl	sys_47
	ldi	templ, TRUE
	rjmp	sys_48
sys_47:
	ldi	templ, FALSE
sys_48:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	zero_reg, templ
	brge	sys_49
	ldi	templ, TRUE
	rjmp	sys_50
sys_49:
	ldi	templ, FALSE
sys_50:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, low(10)		; Substract 10 from top of stack
	cp	zero_reg, templ
	brge	sys_51
	ldi	templ, TRUE
	rjmp	sys_52
sys_51:
	ldi	templ, FALSE
sys_52:
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	zero_reg, templ
	brge	sys_53
	ldi	templ, TRUE
	rjmp	sys_54
sys_53:
	ldi	templ, FALSE
sys_54:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Substract 0, do nothing
	cp	zero_reg, templ
	brge	sys_55
	ldi	templ, TRUE
	rjmp	sys_56
sys_55:
	ldi	templ, FALSE
sys_56:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	dec	temp0l			; Decrement top of stack
	cp	zero_reg, templ
	brge	sys_57
	ldi	templ, TRUE
	rjmp	sys_58
sys_57:
	ldi	templ, FALSE
sys_58:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	sub	temp0l, two_reg		; Substract 2 from top of stack
	cp	zero_reg, templ
	brge	sys_59
	ldi	templ, TRUE
	rjmp	sys_60
sys_59:
	ldi	templ, FALSE
sys_60:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, 255		; Sub 255 from temp0l
	cp	zero_reg, templ
	brge	sys_61
	ldi	templ, TRUE
	rjmp	sys_62
sys_61:
	ldi	templ, FALSE
sys_62:
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	zero_reg, templ
	brge	sys_63
	ldi	templ, TRUE
	rjmp	sys_64
sys_63:
	ldi	templ, FALSE
sys_64:
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	zero_reg, templ
	brge	sys_65
	ldi	templ, TRUE
	rjmp	sys_66
sys_65:
	ldi	templ, FALSE
sys_66:
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	zero_reg, templ
	brge	sys_67
	ldi	templ, TRUE
	rjmp	sys_68
sys_67:
	ldi	templ, FALSE
sys_68:
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	cp	zero_reg, templ
	brge	sys_69
	ldi	templ, TRUE
	rjmp	sys_70
sys_69:
	ldi	templ, FALSE
sys_70:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_71
  	ldi	temp0l, TRUE
  	rjmp	sys_72
sys_71:
	ldi	temp0l, FALSE
sys_72:
	com	temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cpi	temp0l, low(10)
	brne	sys_73
  	ldi	temp0l, TRUE
  	rjmp	sys_74
sys_73:
	ldi	temp0l, FALSE
sys_74:
	com	temp0l
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_75
  	ldi	temp0l, TRUE
  	rjmp	sys_76
sys_75:
	ldi	temp0l, FALSE
sys_76:
	com	temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cp	temp0l, zero_reg
	brne	sys_77
  	ldi	temp0l, TRUE
  	rjmp	sys_78
sys_77:
	ldi	temp0l, FALSE
sys_78:
	com	temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cpi	temp0l, 1		; Compare top of stack with 1
	brne	sys_79
  	ldi	temp0l, TRUE
  	rjmp	sys_80
sys_79:
	ldi	temp0l, FALSE
sys_80:
	com	temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cpi	temp0l, 2		; Compare top of stack with 2
	brne	sys_81
  	ldi	temp0l, TRUE
  	rjmp	sys_82
sys_81:
	ldi	temp0l, FALSE
sys_82:
	com	temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	cpi	temp0l, 255		; Compare top of stack with 255
	brne	sys_83
  	ldi	temp0l, TRUE
  	rjmp	sys_84
sys_83:
	ldi	temp0l, FALSE
sys_84:
	com	temp0l
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_85
  	ldi	temp0l, TRUE
  	rjmp	sys_86
sys_85:
	ldi	temp0l, FALSE
sys_86:
	com	temp0l
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_87
  	ldi	temp0l, TRUE
  	rjmp	sys_88
sys_87:
	ldi	temp0l, FALSE
sys_88:
	com	temp0l
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_89
  	ldi	temp0l, TRUE
  	rjmp	sys_90
sys_89:
	ldi	temp0l, FALSE
sys_90:
	com	temp0l
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack
	brne	sys_91
  	ldi	temp0l, TRUE
  	rjmp	sys_92
sys_91:
	ldi	temp0l, FALSE
sys_92:
	com	temp0l
	sts	228, temp0l
	ret
U_T__underBITS:
	ldi	temp0l, low(3)
	sts	226, temp0l
	ldi	temp0l, low(21)
	sts	227, temp0l
	lds	temp0l, 226		; Load byte from 226
	in	temp1l, 21		; Load i/o reg 21 to temp1l
	mov	temp2l, one_reg
sbi_102:	lsl	temp2l
	dec	temp0l
	brne	sbi_102			; Loop until shift count <> 0
	or	temp2l, temp1l		; Set bit
	out	21, temp2l		; Out r0 to i/o reg 21
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
; SETBIT	1	R0
	.error	Code generation word (SETBIT:R:0::) not found
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
; SETBIT	1	R0
	.error	Code generation word (SETBIT:R:0::) not found
	sbi	21, 0			; Set bit 0 of i/o reg 21
	sbi	21, 1			; Set bit 1 of i/o reg 21
	sbi	21, 2			; Set bit 2 of i/o reg 21
	sbi	21, 3			; Set bit 3 of i/o reg 21
	sbi	21, 4			; Set bit 4 of i/o reg 21
	sbi	21, 5			; Set bit 5 of i/o reg 21
	sbi	21, 6			; Set bit 6 of i/o reg 21
	sbi	21, 7			; Set bit 7 of i/o reg 21
	lds	temp0l, 226		; Load byte from 226
	in	temp1l, 21		; Load i/o reg 21 to temp1l
	mov	temp2l, one_reg
sbi_103:	lsl	temp2l
	dec	temp0l
	brne	sbi_103			; Loop until shift count <> 0
	com	temp2l			; Inverse temp2l
	and	temp2l, temp1l		; Clear bit
	out	21, temp2l		; Out r0 to i/o reg 21
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
; CLRBIT	1	R0
	.error	Code generation word (CLRBIT:R:0::) not found
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
; CLRBIT	1	R0
	.error	Code generation word (CLRBIT:R:0::) not found
	cbi	21, 0			; Clear bit 0 of i/o reg 21
	cbi	21, 1			; Clear bit 1 of i/o reg 21
	cbi	21, 2			; Clear bit 2 of i/o reg 21
	cbi	21, 3			; Clear bit 3 of i/o reg 21
	cbi	21, 4			; Clear bit 4 of i/o reg 21
	cbi	21, 5			; Clear bit 5 of i/o reg 21
	cbi	21, 6			; Clear bit 6 of i/o reg 21
	cbi	21, 7			; Clear bit 7 of i/o reg 21
	ret
U_T__underARITHM:
	ldi	temp0l, low(10)
	sts	226, temp0l
	sts	227, two_reg
	; test >>
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_104			; jump to done
shr_105:
	lsr	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_105			; if not zero do shift again
shr_104:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_106			; jump to done
shr_107:
	lsr	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_107			; if not zero do shift again
shr_106:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Value to shift in temp0l
	ldi	temp1l,low(10)		; Load shift counter to temp1l
	cp	temp1l, zero_reg	; if shift counter is 0
	breq	shr_108			; jump to done
shr_109:
	lsr	temp0l			; shift right
	dec	temp1l			; decrement shift counter
	brne	shr_109			; if not zero do shift again
shr_108:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Shift counter is 0, do nothing
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	lsr	temp0l			; Value to shift in temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	lsr	temp0l			; Value to shift in temp0l
	lsr	temp0l			; and shift again
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	ldi	temp0l, 0		; if shift counter is 255 then 
					; result is 0
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_110			; jump to done
shr_111:
	lsr	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_111			; if not zero do shift again
shr_110:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_112			; jump to done
shr_113:
	lsr	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_113			; if not zero do shift again
shr_112:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_114			; jump to done
shr_115:
	lsr	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_115			; if not zero do shift again
shr_114:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_116			; jump to done
shr_117:
	lsr	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_117			; if not zero do shift again
shr_116:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	; test <<
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_118			; jump to done
shr_119:
	lsl	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_119			; if not zero do shift again
shr_118:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_120			; jump to done
shr_121:
	lsl	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_121			; if not zero do shift again
shr_120:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Value to shift in temp0l
	ldi	temp1l,low(10)		; Load shift counter to temp1l
	cp	temp1l, zero_reg	; if shift counter is 0
	breq	shr_122			; jump to done
shr_123:
	lsl	temp0l			; shift right
	dec	temp1l			; decrement shift counter
	brne	shr_123			; if not zero do shift again
shr_122:
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Shift counter is 0, do nothing
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	lsl	temp0l			; Value to shift in temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	lsl	temp0l			; Value to shift in temp0l
	lsl	temp0l			; and shift again
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	ldi	temp0l, 0		; if shift counter is 255 then 
					; result is 0
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_124			; jump to done
shr_125:
	lsl	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_125			; if not zero do shift again
shr_124:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_126			; jump to done
shr_127:
	lsl	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_127			; if not zero do shift again
shr_126:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_128			; jump to done
shr_129:
	lsl	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_129			; if not zero do shift again
shr_128:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Load value to shift to temp1l
	cp	temp0l, zero_reg	; if shift counter is 0
	breq	shr_130			; jump to done
shr_131:
	lsl	temp1l			; shift right
	dec	temp0l			; decrement shift counter
	brne	shr_131			; if not zero do shift again
shr_130:
	mov	temp0l, temp1l		; copy shifted value to work reg
	sts	228, temp0l
	; test BV
	sts	228, two_reg
	ldi	temp0l, low(4)
	sts	228, temp0l
	ldi	temp0l, low(8)
	sts	228, temp0l
	; test +
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	add	temp0l, temp1l
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	add	temp0l, temp1l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, low(-(10))	; Add imm value to temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Do nothing
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	inc	temp0l			; increment top of stack
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, low(-(2))	; add 2 to temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, low(-(255))	; add 255 to temp0l
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	add	temp0l, temp1l
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	add	temp0l, temp1l
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	add	temp0l, temp1l
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	add	temp0l, temp1l
	sts	228, temp0l
	; test 1+
	lds	temp0l, 226		; Load byte from 226
	inc	temp0l			; increment top of stack
	sts	228, temp0l
	ldi	temp0l, low(11)
	sts	228, temp0l
	sts	228, two_reg
	; test -
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, low(10)		; Substract 10 from top of stack
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Substract 0, do nothing
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	dec	temp0l			; Decrement top of stack
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	sub	temp0l, two_reg		; Substract 2 from top of stack
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	subi	temp0l, 255		; Sub 255 from temp0l
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+
	sub	temp0l, temp1l
	sts	228, temp0l
	; test *
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Value under top of stack to temp1l
	muls	temp0l, temp1l		; Top of stack in temp0l
	mov	temp0l, r0		; Move result of muls to temp0l
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Value under top of stack to temp1l
	muls	temp0l, temp1l		; Top of stack in temp0l
	mov	temp0l, r0		; Move result of muls to temp0l
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	ldi	temp1l, low(10)
	muls	temp0l, temp1l
	mov	temp0l, r0
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	mov	temp0l, zero_reg	; Mul to zero
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
					; Mul to one
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	add	temp0l, temp0l		; Mul to two
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	ldi	temp1l, 255		; Mul to 255
	muls	temp0l, temp1l
	mov	temp0l, r0		; Result from r0 to temp0l
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Value under top of stack to temp1l
	muls	temp0l, temp1l		; Top of stack in temp0l
	mov	temp0l, r0		; Move result of muls to temp0l
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Value under top of stack to temp1l
	muls	temp0l, temp1l		; Top of stack in temp0l
	mov	temp0l, r0		; Move result of muls to temp0l
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Value under top of stack to temp1l
	muls	temp0l, temp1l		; Top of stack in temp0l
	mov	temp0l, r0		; Move result of muls to temp0l
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	ld	temp1l, Y+		; Value under top of stack to temp1l
	muls	temp0l, temp1l		; Top of stack in temp0l
	mov	temp0l, r0		; Move result of muls to temp0l
	sts	228, temp0l
	; test /
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(10) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(0) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(1) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(2) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(255) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	ld	temp1l, Y+
	sts	228, temp0l
	; test MOD
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(10) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(0) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(1) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(2) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(255) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	ldi	temp0l, low(0) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	ldi	temp0l, low(1) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	ldi	temp0l, low(2) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	ldi	temp0l, low(255) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	lds	temp0l, 227		; Load byte from 227
	st	-Y, temp0l		; Push temp to stack
	call	U__slashMOD
	adiw	sp, 1
	ld	temp0l, Y+
	sts	228, temp0l
	; test 2*
	lds	temp0l, 226		; Load byte from 226
	lsl	temp0l			; Value to shift in temp0l
	sts	228, temp0l
	ldi	temp0l, low(20)
	sts	228, temp0l
	sts	228, two_reg
	; test 2/
	lds	temp0l, 226		; Load byte from 226
	lsr	temp0l			; Value to shift in temp0l
	sts	228, temp0l
	ldi	temp0l, low(5)
	sts	228, temp0l
	sts	228, zero_reg
	; test NEGATE
	lds	temp0l, 226		; Load byte from 226
	neg	temp0l			; Negate top of stack
	sts	228, temp0l
	ldi	temp0l, low(-(10))	; Negate 10
	sts	228, temp0l
	mov	temp0l, zero_reg	; Negate zero
	sts	228, temp0l
	ldi	temp0l, low(-1)		; Negate one
	sts	228, temp0l
	ldi	temp0l, low(-2)		; Negate two
	sts	228, temp0l
	ldi	temp0l, low(-255)	; Negate 255
	sts	228, temp0l
	; test ABS
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	call	U_ABS
	ld	temp0l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	neg	temp0l			; Negate top of stack
	st	-Y, temp0l		; Push temp to stack
	call	U_ABS
	ld	temp0l, Y+
	sts	228, temp0l
	; test _ABS
	lds	temp0l, 226		; Load byte from 226
	st	-Y, temp0l		; Push temp to stack
	call	U___underABS
	ld	temp0l, Y+
	sts	228, temp0l
	lds	temp0l, 226		; Load byte from 226
	neg	temp0l			; Negate top of stack
	st	-Y, temp0l		; Push temp to stack
	call	U___underABS
	ld	temp0l, Y+
	sts	228, temp0l
	ret
U___underABS:
	ld	temp0l, Y+		; Pop from stack to temp reg
	cp	templ, zero_reg
	brpl	sys_93
	ldi	templ, TRUE
	rjmp	sys_94
sys_93:
	ldi	templ, FALSE
sys_94:
	cp	temp0l, zero_reg
	breq	B_4_0
	ld	temp0l, Y+		; Load top of stack to temp0l
	neg	temp0l			; Negate temp0l
	st	-Y, temp0l		; Push temp to stack
B_4_0:
	ret
U_T__underALLOCATE:
	ldi	temp1l, low(10) 	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U_GET_MEM
	ld	temp0h, Y+
	ld	temp0l, Y+
	sts	229, temp0h
	sts	229 + 1, temp0l
	ldi	temp0l, low(10) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_GET_MEM
	ld	temp0h, Y+
	ld	temp0l, Y+
	sts	231, temp0h
	sts	231 + 1, temp0l
	ldi	temp0l, low(20) 	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_FREE_MEM
	ret
U_FREE_MEM:
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_95
	ldi	templ, $0
	rjmp	sys_96
sys_95:	ldi	templ, $ff
sys_96:
	st	-Y, temp0l		; Push temp to stack
	lds	temp0h, 224
	lds	temp0l, 224 + 1
	ld	temp1h, Y+		; Pop high part from stack
	ld	temp1l, Y+		; Pop low part from stack
	sub	temp0l, temp1l
	sbc	temp0h, temp1h
	sts	224, temp0h
	sts	224 + 1, temp0l
	ret
U_GET_MEM:
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_97
	ldi	templ, $0
	rjmp	sys_98
sys_97:	ldi	templ, $ff
sys_98:
	st	-Y, temp0l		; Push temp to stack
	lds	temp0h, 224
	lds	temp0l, 224 + 1
	movw	temp1h:temp1l, temp0h:temp0l
	ld	temp2h, Y+		; Pop high part from stack
	ld	temp2l, Y+		; Pop low part from stack
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	add	temp0l, temp2l
	adc	temp0h, temp2h
	sts	224, temp0h
	sts	224 + 1, temp0l
	ret
U_INIT_ALLOCATE:
	ldi	temp0l, low(sys_vars_end)
	ldi	temp0h, high(sys_vars_end)
	sts	224, temp0h
	sts	224 + 1, temp0l
	ret
U_ABS:
	ld	temp1l, Y+		; Pop from stack to temp reg
	cp	temp1l, zero_reg
	brmi	abs_99
	mov	templ, temp1l
	rjmp	abs_100
abs_99:	mov	templ, zero_reg
	sub	templ, temp1l
abs_100:
	st	-Y, temp0l		; Push temp to stack
	ret
U__slashMOD:
	ld	temp1l, Y+
	ld	temp0l, Y+
	call	SYS__lpar_slashMOD_rpar
	st	-Y, temp1l		; Push temp to stack
	st	-Y, temp0l		; Push temp to stack
	ret
U_STACK_AND_MEMORY_INIT:
	ldi	ZH, high(sys_vars_end - sys_vars_start)
	ldi	ZL, low(sys_vars_end - sys_vars_start)
	ldi	XH, high(sys_vars_start)
	ldi	XL, low(sys_vars_start)
sys_101:
	st	X+, zero_reg			; Clear variables
	sbiw	ZH:ZL, 1
	brne	sys_101
	ret
SYS__lpar_slashMOD_rpar:
	
	mov	dv8s, temp1l
	mov	d8s,dd8s
	eor	d8s,dv8s
	sbrc	dv8s,7
	neg	dv8s
	sbrc	dd8s,7
	neg	dd8s
	sub	drem8s,drem8s
	ldi	dcnt8s,9
d8s_132:	rol	dd8s
	dec	dcnt8s
	brne	d8s_133
	sbrc	d8s,7
	neg	dres8s
	rjmp	d8s_134
d8s_133:	rol	drem8s
	sub	drem8s,dv8s
	brcc	d8s_135
	add	drem8s,dv8s
	clc
	rjmp	d8s_132
d8s_135:	sec
	rjmp	d8s_132
d8s_134:	mov	temp1l, drem8s
	ret
	.dseg
	.org	96
sys_vars_start:
sys_data_stack:
	.byte	128
U_DP:		; 224
	.byte	2
U_A:		; 226
	.byte	1
U_B:		; 227
	.byte	1
U_C:		; 228
	.byte	1
U_DA:		; 229
	.byte	2
U_DB:		; 231
	.byte	2
sys_vars_end:
