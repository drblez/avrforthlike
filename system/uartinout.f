INCLUDE< cinout.f>
INCLUDE< uart.f>
  
: INIT-UART-INOUT 
  ' UART-GETCHAR KEY-WORD  D! 
  ' UART-PUTCHAR EMIT-WORD D! 
; INIT
