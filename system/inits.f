: STACK-AND-MEMORY-INIT
A"
	ldi	ZH, high(sys_vars_end - sys_vars_start)
	ldi	ZL, low(sys_vars_end - sys_vars_start)
	ldi	XH, high(sys_vars_start)
	ldi	XL, low(sys_vars_start)
sys_@2:
	st	X+, zero_reg			; Clear variables
	sbiw	ZH:ZL, 1
	brne	sys_@2
" ; INIT
