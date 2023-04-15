       DEF  BEGIN
*
       REF  STACK,WS,CURSTP,CURKEY          Ref from VAR
       REF  KSCAN                           Ref from KSCAN
       REF  CPYIMG
       REF  SHOW0,SHOW1,SHOW2               Ref from MESSAGE
       REF  COLX1,COLX2                     Ref from VWRITE

********@*****@*********************@**************************
*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
* Since this header is not absolutely positioned at >6000,
* it is important to include '-a ">6000"' in the xas99.py
* command when linking files into a cartridge.
       BYTE  >AA,1,1,0,0,0
       DATA  PROG1
       BYTE  0,0,0,0,0,0,0,0      
*
PROG1  DATA  0
       DATA  BEGIN
       BYTE  P1MSGE-P1MSG
P1MSG  TEXT  'MULTICOLOR SPEED TEST'
P1MSGE
       EVEN
       
*
* Addresses
*
       COPY 'CPUADR.asm'

*
* Runable code
*
BEGIN
       LWPI WS
       LI   R10,STACK
*
* Variable initialization routines
*
       BL   @CPYIMG              Transform image to be suitable for test
       CLR  @CURSTP
       BL   @SHOW0

*
* Wait
*
* Let R0 = most recently read VDP time
WAIT   MOVB @VINTTM,R0
* Turn on VDP interrupts
       LIMI 2
* Wait for VDP interupt
WAITLP CB   @VINTTM,R0
       JEQ  WAITLP
* Turn off interrupts so we can write to VDP
       LIMI 0      
*
* Game Loop
*
GAMELP
* Scan keyboard
       BL   @KSCAN
* Do next step if neccessary
       BL   @NXTSTP
* Repeat
       JMP  WAIT

*
* Private:
*
NXTSTP
       DECT R10
       MOV  R11,*R10
* Has a key been pressed?
       MOVB @CURKEY,R0
       JEQ  NXTRT
* Yes, clear it
NXTS1  SB   @CURKEY,@CURKEY
* Advance to next step
       INC  @CURSTP
* Get address of step's routine
       MOV  @CURSTP,R0
       SLA  R0,1
       AI   R0,STEPS
* If this was last step, return
       CI   R0,STPEND
       JL   NXTS2
* Restart Loop
       CLR  @CURSTP
       LI   R0,STEPS
* Branch to step routine
NXTS2  MOV  *R0,R0
       BL   *R0
*
NXTRT
       MOV  *R10+,R11
       RT

STEPS  DATA SHOW0,COLX1,SHOW1,COLX2,SHOW2
STPEND