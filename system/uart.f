: UART-INIT
  25 UBRRL OUT
  RXEN BV TXEN BV OR UCSRB OUT
  URSEL BV UCSZ1 BV UCSZ0 BV OR OR UCSRC OUT ; INIT
  
: UART-GETCHAR ( --> c )
  BEGIN
    UCSRA IN
  RXC UNTIL-BIT-CLEAR 
  UDR IN ;
  
: UART-PUTCHAR ( c --> )
  DUP NL-CHAR = 
  IF 
    DROP 13 
  ELSE
    FF-CHAR =
    IF
      DROP 12
    THEN
  THEN
  BEGIN
    UCSRA IN
  UDRE UNTIL-BIT-CLEAR
  UDR OUT ;
