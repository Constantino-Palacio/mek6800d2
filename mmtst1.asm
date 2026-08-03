****************************************************
* MEK6800D2 MEMORY TEST I
*
* CONSTANTINO A.PALACIO, 2025-03-08
*
* SYNTAX IS SAME AS JBUG LISTING ON MEK6800D2 MANUAL
* PAGE A1-1
****************************************************
        ORG   $A023
*
****RAM POINTERS
*
INI     FDB   $0000
ACT     FDB   $0000
FIN     FDB   $0200
*
****MAIN PROGRAM
*
        ORG   $A030
INIPG   LDX   INI
        STX   ACT
**LOAD 1ST PATTERN,
**  SAVE IT TO MEMORY
LOOP1   LDA A #$00
        STA A 0,X
**SEE IF WRITTEN CORRECTLY
        CMP A 0,X
        BNE   FINPG
**REPEAT FOR 2ND PATTERN
        LDA A #$FF
        STA A 0,X
        CMP A 0,X
        BNE   FINPG
**CHECK NEXT ADDRESS,
**  SEE IF TEST IS DONE
        INX
        STX   ACT
        CPX   FIN
        BNE   LOOP1
*
****RETURN TO JBUG
*
FINPG   SWI
        END
