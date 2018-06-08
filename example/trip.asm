	.nolist
	.include	"m16def.inc"
	.include	"avrforth.inc"
	.list
	.org	0
	jmp	sys_reset
	jmp	U_INT0_PROC
	jmp	U_INT1_PROC
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	sys_bad_int
	jmp	U_TIMER1COMPA_PROC
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
	call	U_SETUP_FORMAT
	call	U_CHAR_IN_OUT
	call	U_INIT_ALLOCATE
	call	U_INIT_LOCALS
	call	U_INIT_BEEPER
	call	U_I2CMASTER_INIT
	call	U_DS1307_INIT
	call	U_KEY_INIT
	call	U_INIT_LCD
	call	U_INIT_LCD_INOUT
	call	U_UART_INIT
	call	U_INIT
sys_forever:
	rjmp	sys_forever
sys_bad_int:
	jmp	sys_reset
U_INIT:
	ldi	temp0l, low(34)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16336)	; Load low part of double imm
	ldi	temp1h, high(16336)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ldi	temp0l, low(250)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	cbi	18, 7
	call	U_DELAY_MS
	cbi	18, 7
	ldi	temp0l, low(250)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp1l, low(1)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U_DELAY_SEC
	ldi	temp2l, low(124)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	call	U_TIMER0_INIT
	call	U_INT_INIT
	call	U_MAIN_LOOP
	ret
U_INT_INIT:
	in	temp0l, 17
	andi	temp0l, low(-4)
	out	17, temp0l
	ldi	temp0l, 15
	out	53, temp0l
	ldi	temp0l, 192
	out	59, temp0l
	ret
U_MAIN_LOOP:
	sts	342, zero_reg
	sts	343, zero_reg
	sts	344, zero_reg
	sts	344 + 1, zero_reg
	sts	346, zero_reg
	sts	346 + 1, zero_reg
	call	U_READ_TRIP_PARAMS_FROM_EEPROM
	sei
B_65_0:
	ldi	ZL, low(274)		; Load address (274) to Z register
	ldi	ZH, high(274)
	icall				; Indirect call (274)
	call	U_MAIN_LOOP_SWITCH
	rjmp	B_65_0
	ret
U_MAIN_LOOP_SWITCH:
	ldi	ZL, low(U_MAIN_LOOP_SWITCH_switch)
	ldi	ZH, high(U_MAIN_LOOP_SWITCH_switch)
	ld	temp0l, Y+		; Pop from stack to temp reg
	ldi	temp1l, 2
	mul	temp1l, temp0l
	add	ZL, r0
	adc	ZH, r1
	ijmp
U_MAIN_LOOP_SWITCH_switch:
	jmp	U_NOTHING
	jmp	U_INC_DISP_MODE
	jmp	U_DEC_DISP_MODE
	jmp	U_NOTHING
	jmp	U_DO_KEY_4
	ret
U_DO_KEY_4:
	lds	temp0l, 379		; Load byte from 379
	st	-Y, temp0l		; Push temp to stack
	call	U_SWITCH_KEY_4
	ret
U_SWITCH_KEY_4:
	ldi	ZL, low(U_SWITCH_KEY_4_switch)
	ldi	ZH, high(U_SWITCH_KEY_4_switch)
	ld	temp0l, Y+		; Pop from stack to temp reg
	ldi	temp1l, 2
	mul	temp1l, temp0l
	add	ZL, r0
	adc	ZH, r1
	ijmp
U_SWITCH_KEY_4_switch:
	jmp	U_DO_SET_TIME
	jmp	U_DO_START_STOP
	jmp	U_DO_START_STOP
	jmp	U_DO_START_STOP
	jmp	U_DO_START_STOP
	jmp	U_DO_START_STOP
	jmp	U_DO_START_STOP
	jmp	U_DO_START_STOP
	jmp	U_DO_START_STOP
	jmp	U_NOTHING
	jmp	U_DO_RESET_DATA
	jmp	U_NOTHING
	jmp	U_NOTHING
	jmp	U_NOTHING
	jmp	U_NOTHING
	ret
U_DO_RESET_DATA:
	ret
U_DO_START_STOP:
	ldi	temp0l, low(255)
	sts	342, temp0l
	ldi	temp0l, low(124)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	lds	temp0l, 360		; Load byte from 360
	cp	temp0l, zero_reg
	breq	B_63_0
	sts	360, zero_reg
	ldi	temp0l, low(9)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16326)	; Load low part of double imm
	ldi	temp1h, high(16326)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	rjmp	B_64_0
B_63_0:
	ldi	temp0l, low(255)
	sts	360, temp0l
	ldi	temp0l, low(10)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16316)	; Load low part of double imm
	ldi	temp1h, high(16316)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
B_64_0:
	ldi	temp0l, low(255)
	sts	343, temp0l
	sts	342, zero_reg
	ret
U_DO_SET_TIME:
	call	U_SET_TIME_DLG
	ret
U_SET_TIME_DLG:
	ldi	temp0l, low(2)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_LOCALS
	ldi	temp1l, low(0)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U_1_excl
	ldi	temp2l, low(255)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	lds	temp0l, 342		; Load byte from 342
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(124)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	call	U_GET_TIME
	ldi	temp0l, low(13)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16156)	; Load low part of double imm
	ldi	temp1h, high(16156)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_0_excl
	call	U_PUT_TIME_TO_SCR
	ldi	ZL, low(278)		; Load address (278) to Z register
	ldi	ZH, high(278)
	icall				; Indirect call (278)
B_61_0:
	call	U_1_at
	ld	temp0l, Y+
	cp	temp0l, zero_reg
	breq	B_62_0
	ldi	temp0l, low(1)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(0)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	ZL, low(276)		; Load address (276) to Z register
	ldi	ZH, high(276)
	icall				; Indirect call (276)
	call	U_PUT_TIME_TO_SCR
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_1_excl
B_62_0:
	ldi	temp1l, low(1)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U_0_at
	ld	temp1l, Y+
	ldi	temp0l, low(3)
	muls	temp0l, temp1l
	mov	temp0l, r0
	st	-Y, temp0l		; Push temp to stack
	ldi	ZL, low(276)		; Load address (276) to Z register
	ldi	ZH, high(276)
	icall				; Indirect call (276)
	call	U_GET_KEY
	ld	temp0l, Y		; Get stack top value
	st	-Y, temp0l		; Push temp to stack
	call	U_SET_TIME_DLG_SWITCH
	ld	temp0l, Y+
	cpi	temp0l, low(4)
	brne	sys_66
  	ldi	temp0l, TRUE
  	rjmp	sys_67
sys_66:
	ldi	temp0l, FALSE
sys_67:
	cp	temp0l, zero_reg
	breq	B_61_0
	ldi	ZL, low(280)		; Load address (280) to Z register
	ldi	ZH, high(280)
	icall				; Indirect call (280)
	ldi	temp0l, low(255)
	sts	343, temp0l
	call	U_SET_TIME
	sts	342, zero_reg
	call	U_DROP_LOCALS
	ret
U_SET_TIME_DLG_SWITCH:
	ldi	ZL, low(U_SET_TIME_DLG_SWITCH_switch)
	ldi	ZH, high(U_SET_TIME_DLG_SWITCH_switch)
	ld	temp0l, Y+		; Pop from stack to temp reg
	ldi	temp1l, 2
	mul	temp1l, temp0l
	add	ZL, r0
	adc	ZH, r1
	ijmp
U_SET_TIME_DLG_SWITCH_switch:
	jmp	U_NOTHING
	jmp	U_INC_TIME_POS
	jmp	U_DEC_TIME_POS
	jmp	U_SET_TIME_POS
	jmp	U_NOTHING
	ret
U_SET_TIME_POS:
	call	U_0_at
	ld	temp0l, Y+		; load top of stack to work reg
	inc	temp0l			; increment top of stack
	st	-Y, temp0l		; Push temp to stack
	call	U_0_excl
	call	U_0_at
	ld	temp0l, Y+
	subi	temp0l, low(5)
	cp	zero_reg, templ
	brge	sys_68
	ldi	templ, TRUE
	rjmp	sys_69
sys_68:
	ldi	templ, FALSE
sys_69:
	cp	temp0l, zero_reg
	breq	B_60_0
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_0_excl
B_60_0:
	ret
U_DEC_TIME_POS:
	ldi	temp1l, low(334)	; Load low part of double imm
	ldi	temp1h, high(334)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	call	U_0_at
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_70
	ldi	templ, $0
	rjmp	sys_71
sys_70:	ldi	templ, $ff
sys_71:
	st	-Y, temp0l		; Push temp to stack
	ld	temp0h, Y+
	ld	temp0l, Y+
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ld	temp0l, Y		; Get stack top value
	st	-Y, temp0l		; Push temp to stack
	ld	ZH, Y+			; Load byte from top of stack
	ld	ZL, Y+
	ld	temp0l, Z
	st	-Y, temp0l		; Push temp to stack
	call	U_BCD_INC
	ld	temp0l, Y+		; Pop from stack to temp reg
	ld	temp1l, Y+		; Pop from stack to temp reg
	ld	temp2l, Y+		; Pop from stack to temp reg
	st	-Y, temp0l		; Push temp to stack
	st	-Y, temp2l		; Push temp to stack
	st	-Y, temp1l		; Push temp to stack
	ld	ZH, Y+
	ld	ZL, Y+
	ld	temp0l, Y+
	st	Z, temp0l
	ldi	temp0l, low(255)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_1_excl
	ret
U_INC_TIME_POS:
	ldi	temp1l, low(334)	; Load low part of double imm
	ldi	temp1h, high(334)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	call	U_0_at
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_72
	ldi	templ, $0
	rjmp	sys_73
sys_72:	ldi	templ, $ff
sys_73:
	st	-Y, temp0l		; Push temp to stack
	ld	temp0h, Y+
	ld	temp0l, Y+
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ld	temp0l, Y		; Get stack top value
	st	-Y, temp0l		; Push temp to stack
	ld	ZH, Y+			; Load byte from top of stack
	ld	ZL, Y+
	ld	temp0l, Z
	st	-Y, temp0l		; Push temp to stack
	call	U_BCD_INC
	ld	temp0l, Y+		; Pop from stack to temp reg
	ld	temp1l, Y+		; Pop from stack to temp reg
	ld	temp2l, Y+		; Pop from stack to temp reg
	st	-Y, temp0l		; Push temp to stack
	st	-Y, temp2l		; Push temp to stack
	st	-Y, temp1l		; Push temp to stack
	ld	ZH, Y+
	ld	ZL, Y+
	ld	temp0l, Y+
	st	Z, temp0l
	ldi	temp0l, low(255)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_1_excl
	ret
