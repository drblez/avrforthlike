INCLUDE< memory.f>
INCLUDE< stack.f>
INCLUDE< darithm.f>
INCLUDE< allocate.f>

32 ALLOCATE LOCAL-STACKS
16 ALLOCATE LOCAL-SIZES
DVARIABLE LSP

: INIT-LOCALS 0. LSP D! ; INIT

: LOCALS ( b --> ) 
  DUP          ( b )
  LOCAL-SIZES  ( b addr )
  LSP D@       ( b addr inc )
  D+           ( b addr+inc )
  !            ( b ) 
  GET-MEM      ( addr )
  LOCAL-STACKS ( addr addr )
  LSP D@       ( addr addr inc )
  D+           ( addr addr+inc )
  D!
  LSP D@ D1+ LSP D!
;

: DROP-LOCALS ( --> ) LSP D@ D1- LSP D! LOCAL-SIZES LSP D@ D+ @ FREE-MEM ;

: @@ ( b -- ) S>D LOCAL-STACKS LSP D@ D+ D@ D+ @ ;

: 0@ 0 @@ ;
: 1@ 1 @@ ;
: 2@ 2 @@ ;
: 3@ 3 @@ ;
: 4@ 4 @@ ;
: 5@ 5 @@ ;
: 6@ 6 @@ ;
: 7@ 7 @@ ;
: 8@ 8 @@ ;
: 9@ 9 @@ ;

: !! ( b b -- ) S>D LOCAL-STACKS LSP D@ D+ D@ D+ ! ;

: 0! 0 !! ;
: 1! 1 !! ;
: 2! 2 !! ;
: 3! 3 !! ;
: 4! 4 !! ;
: 5! 5 !! ;
: 6! 6 !! ;
: 7! 7 !! ;
: 8! 8 !! ;
: 9! 9 !! ;
