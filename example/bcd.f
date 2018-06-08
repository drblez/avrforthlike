: 4>> $F0 AND SWAP-NIB ; INLINE

: 4<< $0F AND SWAP-NIB ; INLINE

: BYTE-TO-BCD ( c --> bcd ) 10 /MOD 4<< + ;

: BCD-TO-BYTE ( bcd --> c ) DUP $0F AND SWAP 4>> 10 * + ;

: BCD-INC ( bcd --> bcd+1 ) BCD-TO-BYTE 1+ BYTE-TO-BCD ;

: BCD-DEC ( bcd --> bcd+1 ) BCD-TO-BYTE 1- BYTE-TO-BCD ;