U_DEC_DISP_MODE:
	lds	temp0l, 379		; Load byte from 379
	cp	temp0l, zero_reg
	brne	sys_74
  	ldi	temp0l, TRUE
  	rjmp	sys_75
sys_74:
	ldi	temp0l, FALSE
sys_75:
	cp	temp0l, zero_reg
	breq	B_58_0
	ldi	temp0l, low(15)
	sts	379, temp0l
	rjmp	B_59_0
B_58_0:
	lds	temp0l, 379		; Load byte from 379
	dec	temp0l			; Decrement top of stack
	sts	379, temp0l
B_59_0:
	ret
U_INC_DISP_MODE:
	lds	temp0l, 379		; Load byte from 379
	cpi	temp0l, low(15)
	brne	sys_76
  	ldi	temp0l, TRUE
  	rjmp	sys_77
sys_76:
	ldi	temp0l, FALSE
sys_77:
	cp	temp0l, zero_reg
	breq	B_56_0
	sts	379, zero_reg
	rjmp	B_57_0
B_56_0:
	lds	temp0l, 379		; Load byte from 379
	inc	temp0l			; increment top of stack
	sts	379, temp0l
B_57_0:
	ret
U_TIMER1COMPA_PROC:
	push	r0			; Start of interrupt word
	in	r0, SREG		; Save SREG
	push	ZH
	push	ZL
	ldi	ZL, low(U_TIMER1COMPA_PROC_startint)	; Point of return from PUSHALLREGS
	ldi	ZH, high(U_TIMER1COMPA_PROC_startint)
	jmp	SYS__lparPUSHALLREGS_rpar
U_TIMER1COMPA_PROC_startint:
	ldi	temp0l, low(0)	; Load low part of double imm
	ldi	temp0h, high(0)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ld	temp0l, Y+
	out	45, temp0l
	ld	temp0l, Y+
	out	44, temp0l
	lds	temp0h, 346
	lds	temp0l, 346 + 1
	sts	348, temp0h
	sts	348 + 1, temp0l
	sts	346, zero_reg
	sts	346 + 1, zero_reg
	lds	temp0h, 344
	lds	temp0l, 344 + 1
	sts	350, temp0h
	sts	350 + 1, temp0l
	sts	344, zero_reg
	sts	344 + 1, zero_reg
	lds	temp0q3, 373
	lds	temp0q2, 373 + 1
	lds	temp0q1, 373 + 2
	lds	temp0q0, 373 + 3
	sts	352, temp0q3
	sts	352 + 1, temp0q2
	sts	352 + 2, temp0q1
	sts	352 + 3, temp0q0
	lds	temp0q3, 369
	lds	temp0q2, 369 + 1
	lds	temp0q1, 369 + 2
	lds	temp0q0, 369 + 3
	sts	356, temp0q3
	sts	356 + 1, temp0q2
	sts	356 + 2, temp0q1
	sts	356 + 3, temp0q0
	lds	temp0h, 348
	lds	temp0l, 348 + 1
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ldi	temp0l, low(60)	; Load low part of double imm
	ldi	temp0h, high(60)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	call	U_D_star
	ld	temp0h, Y+
	ld	temp0l, Y+
	sts	348, temp0h
	sts	348 + 1, temp0l
	lds	temp0l, 360		; Load byte from 360
	cp	temp0l, zero_reg
	breq	B_52_0
	call	U_SET_TRIP_PARAMS
B_52_0:
	call	U_WRITE_TRIP_PARAMS_TO_EEPROM
	lds	temp0l, 342		; Load byte from 342
	cp	temp0l, zero_reg
	breq	B_53_0
	rjmp	U_TIMER1COMPA_PROC_exit
B_53_0:
	lds	temp0l, 343		; Load byte from 343
	cp	temp0l, zero_reg
	breq	B_54_0
	ldi	temp0l, low(124)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	sts	343, zero_reg
	rjmp	B_55_0
B_54_0:
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(0)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	ZL, low(276)		; Load address (276) to Z register
	ldi	ZH, high(276)
	icall				; Indirect call (276)
B_55_0:
	lds	temp0l, 379		; Load byte from 379
	st	-Y, temp0l		; Push temp to stack
	call	U_DO_DISP
U_TIMER1COMPA_PROC_exit:
	ldi	ZL, low(U_TIMER1COMPA_PROC_retint)	; Point of return from POPALLREGS
	ldi	ZH, high(U_TIMER1COMPA_PROC_retint)
	jmp	SYS__lparPOPALLREGS_rpar
U_TIMER1COMPA_PROC_retint:
	pop	ZL
	pop	ZH
	out	SREG, r0		; Restore SREG
	pop	r0
	reti				; Return from interrupt
U_SET_TRIP_PARAMS:
	lds	temp0h, 348
	lds	temp0l, 348 + 1
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	lds	temp0h, 377
	lds	temp0l, 377 + 1
	ld	temp1h,	Y+
	ld	temp1l, Y+
	sub	temp1l, temp0l
	sbc	temp1h, temp0h
	movw	temp0h:temp0l, temp1h:temp1l
	cp	zero_reg, templ
	cpc	zero_reg, temph
	brge	sys_78
	ldi	templ, TRUE
	rjmp	sys_79
sys_78:
	ldi	templ, FALSE
sys_79:
	cp	temp0l, zero_reg
	breq	B_50_0
	lds	temp0h, 348
	lds	temp0l, 348 + 1
	sts	377, temp0h
	sts	377 + 1, temp0l
B_50_0:
	lds	temp0h, 348
	lds	temp0l, 348 + 1
	subi	temp0l, low(499)
	sbci	temp0h, high(499)
	cp	zero_reg, templ
	cpc	zero_reg, temph
	brge	sys_80
	ldi	templ, TRUE
	rjmp	sys_81
sys_80:
	ldi	templ, FALSE
sys_81:
	cp	temp0l, zero_reg
	breq	B_51_0
	lds	temp0q3, 365
	lds	temp0q2, 365 + 1
	lds	temp0q1, 365 + 2
	lds	temp0q0, 365 + 3
	add	temp0q0, one_reg
	adc	temp0q1, zero_reg
	adc	temp0q2, zero_reg
	adc	temp0q3, zero_reg
	sts	365, temp0q3
	sts	365 + 1, temp0q2
	sts	365 + 2, temp0q1
	sts	365 + 3, temp0q0
B_51_0:
	lds	temp0q3, 361
	lds	temp0q2, 361 + 1
	lds	temp0q1, 361 + 2
	lds	temp0q0, 361 + 3
	add	temp0q0, one_reg
	adc	temp0q1, zero_reg
	adc	temp0q2, zero_reg
	adc	temp0q3, zero_reg
	sts	361, temp0q3
	sts	361 + 1, temp0q2
	sts	361 + 2, temp0q1
	sts	361 + 3, temp0q0
	ret
U_DO_DISP:
	ldi	ZL, low(U_DO_DISP_switch)
	ldi	ZH, high(U_DO_DISP_switch)
	ld	temp0l, Y+		; Pop from stack to temp reg
	ldi	temp1l, 2
	mul	temp1l, temp0l
	add	ZL, r0
	adc	ZH, r1
	ijmp
U_DO_DISP_switch:
	jmp	U_DISP_MODE_0
	jmp	U_DISP_MODE_1
	jmp	U_DISP_MODE_2
	jmp	U_DISP_MODE_3
	jmp	U_DISP_MODE_4
	jmp	U_DISP_MODE_5
	jmp	U_DISP_MODE_6
	jmp	U_DISP_MODE_7
	jmp	U_DISP_MODE_8
	jmp	U_NOTHING
	jmp	U_DISP_MODE_10
	jmp	U_NOTHING
	jmp	U_NOTHING
	jmp	U_NOTHING
	jmp	U_NOTHING
	ret
U_DISP_MODE_10:
	ldi	temp0l, low(25)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16170)	; Load low part of double imm
	ldi	temp1h, high(16170)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ret
U_DISP_MODE_8:
	ldi	temp0l, low(13)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16196)	; Load low part of double imm
	ldi	temp1h, high(16196)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	lds	temp0q3, 369
	lds	temp0q2, 369 + 1
	lds	temp0q1, 369 + 2
	lds	temp0q0, 369 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ldi	temp0q0, low(600)
 	ldi	temp0q1, high(600)
 	ldi	temp0q2, byte3(600)
 	ldi	temp0q3, byte4(600)
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_slash
	ld	temp0q3, Y+
	ld	temp0q2, Y+
	ld	temp0q1, Y+
	ld	temp0q0, Y+
	cp	zero_reg, temp0q0
	cpc	zero_reg, temp0q1
	cpc	zero_reg, temp0q2
	cpc	zero_reg, temp0q3
	brge	sys_82
	ldi	templ, TRUE
	rjmp	sys_83
sys_82:
	ldi	templ, FALSE
sys_83:
	cp	temp0l, zero_reg
	breq	B_49_0
	call	U_DISP_AVERAGE_FUEL
B_49_0:
	ret
U_DISP_AVERAGE_FUEL:
	lds	temp0q3, 373
	lds	temp0q2, 373 + 1
	lds	temp0q1, 373 + 2
	lds	temp0q0, 373 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ldi	temp0q0, low(16)
 	ldi	temp0q1, high(16)
 	ldi	temp0q2, byte3(16)
 	ldi	temp0q3, byte4(16)
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_slash
	lds	temp0q3, 369
	lds	temp0q2, 369 + 1
	lds	temp0q1, 369 + 2
	lds	temp0q0, 369 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ldi	temp0q0, low(600)
 	ldi	temp0q1, high(600)
 	ldi	temp0q2, byte3(600)
 	ldi	temp0q3, byte4(600)
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_slash
	call	U_Q_slash
	ldi	temp1l, low(3)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	temp2l, low(16256)	; Load low part of double imm
	ldi	temp2h, high(16256)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ret
U_DISP_MODE_7:
	ldi	temp0l, low(14)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16210)	; Load low part of double imm
	ldi	temp1h, high(16210)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	lds	temp0q3, 373
	lds	temp0q2, 373 + 1
	lds	temp0q1, 373 + 2
	lds	temp0q0, 373 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ldi	temp0q0, low(160)
 	ldi	temp0q1, high(160)
 	ldi	temp0q2, byte3(160)
 	ldi	temp0q3, byte4(160)
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_slash
	call	U_DISP_FIX_VALUE
	ldi	temp1l, low(1)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	temp2l, low(16260)	; Load low part of double imm
	ldi	temp2h, high(16260)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ret
