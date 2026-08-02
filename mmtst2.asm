****************************************************
* MEK6800D2 MEMORY TEST II
*
* CONSTANTINO A.PALACIO, 2025-06-11
*
* SYNTAX IS SAME AS JBUG LISTING ON MEK6800D2 MANUAL
* PAGE A1-1
****************************************************
        ORG   $A030
PRGINI  LDA A #$01    INITIAL PATTERN IS $01
        LDX   #$0000  START ADDRESS IS $0000
CHKLOP  STA A 0,X
        CMP A 0,X
        BNE   PRGFIN  RETURN ON ERROR
        ROLA
        BCC   CHKLOP
        INX
        STX   $A033   PRGINI+3 (SELF-MOD)
        CPX   #$2200  END ADDRESS IS $2200
        BNE   PRGINI
        SWI           RETURN TO JBUG
        END