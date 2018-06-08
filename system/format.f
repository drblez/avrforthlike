INCLUDE< qarithm.f>
INCLUDE< compare.f>
INCLUDE< branch-loops.f>
INCLUDE< memory.f>
INCLUDE< convert.f>
INCLUDE< other.f>

40 ALLOCATE BUF
DVARIABLE HLD
VARIABLE BASE
VARIABLE DPL

: ALPHA ( c1 --> c2 ) DUP 10 < IF C" 0 + ELSE 10 - C" A + THEN ;

: PAD BUF 40. D+ ; INLINE

: BLANK-PAD BUF 40 BLANK ;

: <# ( --> ) PAD HLD D! ; INLINE

: HOLD ( c --> ) HLD D@ D1- HLD D! HLD D@ ! ;

: # ( q1 --> q2 ) BASE @ S>Q QU/MOD QSWAP Q>S ALPHA HOLD ;

: #S ( q --> 0,0,0,0 ) BEGIN # QDUP Q0= UNTIL ;

: #S. ( q --> 0,0,0,0 ) 
  DPL @ >R 
  BEGIN 
    # 
    DPL @ 1- DUP DPL ! 0= 
    IF 
      C" . HOLD 
    THEN 
    QDUP 
  Q0= UNTIL 
  R> DPL ! ;

: #> ( 0,0,0,0 --> c un ) QDROP HLD D@ PAD DOVER D- D>S -ROT ;

: SIGN ( q --> ) Q0< IF 45 HOLD THEN ;

: Q>STR ( q --> c un ) QDUP QABS <# #S QSWAP SIGN #> ;

: Q>STR.R ( c q --> c un ) BLANK-PAD QDUP QABS <# #S QSWAP SIGN QDROP 
  HLD D@ ;

: SET-DPL >R >R >R >R DPL ! R> R> R> R> ;

: Q>STR.F ( c q --> c un ) SET-DPL QDUP QABS <# #S. QSWAP SIGN #> ;

: Q>STR.F.R ( c c q --> c un ) SET-DPL BLANK-PAD 
  QDUP QABS <# #S. QSWAP SIGN QDROP HLD D@ ;
  
: D>STR ( n --> c un ) D>Q Q>STR ; INLINE

: S>STR ( c --> c un ) S>Q Q>STR ; INLINE

: DECIMAL ( --> ) 10 BASE ! ; INLINE

: HEX ( --> ) 16 BASE ! ; INLINE

: OCTAL ( --> ) 8 BASE ! ; INLINE

: SETUP-FORMAT DECIMAL ; INIT