U_DISP_MODE_6:
	ldi	temp0l, low(11)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16224)	; Load low part of double imm
	ldi	temp1h, high(16224)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	lds	temp0h, 377
	lds	temp0l, 377 + 1
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	call	U_D_grQ
	call	U_DISP_FIX_VALUE
	ldi	temp0l, low(3)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16262)	; Load low part of double imm
	ldi	temp1h, high(16262)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ret
U_DISP_MODE_5:
	ldi	temp0l, low(14)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16236)	; Load low part of double imm
	ldi	temp1h, high(16236)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	lds	temp0q3, 361
	lds	temp0q2, 361 + 1
	lds	temp0q1, 361 + 2
	lds	temp0q0, 361 + 3
	cp	zero_reg, temp0q0
	cpc	zero_reg, temp0q1
	cpc	zero_reg, temp0q2
	cpc	zero_reg, temp0q3
	brge	sys_84
	ldi	templ, TRUE
	rjmp	sys_85
sys_84:
	ldi	templ, FALSE
sys_85:
	cp	temp0l, zero_reg
	breq	B_48_0
	call	U_DISP_AVERAGE_SPEED
B_48_0:
	ret
U_DISP_AVERAGE_SPEED:
	lds	temp0q3, 369
	lds	temp0q2, 369 + 1
	lds	temp0q1, 369 + 2
	lds	temp0q0, 369 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ldi	temp0q0, low(6)
 	ldi	temp0q1, high(6)
 	ldi	temp0q2, byte3(6)
 	ldi	temp0q3, byte4(6)
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_slash
	lds	temp0q3, 361
	lds	temp0q2, 361 + 1
	lds	temp0q1, 361 + 2
	lds	temp0q0, 361 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ldi	temp0q0, low(3600)
 	ldi	temp0q1, high(3600)
 	ldi	temp0q2, byte3(3600)
 	ldi	temp0q3, byte4(3600)
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_star
	ldi	temp1q0, low(10)
 	ldi	temp1q1, high(10)
 	ldi	temp1q2, byte3(10)
 	ldi	temp1q3, byte4(10)
	st	-Y, temp1q0
	st	-Y, temp1q1
	st	-Y, temp1q2
	st	-Y, temp1q3
	call	U_Q_slash
	call	U_Q_slash
	call	U_DISP_FIX_VALUE
	ldi	temp2l, low(3)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	ldi	temp2l, low(16262)	; Load low part of double imm
	ldi	temp2h, high(16262)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ret
U_DISP_MODE_4:
	ldi	temp0l, low(6)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16250)	; Load low part of double imm
	ldi	temp1h, high(16250)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	lds	temp0h, 348
	lds	temp0l, 348 + 1
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	call	U_D_grQ
	call	U_DISP_FIX_VALUE
	ldi	temp0l, low(3)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16262)	; Load low part of double imm
	ldi	temp1h, high(16262)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ret
U_DISP_MODE_3:
	ldi	temp0l, low(11)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16266)	; Load low part of double imm
	ldi	temp1h, high(16266)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	lds	temp0q3, 365
	lds	temp0q2, 365 + 1
	lds	temp0q1, 365 + 2
	lds	temp0q0, 365 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_DISP_TIME
	ret
U_DISP_MODE_2:
	ldi	temp0l, low(13)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16278)	; Load low part of double imm
	ldi	temp1h, high(16278)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	lds	temp0q3, 361
	lds	temp0q2, 361 + 1
	lds	temp0q1, 361 + 2
	lds	temp0q0, 361 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_DISP_TIME
	ret
U_DISP_TIME:
	call	U_SEC_TO_TIME
	ldi	temp0l, low(2)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DISP_VALUE
	ldi	temp1l, low(58)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	ldi	temp0l, low(2)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DISP_VALUE
	ldi	temp1l, low(58)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	ldi	temp0l, low(2)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DISP_VALUE
	ret
U_DISP_VALUE:
	ld	temp0l, Y+		; Pop from stack to temp reg
	push	templ
	ldi	ZH, high(433)
	ldi	ZL, low(433)
	ld	temp0l, Y+
	st	Z, temp0l
	ld	temp0l, Y+
	std	Z + 1, temp0l
	ld	temp0l, Y+
	std	Z + 2, temp0l
	ld	temp0l, Y+
	std	Z + 3, temp0l
	pop	templ
	st	-Y, temp0l		; Push temp to stack
	lds	temp0q3, 433
	lds	temp0q2, 433 + 1
	lds	temp0q1, 433 + 2
	lds	temp0q0, 433 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_grSTR_dotR
	ldi	ZL, low(270)		; Load address (270) to Z register
	ldi	ZH, high(270)
	icall				; Indirect call (270)
	ret
U_DISP_MODE_1:
	ldi	temp0l, low(9)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16294)	; Load low part of double imm
	ldi	temp1h, high(16294)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	lds	temp0q3, 369
	lds	temp0q2, 369 + 1
	lds	temp0q1, 369 + 2
	lds	temp0q0, 369 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ldi	temp0q0, low(60)
 	ldi	temp0q1, high(60)
 	ldi	temp0q2, byte3(60)
 	ldi	temp0q3, byte4(60)
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_slash
	call	U_DISP_FIX_VALUE
	ldi	temp1l, low(2)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	temp2l, low(16292)	; Load low part of double imm
	ldi	temp2h, high(16292)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	ret
U_DISP_MODE_0:
	ldi	temp0l, low(12)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16304)	; Load low part of double imm
	ldi	temp1h, high(16304)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	call	U_GET_TIME
	call	U_PUT_TIME_TO_SCR
	ret
U_DISP_FIX_VALUE:
	ldi	ZH, high(433)
	ldi	ZL, low(433)
	ld	temp0l, Y+
	st	Z, temp0l
	ld	temp0l, Y+
	std	Z + 1, temp0l
	ld	temp0l, Y+
	std	Z + 2, temp0l
	ld	temp0l, Y+
	std	Z + 3, temp0l
	ldi	temp0l, low(10)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(2)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	lds	temp0q3, 433
	lds	temp0q2, 433 + 1
	lds	temp0q1, 433 + 2
	lds	temp0q0, 433 + 3
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_Q_grSTR_dotF_dotR
	ldi	ZL, low(270)		; Load address (270) to Z register
	ldi	ZH, high(270)
	icall				; Indirect call (270)
	ret
U_TIMER0_INIT:
	in	temp0l, 46
	ori	temp0l, low(3)
	out	46, temp0l
	ldi	temp0l, low(62500)	; Load low part of double imm
	ldi	temp0h, high(62500)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ld	temp0l, Y+
	out	43, temp0l
	ld	temp0l, Y+
	out	42, temp0l
	ldi	temp0l, low(0)	; Load low part of double imm
	ldi	temp0h, high(0)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ld	temp0l, Y+
	out	45, temp0l
	ld	temp0l, Y+
	out	44, temp0l
	ret
U_PUT_TIME_TO_SCR:
	ldi	temp0l, low(16)
	sts	266, temp0l
	ldi	temp0l, low(264)
	ldi	temp0h, high(264)
	sts	264, temp0h
	sts	264 + 1, temp0l
	ldi	temp0l, low(5)	; Load low part of double imm
	ldi	temp0h, high(5)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	call	U_CONV_DIG
	ldi	temp1l, low(47)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U_HOLD
	ldi	temp2l, low(4)	; Load low part of double imm
	ldi	temp2h, high(4)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	call	U_CONV_DIG
	ldi	temp2l, low(47)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_HOLD
	ldi	temp2l, low(3)	; Load low part of double imm
	ldi	temp2h, high(3)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	call	U_CONV_DIG
	ldi	temp2l, low(32)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_HOLD
	ldi	temp2l, low(2)	; Load low part of double imm
	ldi	temp2h, high(2)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	call	U_CONV_DIG
	ldi	temp2l, low(58)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_HOLD
	ldi	temp2l, low(1)	; Load low part of double imm
	ldi	temp2h, high(1)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	call	U_CONV_DIG
	ldi	temp2l, low(58)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_HOLD
	ldi	temp2l, low(0)	; Load low part of double imm
	ldi	temp2h, high(0)	; Load high part of double imm
	st	-Y, temp2l		; Push low part to stack
	st	-Y, temp2h		; Push high part to stack
	call	U_CONV_DIG
	ldd	temp0q0, Y + 3
	ldd	temp0q1, Y + 2
	ldd	temp0q2, Y + 1
	ld	temp0q3, Y
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U__numba_gr
	ldi	temp0l, low(10)
	sts	266, temp0l
	ldi	ZL, low(270)		; Load address (270) to Z register
	ldi	ZH, high(270)
	icall				; Indirect call (270)
	ret
U_CONV_DIG:
	ld	temp0h, Y+
	ld	temp0l, Y+
	subi	temp0l, low(-(334))
	sbci	temp0h, high(-(334))
	movw	ZH:ZL, temp0h:temp0l	; Load byte from top of stack
	ld	temp0l, Z
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(0)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	temp2l, low(0)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	ldi	temp2l, low(0)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U__numba
	call	U__numba
	adiw	sp, 4
	ret
U_GET_TIME:
	ldi	temp0l, low(208)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_START
	ld	temp0l, Y+
	com	temp0l
	cp	temp0l, zero_reg
	breq	B_46_0
	call	U_PUT_BUSY_MSG
B_46_0:
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_WRITE
	adiw	sp, 1
	ldi	temp0l, low(209)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_START
	ld	temp0l, Y+
	com	temp0l
	cp	temp0l, zero_reg
	breq	B_47_0
	call	U_PUT_BUSY_MSG
B_47_0:
	call	U_I2C_READ_ACK
	ld	temp0l, Y+
	sts	336, temp0l
	call	U_I2C_READ_ACK
	ld	temp0l, Y+
	sts	335, temp0l
	call	U_I2C_READ_ACK
	ld	temp0l, Y+
	sts	334, temp0l
	call	U_I2C_READ_ACK
	ld	temp0l, Y+
	sts	340, temp0l
	call	U_I2C_READ_ACK
	ld	temp0l, Y+
	sts	337, temp0l
	call	U_I2C_READ_ACK
	ld	temp0l, Y+
	sts	338, temp0l
	call	U_I2C_READ_ACK
	ld	temp0l, Y+
	sts	339, temp0l
	call	U_I2C_READ_NACK
	ld	temp0l, Y+
	sts	341, temp0l
	ret
