INCLUDE< stack.f>
INCLUDE< other.f>
INCLUDE< memory.f>

DVARIABLE EMIT-WORD
DVARIABLE TYPE-WORD
DVARIABLE PTYPE-WORD
DVARIABLE KEY-WORD
DVARIABLE GOTO-LINE-COL-WORD
DVARIABLE CURSOR-ON-WORD
DVARIABLE CURSOR-OFF-WORD

126 CONSTANT NL-CHAR
124 CONSTANT FF-CHAR

: FAKE-KEY ( --> 0 ) 0 ;

: EMIT ( b --> ) EMIT-WORD EXECUTE ; INLINE

: NEW-LINE ( --> ) NL-CHAR EMIT ; INLINE

: PAGE ( --> ) FF-CHAR EMIT ; INLINE

: CLS ( --> ) FF-CHAR EMIT ; INLINE

: (TYPE) ( b un --> )
  ROT 1- 0 
  DO
    DDUP DI D+ @ EMIT
  LOOP ;

: (PTYPE) ( b un --> )
  ROT 1- 0 
  DO
    P@+ EMIT
  LOOP DDROP ;

: TYPE ( b un --> ) TYPE-WORD EXECUTE ; INLINE

: PTYPE ( b un --> ) PTYPE-WORD EXECUTE ; INLINE

: KEY ( --> b ) KEY-WORD EXECUTE ; INLINE

: GOTO-LINE-COL ( b b --> ) GOTO-LINE-COL-WORD EXECUTE ; INLINE

: CURSOR-ON ( --> ) CURSOR-ON-WORD EXECUTE ; INLINE

: CURSOR-OFF ( --> ) CURSOR-OFF-WORD EXECUTE ; INLINE

: FAKE-DROP DROP ;
: FAKE-DDROP DDROP ;

: CHAR-IN-OUT ( --> ) 
  ' FAKE-DROP  EMIT-WORD          D! 
  ' (TYPE)     TYPE-WORD          D!
  ' (PTYPE)    PTYPE-WORD         D!
  ' FAKE-KEY   KEY-WORD           D!
  ' FAKE-DDROP GOTO-LINE-COL-WORD D!
  ' NOTHING    CURSOR-ON-WORD     D!
  ' NOTHING    CURSOR-OFF-WORD    D!
; INIT