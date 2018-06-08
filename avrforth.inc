	.def	temp	= r16
	.def	temph	= r17
	.def	templ	= r16
	.def	temp0h	= r17
	.def	temp0l	= r16
	.def	sp	= r28
	.def	temp1h	= r19
	.def	temp1l	= r18
	.def	temp1	= r18
	.def	temp2h	= r21
	.def	temp2l	= r20
	.def	temp3h	= r23
	.def	temp3l  = r22
	.def	zero_reg= r2
	.def	one_reg	= r3
	.def	two_reg	= r4
	.def	ff_reg	= r5
	.def	l0_reg	= r6
	.def	l1_reg	= r7
	.def	l2_reg	= r8
	.def	l0_end	= r9
	.def	l1_end	= r10
	.def	l2_end	= r11
	
; for quad

	.def	temp0q0	= r16
	.def	temp0q1	= r17
	.def	temp0q2	= r18
	.def	temp0q3 = r19
	.def	temp1q0	= r20
	.def	temp1q1	= r21
	.def	temp1q2	= r22
	.def	temp1q3 = r23
	.def	temp2q0	= r24
	.def	temp2q1	= r25
	.def	temp2q2	= r26
	.def	temp2q3 = r27
	
; for 16/16 divide
	
	.def	d16s	= r13
	.def	drem16sL= r14
	.def	drem16sH= r15
	.def	dres16sL= r16
	.def	dres16sH= r17
	.def	dd16sL	= r16
	.def	dd16sH	= r17
	.def	dv16sL	= r18
	.def	dv16sH	= r19
	.def	dcnt16s	= r20
	
; for 8/8 divide
	
	.def	d8s	= r14
	.def	drem8s	= r15
	.def	dres8s	= r16
	.def	dd8s	= r16
	.def	dv8s	= r17
	.def	dcnt8s	= r18

;

	.equ	FALSE	= $0
	.equ	TRUE	= $ff