U_SET_TIME:
	ldi	temp0l, low(208)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_WRITE
	ld	temp0l, Y+		; Top of stack to temp0l
	ld	temp1l, Y+		; Value under top of stack to temp1l
	add	temp0l, temp1l		; Add (top) and (top-1)
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_START
	ld	temp0l, Y+
	com	temp0l
	cp	temp0l, zero_reg
	breq	B_45_0
	call	U_PUT_BUSY_MSG
B_45_0:
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_WRITE
	adiw	sp, 1
	ldi	temp0l, low(2)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_WRITE_TIME
	ldi	temp1l, low(1)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U_WRITE_TIME
	ldi	temp2l, low(0)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_WRITE_TIME
	ldi	temp2l, low(6)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_WRITE_TIME
	ldi	temp2l, low(3)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_WRITE_TIME
	ldi	temp2l, low(4)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_WRITE_TIME
	ldi	temp2l, low(5)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_WRITE_TIME
	ldi	temp2l, low(7)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_WRITE_TIME
	ldi	temp0l, 148
	out	54, temp0l
B_18_5:
	in	temp0l, 54
	sbrs	temp0l, 4
	rjmp	B_18_5
	ret
U_WRITE_TIME:
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_86
	ldi	templ, $0
	rjmp	sys_87
sys_86:	ldi	templ, $ff
sys_87:
	st	-Y, temp0l		; Push temp to stack
	ld	temp0h, Y+
	ld	temp0l, Y+
	subi	temp0l, low(-(334))
	sbci	temp0h, high(-(334))
	movw	ZH:ZL, temp0h:temp0l	; Load byte from top of stack
	ld	temp0l, Z
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_WRITE
	adiw	sp, 1
	ret
U_READ_TRIP_PARAMS_FROM_EEPROM:
	ldi	temp0l, low(0)	; Load low part of double imm
	ldi	temp0h, high(0)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ldi	temp1l, low(360)	; Load low part of double imm
	ldi	temp1h, high(360)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	temp0l, low(32)	; Load low part of double imm
	ldi	temp0h, high(32)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	call	U_EEPROM_READ_BLOCK
	ret
U_WRITE_TRIP_PARAMS_TO_EEPROM:
	ldi	temp0l, low(360)	; Load low part of double imm
	ldi	temp0h, high(360)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ldi	temp1l, low(0)	; Load low part of double imm
	ldi	temp1h, high(0)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	temp0l, low(32)	; Load low part of double imm
	ldi	temp0h, high(32)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	call	U_EEPROM_WRITE_BLOCK
	ret
U_INT1_PROC:
	push	r0			; Start of interrupt word
	in	r0, SREG		; Save SREG
	push	ZH
	push	ZL
	ldi	ZL, low(U_INT1_PROC_startint)	; Point of return from PUSHALLREGS
	ldi	ZH, high(U_INT1_PROC_startint)
	jmp	SYS__lparPUSHALLREGS_rpar
U_INT1_PROC_startint:
	lds	temp0l, 360		; Load byte from 360
	cp	temp0l, zero_reg
	breq	B_44_0
	lds	temp0q3, 369
	lds	temp0q2, 369 + 1
	lds	temp0q1, 369 + 2
	lds	temp0q0, 369 + 3
	add	temp0q0, one_reg
	adc	temp0q1, zero_reg
	adc	temp0q2, zero_reg
	adc	temp0q3, zero_reg
	sts	369, temp0q3
	sts	369 + 1, temp0q2
	sts	369 + 2, temp0q1
	sts	369 + 3, temp0q0
B_44_0:
	lds	temp0h, 346
	lds	temp0l, 346 + 1
	add	temp0l, one_reg
	adc	temp0h, zero_reg
	sts	346, temp0h
	sts	346 + 1, temp0l
	ldi	ZL, low(U_INT1_PROC_retint)	; Point of return from POPALLREGS
	ldi	ZH, high(U_INT1_PROC_retint)
	jmp	SYS__lparPOPALLREGS_rpar
U_INT1_PROC_retint:
	pop	ZL
	pop	ZH
	out	SREG, r0		; Restore SREG
	pop	r0
	reti				; Return from interrupt
U_INT0_PROC:
	push	r0			; Start of interrupt word
	in	r0, SREG		; Save SREG
	push	ZH
	push	ZL
	ldi	ZL, low(U_INT0_PROC_startint)	; Point of return from PUSHALLREGS
	ldi	ZH, high(U_INT0_PROC_startint)
	jmp	SYS__lparPUSHALLREGS_rpar
U_INT0_PROC_startint:
	lds	temp0l, 360		; Load byte from 360
	cp	temp0l, zero_reg
	breq	B_43_0
	lds	temp0q3, 373
	lds	temp0q2, 373 + 1
	lds	temp0q1, 373 + 2
	lds	temp0q0, 373 + 3
	add	temp0q0, one_reg
	adc	temp0q1, zero_reg
	adc	temp0q2, zero_reg
	adc	temp0q3, zero_reg
	sts	373, temp0q3
	sts	373 + 1, temp0q2
	sts	373 + 2, temp0q1
	sts	373 + 3, temp0q0
B_43_0:
	lds	temp0h, 344
	lds	temp0l, 344 + 1
	add	temp0l, one_reg
	adc	temp0h, zero_reg
	sts	344, temp0h
	sts	344 + 1, temp0l
	ldi	ZL, low(U_INT0_PROC_retint)	; Point of return from POPALLREGS
	ldi	ZH, high(U_INT0_PROC_retint)
	jmp	SYS__lparPOPALLREGS_rpar
U_INT0_PROC_retint:
	pop	ZL
	pop	ZH
	out	SREG, r0		; Restore SREG
	pop	r0
	reti				; Return from interrupt
U_UART_INIT:
	ldi	temp0l, 25
	out	9, temp0l
	ldi	temp0l, 24
	out	10, temp0l
	ldi	temp0l, 134
	out	32, temp0l
	ret
U_INIT_LCD_INOUT:
	ldi	temp0l, low(U_LCD_EMIT)
	ldi	temp0h, high(U_LCD_EMIT)
	sts	268, temp0h
	sts	268 + 1, temp0l
	ldi	temp0l, low(U_LCD_LINE_COL)
	ldi	temp0h, high(U_LCD_LINE_COL)
	sts	276, temp0h
	sts	276 + 1, temp0l
	ldi	temp0l, low(U_LCD_CURSOR_ON)
	ldi	temp0h, high(U_LCD_CURSOR_ON)
	sts	278, temp0h
	sts	278 + 1, temp0l
	ldi	temp0l, low(U_LCD_CURSOR_OFF)
	ldi	temp0h, high(U_LCD_CURSOR_OFF)
	sts	280, temp0h
	sts	280 + 1, temp0l
	ret
U_INIT_LCD:
	call	U_LCD_INIT
	ret
U_LCD_EMIT:
	ld	temp0l, Y		; Get stack top value
	cpi	temp0l, low(126)
	brne	sys_88
  	ldi	temp0l, TRUE
  	rjmp	sys_89
sys_88:
	ldi	temp0l, FALSE
sys_89:
	cp	temp0l, zero_reg
	breq	B_34_0
	adiw	sp, 1
	ldi	temp0l, low(192)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_LCD_CMD
	rjmp	B_35_0
B_34_0:
	ld	temp0l, Y		; Get stack top value
	cpi	temp0l, low(124)
	brne	sys_90
  	ldi	temp0l, TRUE
  	rjmp	sys_91
sys_90:
	ldi	temp0l, FALSE
sys_91:
	cp	temp0l, zero_reg
	breq	B_36_0
	adiw	sp, 1
	ldi	temp0l, low(1)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_LCD_CMD
	ldi	temp1l, low(2)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U_DELAY_MS
	rjmp	B_37_0
B_36_0:
	call	U_LCD_DATA
B_37_0:
B_35_0:
	ret
U_LCD_CURSOR_OFF:
	ldi	temp2l, low(12)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_LCD_CMD
	ret
U_LCD_CURSOR_ON:
	ldi	temp2l, low(13)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_LCD_CMD
	ret
U_LCD_LINE_COL:
	ld	temp0l, Y+
	ld	temp1l, Y+
	st	-Y, temp0l		; Push temp to stack
	ldi	temp3l, low(64)
	muls	temp1l, temp3l
	mov	temp0l, r0
	ld	temp1l, Y+
	add	temp0l, temp1l
	subi	temp0l, low(-(128))	; Add imm value to temp0l
	st	-Y, temp0l		; Push temp to stack
	call	U_LCD_CMD
	ret
U_LCD_INIT:
	out	27, zero_reg
	ldi	temp0l, 255
	out	26, temp0l
	ldi	temp0l, low(15)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp0l, 19
	out	27, temp0l
	cbi	27, 4
	ldi	temp0l, low(5)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp0l, 19
	out	27, temp0l
	cbi	27, 4
	ldi	temp0l, low(100)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp0l, 19
	out	27, temp0l
	cbi	27, 4
	ldi	temp0l, low(100)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp0l, 18
	out	27, temp0l
	cbi	27, 4
	ldi	temp0l, 240
	out	26, temp0l
	ldi	temp0l, low(15)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp1l, low(40)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U_LCD_CMD
	ldi	temp2l, low(8)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_LCD_CMD
	ldi	temp2l, low(1)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_LCD_CMD
	ldi	temp2l, low(2)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp2l, low(12)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_LCD_CMD
	ldi	temp2l, low(6)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_LCD_CMD
	ret
U_LCD_DATA:
	call	U_LCD_WAIT
	ldi	temp0l, 255
	out	26, temp0l
	ld	temp0l, Y		; Get stack top value
	swap	templ
	andi	temp0l, low(15)
	ori	temp0l, low(80)
	out	27, temp0l
	cbi	27, 4
	ld	temp0l, Y+		; Pop from stack to temp reg
	swap	templ
	andi	temp0l, low(15)
	ori	temp0l, low(80)
	out	27, temp0l
	cbi	27, 4
	ldi	temp0l, 240
	out	26, temp0l
	ret
U_LCD_CMD:
	call	U_LCD_WAIT
	ldi	temp0l, 255
	out	26, temp0l
	ld	temp0l, Y		; Get stack top value
	swap	templ
	andi	temp0l, low(15)
	ori	temp0l, low(16)
	out	27, temp0l
	cbi	27, 4
	ld	temp0l, Y+		; Pop from stack to temp reg
	swap	templ
	andi	temp0l, low(15)
	ori	temp0l, low(16)
	out	27, temp0l
	cbi	27, 4
	ldi	temp0l, 240
	out	26, temp0l
	ret
