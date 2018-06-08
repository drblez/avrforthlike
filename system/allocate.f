INCLUDE< temps.f>
INCLUDE< memory.f>
INCLUDE< convert.f>

DVARIABLE DP	( Свободная область памяти после всех переменных,
		  т.е. начало кучи )

: INIT-ALLOCATE ( Инициализация переменной DP )
A"	ldi	temp0l, low(sys_vars_end)
	ldi	temp0h, high(sys_vars_end)"
W>S DP D! ; INIT

: GET-MEM ( b --> addr | Выделяет в куче b байт и возвращает адрес 
			 выделенной памяти ) 
  S>D   ( inc           )
  DP D@ ( inc addr      )
  DDUP  ( inc addr addr )
  DROT  ( addr addr inc )
  D+    ( addr addr+inc )
  DP D! ( addr          )
;

: FREE-MEM ( b --> | Возращает в кучу b байт ) 
  S>D	( dec ) 
  DP D@ ( dec addr )
  DSWAP ( addr dec )
  D-    ( addr-dec )
  DP D! 
;
