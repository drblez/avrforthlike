INCLUDE< temps.f>
INCLUDE< memory.f>
INCLUDE< convert.f>

DVARIABLE DP	( ��������� ������� ����� ��᫥ ��� ��६�����,
		  �.�. ��砫� ��� )

: INIT-ALLOCATE ( ���樠������ ��६����� DP )
A"	ldi	temp0l, low(sys_vars_end)
	ldi	temp0h, high(sys_vars_end)"
W>S DP D! ; INIT

: GET-MEM ( b --> addr | �뤥��� � ��� b ���� � �����頥� ���� 
			 �뤥������ ����� ) 
  S>D   ( inc           )
  DP D@ ( inc addr      )
  DDUP  ( inc addr addr )
  DROT  ( addr addr inc )
  D+    ( addr addr+inc )
  DP D! ( addr          )
;

: FREE-MEM ( b --> | ����頥� � ���� b ���� ) 
  S>D	( dec ) 
  DP D@ ( dec addr )
  DSWAP ( addr dec )
  D-    ( addr-dec )
  DP D! 
;
