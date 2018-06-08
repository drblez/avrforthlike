: SEC-TO-TIME ( q --> qs qm qh )
  60Q Q/MOD 60Q Q/MOD ;
  
: TIME-TO-SEC ( qs qm qh --> q )
  3600Q Q*     ( qs qm qh*3600    )
  QSWAP 60Q Q* ( qs qh*3600 qm*60 )
  Q+ Q+ ;
