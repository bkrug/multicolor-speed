       DEF  COLX1,COLX2
       REF  VDPADR,VDPREG
       REF  MAPCOL
       REF  TSTTIM

       COPY 'CONST.asm'
       COPY 'CPUADR.asm'

PATTBL EQU  >800
MCLRMD EQU  >01E8

*
* Public
* Experiment involving writing 4-bit colors.
* Routine is kept in ROM.
*
COLX1
       DECT R10
       MOV  R11,*R10
* Set to multi-color mode
       LI   R0,MCLRMD
       BL   @VDPREG
*
       BL   @ARGCOL
*
* Write colors
*
       LI   R0,PATTBL
       BL   @VDPADR
* Let R1 = source location from even column
* Let R2 = source location from odd column
* Let R3 = end of column
* Let R4 = VDP write address
* Let R5 = row counter
* Let R6 = end of data
       LI   R1,MAPCOL
       MOV  R1,R2
       AI   R2,ROWS
       MOV  R2,R3
       LI   R4,VDPWD
       LI   R5,ROWS
       MOV  R1,R6
       AI   R6,ROWS*COLS
* Start timer
       BL   @INTTIM
       BL   @GETTIM
       MOV  R7,@TSTTIM
* Write all columns
       BL   @COLLP
* Test done, store time
       BL   @GETTIM
       S    R7,@TSTTIM     
*
       MOV  *R10+,R11
       RT

*
* Public
* Experiment involving writing 4-bit colors.
* Copy the loop to Scratch Pad before runnig it.
*
COLX2
       DECT R10
       MOV  R11,*R10
* Set to multi-color mode
       LI   R0,MCLRMD
       BL   @VDPREG
* Copy routine to Scratch Pad
       LI   R0,COLLP
       LI   R1,>8300
COLX2A MOV  *R0+,*R1+
       CI   R0,COLLP1
       JL   COLX2A
*
       BL   @ARGCOL
*
* Write colors
*
       LI   R0,PATTBL
       BL   @VDPADR
* Let R1 = source location from even column
* Let R2 = source location from odd column
* Let R3 = end of column
* Let R4 = VDP write address
* Let R5 = row counter
* Let R6 = end of data
       LI   R1,MAPCOL
       MOV  R1,R2
       AI   R2,ROWS
       MOV  R2,R3
       LI   R4,VDPWD
       LI   R5,ROWS
       MOV  R1,R6
       AI   R6,ROWS*COLS
* Start timer
       BL   @INTTIM
       BL   @GETTIM
       MOV  R7,@TSTTIM
* Write all columns
       BL   @>8300
* Test done, store time
       BL   @GETTIM
       S    R7,@TSTTIM     
*
       MOV  *R10+,R11
       RT

*
* Private Method:
*
* Write all colors to the pattern table column-by-column
COLLP
* Write two columns to VDP
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       MOVB *R1+,R0
       SLA  R0,4
       AB   *R2+,R0
       MOVB R0,*R4
*
       C    R1,R3
       JL   COLLP
* Advance to next column pair
       A    R5,R1
       A    R5,R2
       MOV  R2,R3
       C    R2,R6
       JL   COLLP
*
       RT
COLLP1       

*
* Private Method:
*
*
* Define Screen Image Table
* such that chars 0-5 are in the left-most column.
* 6-11 are in the next column, etc.
*
ARGCOL
       DECT R10
       MOV  R11,*R10
*
       CLR  R0
       BL   @VDPADR
* Let R1 = char at begging of row
* Let R2 = chars left this row
* Let R3 = rows remaining
       CLR  R1
       LI   R3,24
COLX1A LI   R2,32
* Let R4 = current char
* Let R5 = VDP write address
       MOV  R1,R4
       LI   R5,VDPWD
* Write one row
COLX1B MOVB R4,*R5
       AI   R4,>0600
       DEC  R2
       JNE  COLX1B
* Next row
       DEC  R3
       JEQ  COLX1C
       MOV  R3,R0
* Is the number of remaing rows divisible by 4?
       ANDI R0,3
       JNE  COLX1A
* Yes, add 1 to R1
       AI   R1,>0100
       JMP  COLX1A
*
COLX1C
       MOV  *R10+,R11
       RT

*
* Private Method:
* Initialize Timer
*
INTTIM 
       CLR  R12         CRU base of the TMS9901 
       SBO  0           Enter timer mode 
       LI   R7,>3FFF    Maximum value
       INCT R12         Address of bit 1 
       LDCR R7,14       Load value 
       DECT R12         There is a faster way (see http://www.nouspikel.com/ti99/titechpages.htm) 
       SBZ  0           Exit clock mode, start decrementer 
       RT

*
* Private Method:
* Get Time from CRU
* Output: R2
*
GETTIM CLR  R12 
       SBO  0           Enter timer mode 
       STCR R7,15       Read current value (plus mode bit)
       SBZ  0
       SRL  R7,1        Get rid of mode bit
       ANDI R7,>3FFF
       RT