U_LCD_WAIT:
	ldi	temp0l, 240
	out	26, temp0l
	cbi	27, 5
	cbi	27, 6
B_33_0:
	cbi	27, 4
	nop
	nop
	in	temp0l, 25
	st	-Y, temp0l		; Push temp to stack
	cbi	27, 4
	cbi	27, 4
	cbi	27, 4
	ld	temp0l, Y+
	sbrs	temp0l, 4
	rjmp	B_33_0
	ret
U_BCD_INC:
	call	U_BCD_TO_BYTE
	ld	temp0l, Y+		; load top of stack to work reg
	inc	temp0l			; increment top of stack
	st	-Y, temp0l		; Push temp to stack
	call	U_BYTE_TO_BCD
	ret
U_BCD_TO_BYTE:
	ld	temp0l, Y		; Get stack top value
	andi	temp0l, low(15)
	ld	temp1l, Y+
	st	-Y, temp0l		; Push temp to stack
	andi	temp1l, low(240)
	swap	templ
	ldi	temp1l, low(10)
	muls	temp0l, temp1l
	mov	temp0l, r0
	ld	temp1l, Y+
	add	temp0l, temp1l
	st	-Y, temp0l		; Push temp to stack
	ret
U_BYTE_TO_BCD:
	ldi	temp1l, low(10)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__slashMOD
	ld	temp0l, Y+
	andi	temp0l, low(15)
	swap	templ
	ld	temp1l, Y+
	add	temp0l, temp1l
	st	-Y, temp0l		; Push temp to stack
	ret
U_SEC_TO_TIME:
	ldi	temp1q0, low(60)
 	ldi	temp1q1, high(60)
 	ldi	temp1q2, byte3(60)
 	ldi	temp1q3, byte4(60)
	st	-Y, temp1q0
	st	-Y, temp1q1
	st	-Y, temp1q2
	st	-Y, temp1q3
	call	U_Q_slashMOD
	ldi	temp2q0, low(60)
 	ldi	temp2q1, high(60)
 	ldi	temp2q2, byte3(60)
 	ldi	temp2q3, byte4(60)
	st	-Y, temp2q0
	st	-Y, temp2q1
	st	-Y, temp2q2
	st	-Y, temp2q3
	call	U_Q_slashMOD
	ret
U_EEPROM_READ_BLOCK:
	ld	temp2h, Y+		; Pop high part from stack
	ld	temp2l, Y+		; Pop low part from stack
	ld	temp1h, Y+		; Pop high part from stack
	ld	temp1l, Y+		; Pop low part from stack
	ld	temp0h, Y+		; Pop high part from stack
	ld	temp0l, Y+		; Pop low part from stack
	movw	YH:YL, temp1h:temp1l
	movw	XH:XL, temp2h:temp2l
sys_92:
	call	SYS__lparEEPROM_at_rpar
	st	-Y, temp1l
	subi	temp0l, low(-1)
	sbci	temp0h, high(-1)
	sbiw	XH:XL, 1
	brne	sys_92
	ret
U_EEPROM_WRITE_BLOCK:
	ld	temp2h, Y+		; Pop high part from stack
	ld	temp2l, Y+		; Pop low part from stack
	ld	temp0h, Y+		; Pop high part from stack
	ld	temp0l, Y+		; Pop low part from stack
	ld	temp1h, Y+		; Pop high part from stack
	ld	temp1l, Y+		; Pop low part from stack
	movw	YH:YL, temp1h:temp1l
	movw	XH:XL, temp2h:temp2l
sys_93:
	ld	temp1l, Y+
	call	SYS__lparEEPROM_excl_rpar
	subi	temp0l, low(-1)
	sbci	temp0h, high(-1)
	sbiw	XH:XL, 1
	brne	sys_93
	ret
U_KEY_INIT:
	ldi	temp0l, low(U_GET_KEY)
	ldi	temp0h, high(U_GET_KEY)
	sts	274, temp0h
	sts	274 + 1, temp0l
	ret
U_GET_KEY:
	in	temp0l, 16
	sbrc	temp0l, 4
	rjmp	sys_94
	mov	temp0l, ff_reg
	rjmp	sys_95
sys_94:
	mov	temp0l, zero_reg
sys_95:
	st	-Y, temp0l		; Push temp to stack
	in	temp0l, 16
	sbrc	temp0l, 5
	rjmp	sys_96
	mov	temp0l, ff_reg
	rjmp	sys_97
sys_96:
	mov	temp0l, zero_reg
sys_97:
	st	-Y, temp0l		; Push temp to stack
	in	temp0l, 16
	sbrc	temp0l, 6
	rjmp	sys_98
	mov	temp0l, ff_reg
	rjmp	sys_99
sys_98:
	mov	temp0l, zero_reg
sys_99:
	ld	temp1l, Y+
	or	temp0l, temp1l
	ld	temp1l, Y+
	or	temp0l, temp1l
	cp	temp0l, zero_reg
	breq	B_27_0
	ldi	temp0l, low(20)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	cbi	18, 7
	call	U_DELAY_MS
	cbi	18, 7
	in	temp0l, 16
	sbrc	temp0l, 4
	rjmp	sys_100
	mov	temp0l, ff_reg
	rjmp	sys_101
sys_100:
	mov	temp0l, zero_reg
sys_101:
	cp	temp0l, zero_reg
	breq	B_28_0
	ldi	temp0l, low(1)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	rjmp	U_GET_KEY_exit
B_28_0:
	in	temp0l, 16
	sbrc	temp0l, 5
	rjmp	sys_102
	mov	temp0l, ff_reg
	rjmp	sys_103
sys_102:
	mov	temp0l, zero_reg
sys_103:
	cp	temp0l, zero_reg
	breq	B_29_0
	ldi	temp0l, low(2)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	rjmp	U_GET_KEY_exit
B_29_0:
	in	temp0l, 16
	sbrc	temp0l, 6
	rjmp	sys_104
	mov	temp0l, ff_reg
	rjmp	sys_105
sys_104:
	mov	temp0l, zero_reg
sys_105:
	cp	temp0l, zero_reg
	breq	B_30_0
	ldi	temp0l, low(250)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	in	temp0l, 16
	sbrc	temp0l, 6
	rjmp	sys_106
	mov	temp0l, ff_reg
	rjmp	sys_107
sys_106:
	mov	temp0l, zero_reg
sys_107:
	cp	temp0l, zero_reg
	breq	B_31_0
	ldi	temp0l, low(4)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	rjmp	U_GET_KEY_exit
B_31_0:
	ldi	temp0l, low(3)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
B_30_0:
	rjmp	B_32_0
B_27_0:
	ldi	temp1l, low(0)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
B_32_0:
U_GET_KEY_exit:
	ret
U_DS1307_INIT:
	call	U_DS1307_TUNING
	ret
U_DS1307_TUNING:
	ldi	temp0l, low(208)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_START
	ld	temp0l, Y+
	com	temp0l
	cp	temp0l, zero_reg
	breq	B_19_0
	call	U_PUT_BUSY_MSG
	rjmp	B_20_0
B_19_0:
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_WRITE
	adiw	sp, 1
	ldi	temp0l, 148
	out	54, temp0l
B_18_1:
	in	temp0l, 54
	sbrs	temp0l, 4
	rjmp	B_18_1
	ldi	temp0l, low(100)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp0l, low(209)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_START
	ld	temp0l, Y+
	com	temp0l
	cp	temp0l, zero_reg
	breq	B_21_0
	call	U_PUT_BUSY_MSG
	rjmp	B_22_0
B_21_0:
	call	U_I2C_READ_NACK
	ldi	temp0l, 148
	out	54, temp0l
B_18_2:
	in	temp0l, 54
	sbrs	temp0l, 4
	rjmp	B_18_2
	ldi	temp0l, low(100)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ld	temp0l, Y+
	andi	temp0l, low(127)
	st	-Y, temp0l		; Push temp to stack
	ldi	temp0l, low(208)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_START
	ld	temp0l, Y+
	com	temp0l
	cp	temp0l, zero_reg
	breq	B_23_0
	adiw	sp, 1
	call	U_PUT_BUSY_MSG
	rjmp	B_24_0
B_23_0:
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_WRITE
	adiw	sp, 1
	call	U_I2C_WRITE
	adiw	sp, 1
	ldi	temp0l, 148
	out	54, temp0l
B_18_3:
	in	temp0l, 54
	sbrs	temp0l, 4
	rjmp	B_18_3
	ldi	temp0l, low(100)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	ldi	temp0l, low(208)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_START
	ld	temp0l, Y+
	com	temp0l
	cp	temp0l, zero_reg
	breq	B_25_0
	call	U_PUT_BUSY_MSG
	rjmp	B_26_0
B_25_0:
	ldi	temp0l, low(7)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_WRITE
	adiw	sp, 1
	ldi	temp0l, low(144)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_I2C_WRITE
	adiw	sp, 1
	ldi	temp0l, 148
	out	54, temp0l
B_18_4:
	in	temp0l, 54
	sbrs	temp0l, 4
	rjmp	B_18_4
B_26_0:
B_24_0:
B_22_0:
B_20_0:
	ret
U_PUT_BUSY_MSG:
	ldi	temp0l, low(124)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	ldi	temp0l, low(11)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(16370)	; Load low part of double imm
	ldi	temp1h, high(16370)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	ldi	ZL, low(272)		; Load address (272) to Z register
	ldi	ZH, high(272)
	icall				; Indirect call (272)
	jmp	sys_forever
	ret
U_I2CMASTER_INIT:
	call	U_I2C_INIT
	ret
U_I2C_READ_ACK:
	ldi	temp0l, 196
	out	54, temp0l
B_13_5:
	in	temp0l, 54
	sbrs	temp0l, 7
	rjmp	B_13_5
	in	temp0l, 3
	st	-Y, temp0l		; Push temp to stack
	ret
U_I2C_READ_NACK:
	ldi	temp0l, 132
	out	54, temp0l
B_13_4:
	in	temp0l, 54
	sbrs	temp0l, 7
	rjmp	B_13_4
	in	temp0l, 3
	st	-Y, temp0l		; Push temp to stack
	ret
U_I2C_WRITE:
	ld	temp0l, Y+
	out	3, temp0l
	ldi	temp0l, 132
	out	54, temp0l
