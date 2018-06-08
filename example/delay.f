INCLUDE" cpu.f"

F_CPU 4000 / DCONSTANT DELAY-COUNTER

: DELAY-MS ( ms --> ) CS>W
A"
	ldi	temp1l, low(`DELAY-COUNTER`)
	ldi	temp1h, high(`DELAY-COUNTER`)
sys_@0:
	movw	XH:XL, temp1h:temp1l
sys_@1:
	sbiw	XH:XL, 1
	brne	sys_@1
	dec	r16
	brne	sys_@0" ;

: DELAY-SEC ( sec --> ) 0 DO 250 DELAY-MS LOOP ;
