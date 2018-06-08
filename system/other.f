INCLUDE< temps.f>
INCLUDE< branch-loops.f>
INCLUDE< convert.f>

: >R ( b --> ) CS>W A" push	templ" ; INLINE-FOREVER

: R> ( --> b ) A" pop	templ" CW>S ; INLINE-FOREVER
	
: NOP ( --> ) A" nop" ; INLINE-FOREVER

: SWAP-NIB ( b1 --> b2 ) CS>W A" swap	templ" CW>S ; INLINE

: NOTHING ( --> ) ;

: EXIT ( --> ) A" jmp	sys_forever" ; INLINE

: EXECUTE ( un --> ) PRIM 1&EXECUTE ; INLINE

CG" 	ldi	ZL, low(%0)		; Load address (%0) to Z register
	ldi	ZH, high(%0)
	icall				; Indirect call (%0)" (EXECUTE:I:::)

: RECURSE ( --> ) PRIM RECURSE ; INLINE-FOREVER

CG" 	call	%0" (RECURSE:I:::)

: ?DUP DUP IF DUP THEN ; INLINE

: M* ( c1 c2 --> n ) CS>W CS>W-1
A"
	muls	temp0l, temp1l
	movw	temp0h:temp1h, r1:r0" W>S ; INLINE
	
: */ ( c1 c2 c3 --> [c2 * c1] / c3 ) ROT M* S>D D/ D>S ; INLINE

SRAM_START STACK_SIZE + DCONSTANT STACK_TOP

: SP! ( --> ) 
A"
	ldi	YL, low(`STACK_TOP`)
	ldi	YH, high(`STACK_TOP`)" ; INLINE
	
: SP@ ( --> SP ) A" movw	temp0h:temp0l, YH:YL" W>S ; INLINE

: ABSTRACT PRIM ABSTACT ; INLINE-FOREVER
