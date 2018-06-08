INCLUDE< device\m16def.f>
INCLUDE" delay.f"
INCLUDE" beeper.f"
INCLUDE< cinout.f>

PORTD CONSTANT KEY-PORT
DDRD  CONSTANT KEY-DDR
PIND  CONSTANT KEY-PIN
PD4   CONSTANT KEY-1-IN
PD5   CONSTANT KEY-2-IN
PD6   CONSTANT KEY-3-IN

0 CONSTANT NO-KEY-PRESSED
1 CONSTANT KEY-1
2 CONSTANT KEY-2
3 CONSTANT KEY-3
4 CONSTANT KEY-4

KEY-1 CONSTANT KEY-INC
KEY-2 CONSTANT KEY-DEC
KEY-3 CONSTANT KEY-MODE
KEY-4 CONSTANT KEY-SELECT

: KEY-PIN@ KEY-PIN IN ; INLINE

: KEY-1-PRESSED KEY-PIN@ KEY-1-IN ?BIT-IS-CLEAR ; INLINE
: KEY-2-PRESSED KEY-PIN@ KEY-2-IN ?BIT-IS-CLEAR ; INLINE
: KEY-3-PRESSED KEY-PIN@ KEY-3-IN ?BIT-IS-CLEAR ; INLINE

: GET-KEY ( --> key-no )
  KEY-1-PRESSED
  KEY-2-PRESSED
  KEY-3-PRESSED
  OR OR
  IF
    20 BEEP-MS
    KEY-1-PRESSED IF KEY-1 RETURN THEN
    KEY-2-PRESSED IF KEY-2 RETURN THEN
    KEY-3-PRESSED 
    IF
       250 DELAY-MS
       KEY-3-PRESSED IF KEY-4 RETURN THEN
       KEY-3
    THEN
  ELSE
    NO-KEY-PRESSED
  THEN
;

: KEY-INIT ' GET-KEY KEY-WORD D! ; INIT