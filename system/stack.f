INCLUDE< temps.f>

( STACK WORD )

: DDROP	( w --> ) PRIM DROPWORD ; INLINE

: DDUP	( w --> w w ) PRIM TOP_W0 PRIM PUSH_W0 ; INLINE

: DSWAP	( w1 w2 --> w2 w1 ) S>W S>W-1 W>S W>S-1 ; INLINE

: DOVER	( w1 w2 --> w1 w2 w1 ) S1=W W>S ; INLINE

: DROT	( w1 w2 w3 --> w2 w3 w1 ) 

  S>W S>W-1 S>W-2 W>S-1 W>S W>S-2 ; INLINE

( STACK BYTE )

: DROP	( b --> ) PRIM DROPBYTE ; INLINE

: DUP	( b --> b b ) PRIM TOP_B0 PRIM PUSH_B0 ; INLINE

: SWAP ( b1 b2 --> b2 b1 ) PRIM 2%SWAPBYTE CW>S CW>S-1 ; INLINE

CG" 	ld	temp1l, Y+" (SWAPBYTE:R:0::)

CG" 	ld	temp0l, Y+
	ld	temp1l, Y+" (SWAPBYTE::::)

CG" 	mov	temp1l, temp0l
	ldi	temp0l, low(%0)" (SWAPBYTE:IR::0:)

CG" 	ld	temp1l, Y+
	ldi	temp0l, low(%0)" (SWAPBYTE:I:::)

: OVER	( b1 b2 --> b1 b2 b1 ) CS1=W CW>S ; INLINE

: ROT	( b1 b2 b3 --> b2 b3 b1 ) 
  CS>W CS>W-1 CS>W-2 CW>S-1 CW>S CW>S-2 ; INLINE
  
: -ROT ( a b c --> c a b )
  CS>W   ( a b --> [c in temp0l] )
  CS>W-1 ( a --> [b in temp1l] [c in temp0l] )
  CS>W-2 ( --> [a in temp2l] [b in temp1l] [c in temp0l] )
  CW>S   ( --> c )
  CW>S-2 ( --> c a )
  CW>S-1 ( --> c a b ) ; INLINE

( STACK QUAD )

: QDROP	( qq --> ) PRIM DROPQUAD ; INLINE

: QDUP	( qq --> qq qq ) PRIM TOP_Q0 PRIM PUSH_Q0 ; INLINE

: QSWAP	( qq1 qq2 --> qq2 qq1 ) QS>W QS>W-1 QW>S QW>S-1 ; INLINE

: QOVER	( qq1 qq2 --> qq1 qq2 qq1 ) QS1=W QW>S ; INLINE

: QROT	( qq1 qq2 qq3 --> qq2 qq3 qq1 ) 
  QS>W   ( qq1 qq2 qq3 --> qq1 qq2, qq3 in temp )
  QS>W-1 ( qq1 qq2 --> qq1, qq2 in temp1 )
  QS>W-2 ( qq1 --> , qq1 in temp2 )
  QW>S-1 ( --> qq2 )
  QW>S   ( qq2 --> qq2 qq3 )
  QW>S-2 ( qq2 qq3 --> qq2 qq3 qq1 )
; INLINE
