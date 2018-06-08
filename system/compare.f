INCLUDE< temps.f>
INCLUDE< arithm.f>
INCLUDE< darithm.f>
INCLUDE< logic.f>

: TRUE ( --> b ) $FF ; INLINE-FOREVER

: FALSE ( --> b ) 0 ; INLINE-FOREVER

: = ( c1, c2 --> c1 = c2 ) PRIM 2%COMPARE
  A"
  	brne	sys_@1
  	ldi	temp0l, TRUE
  	rjmp	sys_@2
sys_@1:
	ldi	temp0l, FALSE
sys_@2:
" CW>S ; INLINE

CG" 	cp	temp0l, zero_reg" (COMPARE:IR:0:0:)
CG" 	cpi	temp0l, low(%0)"  (COMPARE:IR::0:)
CG" 	cpi	temp%1l, low(%0)" (COMPARE:IR:::)
CG" 	ld	temp0l, Y+
	ld	temp1l, Y+
	cp	temp0l, temp1l" (COMPARE::::)
CG" 	ld	temp0l, Y+
	cpi	temp0l, low(%0)" (COMPARE:I:::)

CG" 	ld	temp1l, Y+		; Load value under top to temp1l
	cp	temp0l, temp1l		; Compare with top of stack" (COMPARE:R:0::)
CG" 	cpi	temp%1l, 1		; Compare top of stack with 1" (COMPARE:IR:1:0:)
CG" 	cpi	temp%1l, 2		; Compare top of stack with 2" (COMPARE:IR:2:0:)
CG" 	cpi	temp%1l, 255		; Compare top of stack with 255" (COMPARE:IR:255:0:)

: 0= ( c --> c = 0 ) PRIM 1%COMPBYTEZERO
  A"
	brne	sys_@1
	ldi	templ, TRUE
	rjmp	sys_@2
sys_@1:
	ldi	templ, FALSE
sys_@2:
" CW>S ; INLINE

CG" 	cp	temp0l, zero_reg" (COMPBYTEZERO:R:0::)
CG" 	cp	temp%0l, zero_reg" (COMPBYTEZERO:R:::)
CG" 	ld	temp0l, Y+
	cp	temp0l, zero_reg" (COMPBYTEZERO::::)

: 0> ( c --> c > 0 )
  CS>W A"
	cp	zero_reg, templ
	brge	sys_@1
	ldi	templ, TRUE
	rjmp	sys_@2
sys_@1:
	ldi	templ, FALSE
sys_@2:
" CW>S ; INLINE

: 0< ( c --> c < 0 )
  CS>W A"
	cp	templ, zero_reg
	brpl	sys_@1
	ldi	templ, TRUE
	rjmp	sys_@2
sys_@1:
	ldi	templ, FALSE
sys_@2:
" CW>S ; INLINE

: < ( c1, c2 --> c1 < c2 ) - 0< ; INLINE
: > ( c1, c2 --> c1 > c2 ) - 0> ; INLINE
: <> = NOT ; INLINE

: D0= ( n --> n = 0 ) OR 0= ; INLINE

: D0> ( n --> n > 0 )
  S>W A"
	cp	zero_reg, templ
	cpc	zero_reg, temph
	brge	sys_@1
	ldi	templ, TRUE
	rjmp	sys_@2
sys_@1:
	ldi	templ, FALSE
sys_@2:
" CW>S ; INLINE

: D0< ( n --> n < 0 )
  S>W A"
	cp	templ, zero_reg
	cpc	temph, zero_reg
	brpl	sys_@1
	ldi	templ, TRUE
	rjmp	sys_@2
sys_@1:
	ldi	templ, FALSE
sys_@2:
" CW>S ; INLINE

: D< ( n1, n2 --> n1 < n2 ) D- D0< ; INLINE
: D= ( n1, n2 --> n1 = n2 ) D- D0= ; INLINE
: D> ( n1, n2 --> n1 > n2 ) D- D0> ; INLINE

: Q0= ( q --> q = 0 ) OR OR OR 0= ; INLINE

: Q0< ( q --> q < 0 )
  CS>W DROP DDROP A"
        sbrs	temp0l, 7
	rjmp	sys_@1
	ldi	templ, TRUE
	rjmp	sys_@2
sys_@1:
	ldi	templ, FALSE
sys_@2:
" CW>S ; INLINE

: Q0> ( c --> c > 0 )
  QS>W A"
	cp	zero_reg, temp0q0
	cpc	zero_reg, temp0q1
	cpc	zero_reg, temp0q2
	cpc	zero_reg, temp0q3
	brge	sys_@1
	ldi	templ, TRUE
	rjmp	sys_@2
sys_@1:
	ldi	templ, FALSE
sys_@2:
" CW>S ; INLINE
