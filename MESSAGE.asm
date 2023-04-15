       DEF  SHOW0,SHOW1,SHOW2
       REF  VDPADR,VDPREG
       REF  GROMCR
       REF  DECNUM,TSTTIM

       COPY 'CPUADR.asm'

TEXTMD EQU  >01F0
*
TEN    DATA 10
CHRZRO BYTE '0',0

*
* Public:
* Show message explaining program
*
SHOW0
       DECT R10
       MOV  R11,*R10
* Set to text mode
       LI   R0,TEXTMD
       BL   @VDPREG
       BL   @GROMCR              Copy pattern definitions from GROM to VRAM
       BL   @CLRSRC       
*
       LI   R0,0
       LI   R1,MSG0A
       BL   @PRTMSG
*
       LI   R0,3*40
       LI   R1,MSG0B
       BL   @PRTMSG
*
       LI   R0,6*40
       LI   R1,MSG0C
       BL   @PRTMSG
*
       MOV  *R10+,R11
       RT

MSG0A  TEXT 'Assume that the 3K of RAM is reserved   '
       TEXT 'for storing MultiColor mode colors. (One'
       TEXT 'byte for every box.)'
       BYTE 0
MSG0B  TEXT 'What is the fastest way to compress it  '
       TEXT 'to 1.5K and write it to VDP RAM?'
       BYTE 0
MSG0C  TEXT 'Press any key for first experiment'
       BYTE 0

*
* Public:
* Show results of first test
*
SHOW1
       DECT R10
       MOV  R11,*R10
* Set to text mode
       LI   R0,TEXTMD
       BL   @VDPREG
       BL   @GROMCR              Copy pattern definitions from GROM to VRAM
       BL   @CLRSRC
*
       LI   R0,0
       LI   R1,MSG1A
       BL   @PRTMSG
*
       MOV  @TSTTIM,R0
       BL   @NUMASC
*
       LI   R0,2*40
       LI   R1,DECNUM
       BL   @PRTMSG
*
       MOV  *R10+,R11
       RT

MSG1A  TEXT 'When drawing columns and routine is in  '
       TEXT 'cartridge ROM, took this many ticks'
       BYTE 0

*
* Public:
* Show results of first test
*
SHOW2
       DECT R10
       MOV  R11,*R10
* Set to text mode
       LI   R0,TEXTMD
       BL   @VDPREG
       BL   @GROMCR              Copy pattern definitions from GROM to VRAM
       BL   @CLRSRC
*
       LI   R0,0
       LI   R1,MSG2A
       BL   @PRTMSG
*
       MOV  @TSTTIM,R0
       BL   @NUMASC
*
       LI   R0,2*40
       LI   R1,DECNUM
       BL   @PRTMSG
*
       MOV  *R10+,R11
       RT

MSG2A  TEXT 'When drawing columns and routine is in  '
       TEXT 'scratch pad RAM, took this many ticks'
       BYTE 0

*
* Private:
* Write a message to VDP RAM
*
* Input:
*  R0 = destination address
*  R1 = Message address
*
PRTMSG
       DECT R10
       MOV  R11,*R10
* Set VDP address
       BL   @VDPADR
* Write bytes to VDPRAM until null terminator found
       LI   R2,VDPWD
PRT1   MOVB *R1+,R3
       JEQ  PRTRT
       MOVB R3,*R2
       JMP  PRT1
*
PRTRT  MOV  *R10+,R11
       RT

*
* Private:
* Clear Screen
*
CLRSRC
       DECT R10
       MOV  R11,*R10
*
       CLR  R0
       BL   @VDPADR
*
       LI   R1,>2000
       LI   R2,VDPWD
       LI   R3,24*40
CLR1   MOVB R1,*R2
       DEC  R3
       JNE  CLR1
*
       MOV  *R10+,R11
       RT

*
* Private Method:
* Convert a 16-bit number to ASCII decimal number
* Ouput is in DECNUM
*
* Input:
*   R0 - Number to convert
* Ouput:
*   R1,R2,R3
* 
NUMASC
       CLR  R1
       MOV  R0,R2
       LI   R3,DECNUM
       AI   R3,5
* Place nul terminator in position 0
       SB   *R3,*R3
       DEC  R3
* Keep dividing by ten and putting remainder in a char position
DSPN1  DIV  @TEN,R1
       SLA  R2,8
       AB   @CHRZRO,R2
       MOVB R2,*R3
       DEC  R3
       MOV  R1,R2
       CLR  R1
       CI   R3,DECNUM
       JHE  DSPN1
       RT