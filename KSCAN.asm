       DEF  KSCAN
*
       REF  KEYTIM,CURKEY,PRVKEY
       REF  WS

*
* Constants
*
       COPY 'CONST.asm'
       COPY 'CPUADR.asm'

* Amount of time to wait between key repeats
WAIT   DATA 30
NOKEY  BYTE >FF
       EVEN

*
* Public Method:
* Scan Keyboard
*
KSCAN
       DECT R10
       MOV  R11,*R10
* Reduce time to wait before key repeat
       DEC  @KEYTIM
       JGT  KSCAN1
       CLR  @KEYTIM
* Call console Key Scan routine
KSCAN1 LWPI >83E0           can't change WS with BLWP as R13-R15 are in use
       DECT R10             save GPL R11
       MOV  R11,*R10
       BL   @>000E          call keyboard scanning routine
       MOV  *R10+,R11       restore GPL R11
       LWPI WS
* Store scanned key in R2
       MOVB @KEYCOD,R2
* Has any key been pressed?
       CB   R2,@NOKEY
       JEQ  KEYRT       
* Is this the same as previous key?
       CB   R2,@PRVKEY
       JNE  KSCAN2
* Yes, has enough time passed?
       MOV  @KEYTIM,R0
       JNE  KEYRT
* Retain key and mark that it is also the previous key
KSCAN2 MOVB R2,@CURKEY
       MOVB R2,@PRVKEY
* Reset repeat timer and store previous key
       MOV  @WAIT,@KEYTIM

KEYRT
       MOV  *R10+,R11
       RT