B_13_3:
	in	temp0l, 54
	sbrs	temp0l, 7
	rjmp	B_13_3
	in	temp0l, 1
	andi	temp0l, low(248)
	cpi	temp0l, low(40)
	brne	sys_108
  	ldi	temp0l, TRUE
  	rjmp	sys_109
sys_108:
	ldi	temp0l, FALSE
sys_109:
	com	temp0l
	cp	temp0l, zero_reg
	breq	B_16_0
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	rjmp	B_17_0
B_16_0:
	ldi	temp1l, low(255)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
B_17_0:
	ret
U_I2C_START:
	ldi	temp0l, 164
	out	54, temp0l
B_13_1:
	in	temp0l, 54
	sbrs	temp0l, 7
	rjmp	B_13_1
	in	temp0l, 1
	andi	temp0l, low(248)
	st	-Y, temp0l		; Push temp to stack
	cpi	temp0l, low(8)
	brne	sys_110
  	ldi	temp0l, TRUE
  	rjmp	sys_111
sys_110:
	ldi	temp0l, FALSE
sys_111:
	com	temp0l
	ld	temp1l, Y+
	st	-Y, temp0l		; Push temp to stack
	cpi	temp1l, low(16)
	brne	sys_112
  	ldi	temp0l, TRUE
  	rjmp	sys_113
sys_112:
	ldi	temp0l, FALSE
sys_113:
	com	temp0l
	ld	temp1l, Y+
	and	temp0l, temp1l
	cp	temp0l, zero_reg
	breq	B_14_0
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	rjmp	U_I2C_START_exit
B_14_0:
	ld	temp0l, Y+
	out	3, temp0l
	ldi	temp0l, 132
	out	54, temp0l
B_13_2:
	in	temp0l, 54
	sbrs	temp0l, 7
	rjmp	B_13_2
	in	temp0l, 1
	andi	temp0l, low(248)
	st	-Y, temp0l		; Push temp to stack
	cpi	temp0l, low(24)
	brne	sys_114
  	ldi	temp0l, TRUE
  	rjmp	sys_115
sys_114:
	ldi	temp0l, FALSE
sys_115:
	com	temp0l
	ld	temp1l, Y+
	st	-Y, temp0l		; Push temp to stack
	cpi	temp1l, low(64)
	brne	sys_116
  	ldi	temp0l, TRUE
  	rjmp	sys_117
sys_116:
	ldi	temp0l, FALSE
sys_117:
	com	temp0l
	ld	temp1l, Y+
	and	temp0l, temp1l
	cp	temp0l, zero_reg
	breq	B_15_0
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	rjmp	U_I2C_START_exit
B_15_0:
	ldi	temp0l, low(255)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
U_I2C_START_exit:
	ret
U_I2C_INIT:
	out	1, zero_reg
	ldi	temp0l, 12
	out	0, temp0l
	ret
U_INIT_BEEPER:
	cbi	17, 7
	cbi	18, 7
	ret
U_DELAY_SEC:
	ld	temp0l, Y+
	ldi	temp1l, low(0)
	mov	l0_end, temp0l
	mov	l0_reg, temp1l
B_12_0:
	ldi	temp0l, low(250)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_DELAY_MS
	inc	l0_reg
	cpse	l0_reg, l0_end
	rjmp	B_12_0
	ret
U_DELAY_MS:
	ld	temp0l, Y+		; Pop from stack to temp reg
	ldi	temp1l, low(1000)
	ldi	temp1h, high(1000)
sys_118:
	movw	XH:XL, temp1h:temp1l
sys_119:
	sbiw	XH:XL, 1
	brne	sys_119
	dec	r16
	brne	sys_118
	ret
U_1_excl:
	ldi	temp0l, low(1)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U__excl_excl
	ret
U_0_excl:
	ldi	temp1l, low(0)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__excl_excl
	ret
U__excl_excl:
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_120
	ldi	templ, $0
	rjmp	sys_121
sys_120:	ldi	templ, $ff
sys_121:
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(284)	; Load low part of double imm
	ldi	temp1h, high(284)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	lds	temp0h, 332
	lds	temp0l, 332 + 1
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	movw	ZH:ZL, temp0h:temp0l
	ld	temp0h, Z
	ldd	temp1l, Z + 1
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	ld	temp1l, Y+
	movw	ZH:ZL, temp0h:temp0l
	st	Z, temp1l
	ret
U_1_at:
	ldi	temp0l, low(1)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U__at_at
	ret
U_0_at:
	ldi	temp1l, low(0)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	call	U__at_at
	ret
U__at_at:
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_122
	ldi	templ, $0
	rjmp	sys_123
sys_122:	ldi	templ, $ff
sys_123:
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(284)	; Load low part of double imm
	ldi	temp1h, high(284)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	lds	temp0h, 332
	lds	temp0l, 332 + 1
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	movw	ZH:ZL, temp0h:temp0l
	ld	temp0h, Z
	ldd	temp1l, Z + 1
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	movw	ZH:ZL, temp0h:temp0l	; Load byte from top of stack
	ld	temp0l, Z
	st	-Y, temp0l		; Push temp to stack
	ret
U_DROP_LOCALS:
	lds	temp0h, 332
	lds	temp0l, 332 + 1
	subi	temp0l, 1
	sbci	temp0h, 0
	sts	332, temp0h
	sts	332 + 1, temp0l
	ldi	temp0l, low(316)	; Load low part of double imm
	ldi	temp0h, high(316)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	lds	temp0h, 332
	lds	temp0l, 332 + 1
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	movw	ZH:ZL, temp0h:temp0l	; Load byte from top of stack
	ld	temp0l, Z
	st	-Y, temp0l		; Push temp to stack
	call	U_FREE_MEM
	ret
U_LOCALS:
	ld	temp0l, Y		; Get stack top value
	st	-Y, temp0l		; Push temp to stack
	ldi	temp1l, low(316)	; Load low part of double imm
	ldi	temp1h, high(316)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	lds	temp0h, 332
	lds	temp0l, 332 + 1
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	ld	temp1l, Y+
	movw	ZH:ZL, temp0h:temp0l
	st	Z, temp1l
	call	U_GET_MEM
	ldi	temp0l, low(284)	; Load low part of double imm
	ldi	temp0h, high(284)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	lds	temp0h, 332
	lds	temp0l, 332 + 1
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	ld	temp1h, Y+
	ld	temp1l, Y+
	movw	ZH:ZL, temp1h:temp1l
	st	Z, temp1h
	std	Z + 1, temp1l
	lds	temp0h, 332
	lds	temp0l, 332 + 1
	add	temp0l, one_reg
	adc	temp0h, zero_reg
	sts	332, temp0h
	sts	332 + 1, temp0l
	ret
U_INIT_LOCALS:
	sts	332, zero_reg
	sts	332 + 1, zero_reg
	ret
U_FREE_MEM:
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_124
	ldi	templ, $0
	rjmp	sys_125
sys_124:	ldi	templ, $ff
sys_125:
	st	-Y, temp0l		; Push temp to stack
	lds	temp0h, 282
	lds	temp0l, 282 + 1
	ld	temp1h, Y+		; Pop high part from stack
	ld	temp1l, Y+		; Pop low part from stack
	sub	temp0l, temp1l
	sbc	temp0h, temp1h
	sts	282, temp0h
	sts	282 + 1, temp0l
	ret
U_GET_MEM:
	ld	temp0l, Y		; Get stack top value
	cp	templ, zero_reg
	brlt	sys_126
	ldi	templ, $0
	rjmp	sys_127
sys_126:	ldi	templ, $ff
sys_127:
	st	-Y, temp0l		; Push temp to stack
	lds	temp0h, 282
	lds	temp0l, 282 + 1
	movw	temp1h:temp1l, temp0h:temp0l
	ld	temp2h, Y+		; Pop high part from stack
	ld	temp2l, Y+		; Pop low part from stack
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	add	temp0l, temp2l
	adc	temp0h, temp2h
	sts	282, temp0h
	sts	282 + 1, temp0l
	ret
U_INIT_ALLOCATE:
	ldi	temp0l, low(sys_vars_end)
	ldi	temp0h, high(sys_vars_end)
	sts	282, temp0h
	sts	282 + 1, temp0l
	ret
U_CHAR_IN_OUT:
	ldi	temp0l, low(U_FAKE_DROP)
	ldi	temp0h, high(U_FAKE_DROP)
	sts	268, temp0h
	sts	268 + 1, temp0l
	ldi	temp0l, low(U__lparTYPE_rpar)
	ldi	temp0h, high(U__lparTYPE_rpar)
	sts	270, temp0h
	sts	270 + 1, temp0l
	ldi	temp0l, low(U__lparPTYPE_rpar)
	ldi	temp0h, high(U__lparPTYPE_rpar)
	sts	272, temp0h
	sts	272 + 1, temp0l
	ldi	temp0l, low(U_FAKE_KEY)
	ldi	temp0h, high(U_FAKE_KEY)
	sts	274, temp0h
	sts	274 + 1, temp0l
	ldi	temp0l, low(U_FAKE_DDROP)
	ldi	temp0h, high(U_FAKE_DDROP)
	sts	276, temp0h
	sts	276 + 1, temp0l
	ldi	temp0l, low(U_NOTHING)
	ldi	temp0h, high(U_NOTHING)
	sts	278, temp0h
	sts	278 + 1, temp0l
	ldi	temp0l, low(U_NOTHING)
	ldi	temp0h, high(U_NOTHING)
	sts	280, temp0h
	sts	280 + 1, temp0l
	ret
U_FAKE_DDROP:
	adiw	sp, 2
	ret
U_FAKE_DROP:
	adiw	sp, 1
	ret
U__lparPTYPE_rpar:
	ld	temp0l, Y+		; Pop from stack to temp reg
	ld	temp1l, Y+		; Pop from stack to temp reg
	ld	temp2l, Y+		; Pop from stack to temp reg
	st	-Y, temp1l		; Push temp to stack
	st	-Y, temp0l		; Push temp to stack
	dec	temp2l
	mov	temp0l, temp2l
	ldi	temp3l, low(0)
	mov	l0_end, temp0l
	mov	l0_reg, temp3l
B_11_0:
	ld	temp0h, Y+		; Pop high part from stack
	ld	temp0l, Y+		; Pop low part from stack
	movw	ZH:ZL, temph:templ
	lpm	templ, Z+
	movw	temp1h:temp1l, ZH:ZL
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
	st	-Y, temp0l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	inc	l0_reg
	cpse	l0_reg, l0_end
	rjmp	B_11_0
	adiw	sp, 2
	ret
