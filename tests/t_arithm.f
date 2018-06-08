INCLUDE< allocate.f>

VARIABLE A
VARIABLE B
VARIABLE C

DVARIABLE DA
DVARIABLE DB

: T_ALLOCATE

	10 GET-MEM DA D!
	10 GET-MEM DB D!
	20 FREE-MEM
;

: _ABS 0< IF NEGATE THEN ;

: T_ARITHM

	10 A !
	2  B !

A"
 	; test >>
"
 
	A @ B @ >> C !
	10  B @ >> C !
	A @ 10  >> C !
	A @ 0   >> C ! A @ 1   >> C ! A @ 2   >> C ! A @ 255 >> C !
	0 B @   >> C ! 1 B @   >> C ! 2 B @   >> C ! 255 B @ >> C !

A"
	; test <<
"
 
	A @ B @ << C !
	10  B @ << C !
	A @ 10  << C !
	A @ 0   << C ! A @ 1   << C ! A @ 2   << C ! A @ 255 << C !
	0 B @   << C ! 1 B @   << C ! 2 B @   << C ! 255 B @ << C !

A"
	; test BV
"

	1 BV C ! 2 BV C ! 3 BV C !

A"
	; test +
"

	A @ B @ + C !
	10  B @ + C !
	A @ 10  + C !
	A @ 0   + C ! A @ 1   + C ! A @ 2   + C ! A @ 255 + C !
	0 B @   + C ! 1 B @   + C ! 2 B @   + C ! 255 B @ + C !

A"
	; test 1+
"

	A @ 1+ C !
	10 1+ C !
	1  1+ C !

A"
	; test -
"

	A @ B @ - C !
	10  B @ - C !
	A @ 10  - C !
	A @ 0   - C ! A @ 1   - C ! A @ 2   - C ! A @ 255 - C !
	0 B @   - C ! 1 B @   - C ! 2 B @   - C ! 255 B @ - C !

A"
	; test *
"

	A @ B @ * C !
	10  B @ * C !
	A @ 10  * C !
	A @ 0   * C ! A @ 1   * C ! A @ 2   * C ! A @ 255 * C !
	0 B @   * C ! 1 B @   * C ! 2 B @   * C ! 255 B @ * C !

A"
	; test /
"

	A @ B @ / C !
	10  B @ / C !
	A @ 10  / C !
	A @ 0   / C ! A @ 1   / C ! A @ 2   / C ! A @ 255 / C !
	0 B @   / C ! 1 B @   / C ! 2 B @   / C ! 255 B @ / C !

A"
	; test MOD
"

	A @ B @ MOD C !
	10  B @ MOD C !
	A @ 10  MOD C !
	A @ 0   MOD C ! A @ 1   MOD C ! A @ 2   MOD C ! A @ 255 MOD C !
	0 B @   MOD C ! 1 B @   MOD C ! 2 B @   MOD C ! 255 B @ MOD C !

A"
	; test 2*
"

	A @ 2* C !
	10  2* C !
	1   2* C !

A"
	; test 2/
"

	A @ 2/ C !
	10  2/ C !
	1   2/ C !

A"
	; test NEGATE
"

	A @ NEGATE C !
	10  NEGATE C !
	0   NEGATE C !
	1   NEGATE C ! 
	2   NEGATE C ! 
	255 NEGATE C !

A"
	; test ABS
"
	A @ ABS C !
	A @ NEGATE ABS C !

A"
	; test _ABS
"
	A @ _ABS C !
	A @ NEGATE _ABS C !

;

: T_BITS

	3 A !

	PORTC B !

	A @ PORTC SET-BIT
	
	PC0 B @ SET-BIT

	A @ B @ SET-BIT

	PC0 PORTC SET-BIT
	PC1 PORTC SET-BIT
	PC2 PORTC SET-BIT
	PC3 PORTC SET-BIT
	PC4 PORTC SET-BIT
	PC5 PORTC SET-BIT
	PC6 PORTC SET-BIT
	PC7 PORTC SET-BIT

	A @ PORTC CLR-BIT
	
	PC0 B @ CLR-BIT

	A @ B @ CLR-BIT

	PC0 PORTC CLR-BIT
	PC1 PORTC CLR-BIT
	PC2 PORTC CLR-BIT
	PC3 PORTC CLR-BIT
	PC4 PORTC CLR-BIT
	PC5 PORTC CLR-BIT
	PC6 PORTC CLR-BIT
	PC7 PORTC CLR-BIT
;


: T_COMPARE

	A @ B @ = C !
	A @ 10  = C !
	10  B @ = C !
	A @ 0   = C ! A @ 1   = C ! A @ 2   = C ! A @ 255 = C !
	0   B @ = C ! 1   B @ = C ! 2   B @ = C ! 255 B @ = C !

	A @ B @ < C !
	A @ 10  < C !
	10  B @ < C !
	A @ 0   < C ! A @ 1   < C ! A @ 2   < C ! A @ 255 < C !
	0   B @ < C ! 1   B @ < C ! 2   B @ < C ! 255 B @ < C !

	A @ B @ > C !
	A @ 10  > C !
	10  B @ > C !
	A @ 0   > C ! A @ 1   > C ! A @ 2   > C ! A @ 255 > C !
	0   B @ > C ! 1   B @ > C ! 2   B @ > C ! 255 B @ > C !

	A @ B @ <> C !
	A @ 10  <> C !
	10  B @ <> C !
	A @ 0   <> C ! A @ 1   <> C ! A @ 2   <> C ! A @ 255 <> C !
	0   B @ <> C ! 1   B @ <> C ! 2   B @ <> C ! 255 B @ <> C !
;

: MAIN
	T_ALLOCATE T_ARITHM T_BITS T_COMPARE
; MAIN
