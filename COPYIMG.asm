       DEF  CPYIMG
*
       REF  PICSRC
       REF  MAPROW,MAPCOL

       COPY 'CONST.asm'

*
* Public:
* Magellan exported the image as a series of Rows.
* In some experiments we want to view it as a series of columns.
* In others we want the series of rows to be two-bit values instead of four-bit.
*
CPYIMG
* Convert Rows to columns
* Let R0 = current column marker
* Let R1 = current char within column
* Let R2 = current destination position
* Let R3 = end of source DATA
* Let R4 = end of first row
       LI   R0,PICSRC
       MOV  R0,R1
       LI   R2,MAPCOL
       MOV  R0,R3
       AI   R3,ROWS*COLS
       MOV  R0,R4
       AI   R4,COLS
* Copy data for current column
CPYCOL MOVB *R1,*R2+
       AI   R1,COLS
       C    R1,R3
       JL   CPYCOL
* Advance to next column
       INC  R0
       MOV  R0,R1
       C    R0,R4
       JL   CPYCOL
*
       RT