U__lparTYPE_rpar:
	ld	temp0l, Y+		; Pop from stack to temp reg
	ld	temp1l, Y+		; Pop from stack to temp reg
	ld	temp2l, Y+		; Pop from stack to temp reg
	st	-Y, temp1l		; Push temp to stack
	st	-Y, temp0l		; Push temp to stack
	dec	temp2l
	mov	temp0l, temp2l
	ldi	temp3l, low(0)
	mov	l0_end, temp0l
	mov	l0_reg, temp3l
B_10_0:
	ldd	temp0l, Y + 1          ; Get low part from stack
	ld	temp0h, Y		; Get high part from stack
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	mov	temp0l, l0_reg
	mov	temp0h, zero_reg
	ld	temp1h, Y+
	ld	temp1l, Y+
	add	temp0l, temp1l
	adc	temp0h, temp1h
	movw	ZH:ZL, temp0h:temp0l	; Load byte from top of stack
	ld	temp0l, Z
	st	-Y, temp0l		; Push temp to stack
	ldi	ZL, low(268)		; Load address (268) to Z register
	ldi	ZH, high(268)
	icall				; Indirect call (268)
	inc	l0_reg
	cpse	l0_reg, l0_end
	rjmp	B_10_0
	ret
U_FAKE_KEY:
	ldi	temp0l, low(0)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	ret
U_SETUP_FORMAT:
	ldi	temp0l, low(10)
	sts	266, temp0l
	ret
U_Q_grSTR_dotF_dotR:
	call	U_SET_DPL
	call	U_BLANK_PAD
	ldd	temp0q0, Y + 3
	ldd	temp0q1, Y + 2
	ldd	temp0q2, Y + 1
	ld	temp0q3, Y
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_QABS
	ldi	temp0l, low(264)
	ldi	temp0h, high(264)
	sts	264, temp0h
	sts	264 + 1, temp0l
	call	U__numbaS_dot
	ld	temp0q3, Y+
	ld	temp0q2, Y+
	ld	temp0q1, Y+
	ld	temp0q0, Y+
	ld	temp1q3, Y+
	ld	temp1q2, Y+
	ld	temp1q1, Y+
	ld	temp1q0, Y+
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	st	-Y, temp1q0
	st	-Y, temp1q1
	st	-Y, temp1q2
	st	-Y, temp1q3
	call	U_SIGN
	adiw	sp, 4
	lds	temp0h, 264
	lds	temp0l, 264 + 1
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ret
U_SET_DPL:
	ld	temp0l, Y+		; Pop from stack to temp reg
	push	templ
	ld	temp0l, Y+		; Pop from stack to temp reg
	push	templ
	ld	temp0l, Y+		; Pop from stack to temp reg
	push	templ
	ld	temp0l, Y+		; Pop from stack to temp reg
	push	templ
	ld	temp0l, Y+
	sts	267, temp0l
	pop	templ
	st	-Y, temp0l		; Push temp to stack
	pop	templ
	st	-Y, temp0l		; Push temp to stack
	pop	templ
	st	-Y, temp0l		; Push temp to stack
	pop	templ
	st	-Y, temp0l		; Push temp to stack
	ret
U_Q_grSTR_dotR:
	call	U_BLANK_PAD
	ldd	temp0q0, Y + 3
	ldd	temp0q1, Y + 2
	ldd	temp0q2, Y + 1
	ld	temp0q3, Y
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	call	U_QABS
	ldi	temp0l, low(264)
	ldi	temp0h, high(264)
	sts	264, temp0h
	sts	264 + 1, temp0l
	call	U__numbaS
	ld	temp0q3, Y+
	ld	temp0q2, Y+
	ld	temp0q1, Y+
	ld	temp0q0, Y+
	ld	temp1q3, Y+
	ld	temp1q2, Y+
	ld	temp1q1, Y+
	ld	temp1q0, Y+
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	st	-Y, temp1q0
	st	-Y, temp1q1
	st	-Y, temp1q2
	st	-Y, temp1q3
	call	U_SIGN
	adiw	sp, 4
	lds	temp0h, 264
	lds	temp0l, 264 + 1
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ret
U_SIGN:
	ld	temp0l, Y+		; Pop from stack to temp reg
	adiw	sp, 1
	adiw	sp, 2
	sbrs	temp0l, 7
	rjmp	sys_128
	ldi	templ, TRUE
	rjmp	sys_129
sys_128:
	ldi	templ, FALSE
sys_129:
	cp	temp0l, zero_reg
	breq	B_9_0
	ldi	temp0l, low(45)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_HOLD
B_9_0:
	ret
U__numba_gr:
	adiw	sp, 4
	lds	temp0h, 264
	lds	temp0l, 264 + 1
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ldi	temp0l, low(264)	; Load low part of double imm
	ldi	temp0h, high(264)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ldd	temp0l, Y + 3
	ldd	temp0h, Y + 2
	ld	temp1h,	Y+
	ld	temp1l, Y+
	sub	temp1l, temp0l
	sbc	temp1h, temp0h
	movw	temp0h:temp0l, temp1h:temp1l
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	adiw	sp, 1
	ld	temp0l, Y+		; Pop from stack to temp reg
	ld	temp1l, Y+		; Pop from stack to temp reg
	ld	temp2l, Y+		; Pop from stack to temp reg
	st	-Y, temp0l		; Push temp to stack
	st	-Y, temp2l		; Push temp to stack
	st	-Y, temp1l		; Push temp to stack
	ret
U__numbaS_dot:
	lds	temp0l, 267		; Load byte from 267
	push	templ
B_7_0:
	call	U__numba
	lds	temp0l, 267		; Load byte from 267
	dec	temp0l			; Decrement top of stack
	st	-Y, temp0l		; Push temp to stack
	sts	267, temp0l
	ld	temp0l, Y+
	cp	temp0l, zero_reg
	brne	sys_130
	ldi	templ, TRUE
	rjmp	sys_131
sys_130:
	ldi	templ, FALSE
sys_131:
	cp	temp0l, zero_reg
	breq	B_8_0
	ldi	temp0l, low(46)	; Load imm to temp reg
	st	-Y, temp0l		; Push temp to stack
	call	U_HOLD
B_8_0:
	ldd	temp0q0, Y + 3
	ldd	temp0q1, Y + 2
	ldd	temp0q2, Y + 1
	ld	temp0q3, Y
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ld	temp0l, Y+
	ld	temp1l, Y+
	or	temp0l, temp1l
	ld	temp1l, Y+
	or	temp0l, temp1l
	ld	temp1l, Y+
	or	temp0l, temp1l
	cp	temp0l, zero_reg
	brne	sys_132
	ldi	templ, TRUE
	rjmp	sys_133
sys_132:
	ldi	templ, FALSE
sys_133:
	cp	temp0l, zero_reg
	breq	B_7_0
	pop	templ
	sts	267, temp0l
	ret
U__numbaS:
B_6_0:
	call	U__numba
	ldd	temp0q0, Y + 3
	ldd	temp0q1, Y + 2
	ldd	temp0q2, Y + 1
	ld	temp0q3, Y
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ld	temp0l, Y+
	ld	temp1l, Y+
	or	temp0l, temp1l
	ld	temp1l, Y+
	or	temp0l, temp1l
	ld	temp1l, Y+
	or	temp0l, temp1l
	cp	temp0l, zero_reg
	brne	sys_134
	ldi	templ, TRUE
	rjmp	sys_135
sys_134:
	ldi	templ, FALSE
sys_135:
	cp	temp0l, zero_reg
	breq	B_6_0
	ret
U__numba:
	lds	temp0l, 266		; Load byte from 266
	st	-Y, temp0l		; Push temp to stack
	cp	templ, zero_reg
	brlt	sys_136
	ldi	templ, $0
	rjmp	sys_137
sys_136:	ldi	templ, $ff
sys_137:
	st	-Y, temp0l		; Push temp to stack
	call	U_D_grQ
	call	U_QU_slashMOD
	ld	temp0q3, Y+
	ld	temp0q2, Y+
	ld	temp0q1, Y+
	ld	temp0q0, Y+
	ld	temp1q3, Y+
	ld	temp1q2, Y+
	ld	temp1q1, Y+
	ld	temp1q0, Y+
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	st	-Y, temp1q0
	st	-Y, temp1q1
	st	-Y, temp1q2
	st	-Y, temp1q3
	adiw	sp, 2
	adiw	sp, 1
	call	U_ALPHA
	call	U_HOLD
	ret
U_HOLD:
	lds	temp0h, 264
	lds	temp0l, 264 + 1
	subi	temp0l, 1
	sbci	temp0h, 0
	sts	264, temp0h
	sts	264 + 1, temp0l
	lds	temp0h, 264
	lds	temp0l, 264 + 1
	ld	temp1l, Y+
	movw	ZH:ZL, temp0h:temp0l
	st	Z, temp1l
	ret
U_BLANK_PAD:
	ldi	temp0l, low(224)	; Load low part of double imm
	ldi	temp0h, high(224)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	ldi	temp1l, low(40)	; Load imm to temp reg
	st	-Y, temp1l		; Push temp to stack
	ldi	temp2l, low(32)	; Load imm to temp reg
	st	-Y, temp2l		; Push temp to stack
	call	U_FILL
	ret
U_ALPHA:
	ld	temp0l, Y		; Get stack top value
	subi	temp0l, low(10)		; Substract 10 from top of stack
	cp	templ, zero_reg
	brpl	sys_138
	ldi	templ, TRUE
	rjmp	sys_139
sys_138:
	ldi	templ, FALSE
sys_139:
	cp	temp0l, zero_reg
	breq	B_4_0
	ld	temp0l, Y+
	subi	temp0l, low(-(48))	; Add imm value to (top-1) value
	st	-Y, temp0l		; Push temp to stack
	rjmp	B_5_0
B_4_0:
	ld	temp0l, Y+
	subi	temp0l, low(10)
	subi	temp0l, low(-(65))	; Add imm value to temp0l
	st	-Y, temp0l		; Push temp to stack
B_5_0:
	ret
U_NOTHING:
	ret
U_FILL:
	ld	temp2l, Y+		; Pop from stack to temp reg
	ld	temp0l, Y+		; Pop from stack to temp reg
	ld	ZH, Y+
	ld	ZL, Y+
sys_140:
	st	Z+, temp2l
	dec	temp0l
	brne	sys_140
	ret
