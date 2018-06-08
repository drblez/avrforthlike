INCLUDE< temps.f>
INCLUDE< stack.f>
INCLUDE< compare.f>
INCLUDE< branch-loops.f>

( CONVERT )

: S>D ( c --> n )
CS=W A"
	cp	templ, zero_reg
	brlt	sys_@1
	ldi	templ, $0
	rjmp	sys_@2
sys_@1:	ldi	templ, $ff
sys_@2:
" CW>S ; INLINE

: D>S ( n --> c ) DROP ; INLINE

: D>Q ( n --> q ) DDUP D0< IF -1. ELSE 0. THEN ;

: Q>D ( q --> n ) DDROP ; INLINE

: Q>S ( q --> c ) Q>D D>S ; INLINE

: S>Q ( c --> q ) S>D D>Q ; INLINE