U_D_grQ:
	ldd	temp0l, Y + 1          ; Get low part from stack
	ld	temp0h, Y		; Get high part from stack
	cp	templ, zero_reg
	cpc	temph, zero_reg
	brpl	sys_141
	ldi	templ, TRUE
	rjmp	sys_142
sys_141:
	ldi	templ, FALSE
sys_142:
	cp	temp0l, zero_reg
	breq	B_1_0
	ldi	temp0l, low(-1)	; Load low part of double imm
	ldi	temp0h, high(-1)	; Load high part of double imm
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
	rjmp	B_2_0
B_1_0:
	ldi	temp1l, low(0)	; Load low part of double imm
	ldi	temp1h, high(0)	; Load high part of double imm
	st	-Y, temp1l		; Push low part to stack
	st	-Y, temp1h		; Push high part to stack
B_2_0:
	ret
U_QU_slashMOD:
	ld	r21, Y+
	ld	r20, Y+
	ld	r19, Y+
	ld	r18, Y+
	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	push	YH
	push	YL
	call	SYS__lparQU_slashMOD_rpar
	pop	YL
	pop	YH
	st	-Y, r22
	st	-Y, r23
	st	-Y, r24
	st	-Y, r25
	st	-Y, r18
	st	-Y, r19
	st	-Y, r20
	st	-Y, r21
	ret
U_QABS:
	ld	temp1q3, Y+
	ld	temp1q2, Y+
	ld	temp1q1, Y+
	ld	temp1q0, Y+
	cp	temp1q0, zero_reg
	cpc	temp1q1, zero_reg
	cpc	temp1q2, zero_reg
	cpc	temp1q3, zero_reg
	brmi	abs_143
	movw	temp0q1:temp0q0, temp1q1:temp1q0
	movw	temp0q3:temp0q2, temp1q3:temp1q2
	rjmp	abs_144
abs_143:
	mov	temp0q0, zero_reg
	mov	temp0q1, zero_reg
	movw	temp0q3:temp0q2, temp0q1:temp0q0
	sub	temp0q0, temp1q0
	sbc	temp0q1, temp1q1
	sbc	temp0q2, temp1q2
	sbc	temp0q3, temp1q3
abs_144:
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ret
U_Q_slash:
	ld	temp0q3, Y+
	ld	temp0q2, Y+
	ld	temp0q1, Y+
	ld	temp0q0, Y+
	ld	temp1q3, Y+
	ld	temp1q2, Y+
	ld	temp1q1, Y+
	ld	temp1q0, Y+
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ret
U_Q_slashMOD:
	ld	r21, Y+
	ld	r20, Y+
	ld	r19, Y+
	ld	r18, Y+
	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	push	YH
	push	YL
	call	SYS__lparQ_slashMOD_rpar
	pop	YL
	pop	YH
	st	-Y, r22
	st	-Y, r23
	st	-Y, r24
	st	-Y, r25
	st	-Y, r18
	st	-Y, r19
	st	-Y, r20
	st	-Y, r21
	ret
U_Q_star:
	ld	r25, Y+
	ld	r24, Y+
	ld	r23, Y+
	ld	r22, Y+
	ld	r21, Y+
	ld	r20, Y+
	ld	r19, Y+
	ld	r18, Y+
	call	SYS__lparQ_star_rpar
	movw	temp0q1:temp0q0, r23:r22
	movw	temp0q3:temp0q2, r25:r24
	st	-Y, temp0q0
	st	-Y, temp0q1
	st	-Y, temp0q2
	st	-Y, temp0q3
	ret
U_D_star:
	ld	temp1h, Y+		; Pop high part from stack
	ld	temp1l, Y+		; Pop low part from stack
	ld	temp0h, Y+		; Pop high part from stack
	ld	temp0l, Y+		; Pop low part from stack
	; r17:r16 = r23:r22 * r21:r20
	movw	r23:r22, temph:templ
	movw	r21:r20, temp1h:temp1l
	mul	r22, r20
	movw	r17:r16, r1:r0
	mul	r23, r20
	add	r17, r0
	mul	r21, r22
	add	r17, r0
	st	-Y, temp0l		; Push low part to stack
	st	-Y, temp0h		; Push high part to stack
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
sys_145:
	st	X+, zero_reg			; Clear variables
	sbiw	ZH:ZL, 1
	brne	sys_145
	ret
SYS__lparEEPROM_at_rpar:
	in	r0, SREG
	push	r0
	cli
sys_146:
	sbic	EECR, EEWE
	rjmp	sys_146
	out	EEARH, temp0h
	out	EEARL, temp0l
	sbi	EECR, EERE
	in	temp1l, EEDR
	pop	r0
	out	SREG, r0
	ret
SYS__lparEEPROM_excl_rpar:
	in	r0, SREG
	push	r0
	cli
sys_147:
	sbic	EECR, EEWE
	rjmp	sys_147
	out	EEARH, temp0h
	out	EEARL, temp0l
	out	EEDR, temp1l
	sbi	EECR, EEMWE
	sbi	EECR, EEWE
	pop	r0
	out	SREG, r0
	ret
SYS__lparQU_slashMOD_rpar:
	
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
	movw	r24, r30
	ret
SYS__lparQ_slashMOD_rpar:
	bst	r25, 7
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
	movw	r24, r30
	ret
SYS__lparQ_star_rpar:
	
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
d8s_148:	rol	dd8s
	dec	dcnt8s
	brne	d8s_149
	sbrc	d8s,7
	neg	dres8s
	rjmp	d8s_150
d8s_149:	rol	drem8s
	sub	drem8s,dv8s
	brcc	d8s_151
	add	drem8s,dv8s
	clc
	rjmp	d8s_148
d8s_151:	sec
	rjmp	d8s_148
d8s_150:	mov	temp1l, drem8s
	ret
SYS__lparPOPALLREGS_rpar:
	pop	r29			; Restore of regs
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
	ijmp
	ret
SYS__lparPUSHALLREGS_rpar:
	push	r0			; Save all regs
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
	ijmp
	ret
	.org	8078
; DS1307 busy 
	.db	 68,  83,  49,  51,  48,  55,  32,  98, 117, 115, 121,   0
; Trip computer~by Ruslan Stepanenko
	.db	 84, 114, 105, 112,  32,  99, 111, 109, 112, 117, 116, 101
	.db	114, 126,  98, 121,  32,  82, 117, 115, 108,  97, 110,  32
	.db	 83, 116, 101, 112,  97, 110, 101, 110, 107, 111
; Trip~STOP 
	.db	 84, 114, 105, 112, 126,  83,  84,  79,  80,   0
; Trip~START
	.db	 84, 114, 105, 112, 126,  83,  84,  65,  82,  84
; Date & time~
	.db	 68,  97, 116, 101,  32,  38,  32, 116, 105, 109, 101, 126
; Distance~ 
	.db	 68, 105, 115, 116,  97, 110,  99, 101, 126,   0
; km
	.db	107, 109
; Time in trip~ 
	.db	 84, 105, 109, 101,  32, 105, 110,  32, 116, 114, 105, 112
	.db	126,   0
; Time in go~ 
	.db	 84, 105, 109, 101,  32, 105, 110,  32, 103, 111, 126,   0
; kph 
	.db	107, 112, 104,   0
; l 
	.db	108,   0
; lpk 
	.db	108, 112, 107,   0
; Speed~
	.db	 83, 112, 101, 101, 100, 126
; Average speed~
	.db	 65, 118, 101, 114,  97, 103, 101,  32, 115, 112, 101, 101
	.db	100, 126
; Peak speed~ 
	.db	 80, 101,  97, 107,  32, 115, 112, 101, 101, 100, 126,   0
; Fuel on route~
	.db	 70, 117, 101, 108,  32, 111, 110,  32, 114, 111, 117, 116
	.db	101, 126
; Average fuel~ 
	.db	 65, 118, 101, 114,  97, 103, 101,  32, 102, 117, 101, 108
	.db	126,   0
; Reset trip?~+: Yes, -: No 
	.db	 82, 101, 115, 101, 116,  32, 116, 114, 105, 112,  63, 126
	.db	 43,  58,  32,  89, 101, 115,  44,  32,  45,  58,  32,  78
	.db	111,   0
; Set date/time 
	.db	 83, 101, 116,  32, 100,  97, 116, 101,  47, 116, 105, 109
	.db	101,   0
	.dseg
	.org	96
sys_vars_start:
sys_data_stack:
	.byte	128
U_BUF:		; 224
	.byte	40
U_HLD:		; 264
	.byte	2
U_BASE:		; 266
	.byte	1
U_DPL:		; 267
	.byte	1
U_EMIT_WORD:		; 268
	.byte	2
U_TYPE_WORD:		; 270
	.byte	2
U_PTYPE_WORD:		; 272
	.byte	2
U_KEY_WORD:		; 274
	.byte	2
U_GOTO_LINE_COL_WORD:		; 276
	.byte	2
U_CURSOR_ON_WORD:		; 278
	.byte	2
U_CURSOR_OFF_WORD:		; 280
	.byte	2
U_DP:		; 282
	.byte	2
U_LOCAL_STACKS:		; 284
	.byte	32
U_LOCAL_SIZES:		; 316
	.byte	16
U_LSP:		; 332
	.byte	2
U_TIME:		; 334
	.byte	8
U_DISPLAY_DISABLE:		; 342
	.byte	1
U_NEED_SCR_CLEAR:		; 343
	.byte	1
U_FUEL_CNT:		; 344
	.byte	2
U_SPEED_CNT:		; 346
	.byte	2
U_CUR_SPEED:		; 348
	.byte	2
U_CUR_FUEL:		; 350
	.byte	2
U_PARAMS_FUEL:		; 352
	.byte	4
U_PARAMS_DISTANCE:		; 356
	.byte	4
U_STATE:		; 360
	.byte	1
U_TIME_IN_TRIP:		; 361
	.byte	4
U_TIME_IN_GO:		; 365
	.byte	4
U_DISTANCE:		; 369
	.byte	4
U_FUEL:		; 373
	.byte	4
U_PEAK_SPEED:		; 377
	.byte	2
U_DISP_MODE:		; 379
	.byte	1
U_ALARM:		; 380
	.byte	6
U_SPEED_ALARM:		; 386
	.byte	2
U_START_TIME:		; 388
	.byte	4
U_PARAM_END:		; 392
	.byte	1
U_LL:		; 393
	.byte	40
U_DISP_TEMP:		; 433
	.byte	4
sys_vars_end:
