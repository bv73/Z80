        ORG     #8000
;
        LD      IX,WINDOW0
        CALL    OPENWIN
        LD      HL,WINTXT0
        LD      DE,#051C
        LD      B,6
        CALL    INPUTLINE
        JP      NC,NOERR
        LD      IX,WINDOW1
        CALL    OPENWIN
CW1
        CALL    PAK
        CALL    CLOSEWIN
        CALL    CLOSEWIN
        RET
NOERR
        LD      IX,WINDOW2
        CALL    OPENWIN
        JP      CW1
WINDOW0
        DEFW    #040E   ;YX
        DEFW    #0118   ;dYdX
        DEFB    (8*1)+7+64 ;Color
        DEFW    AWIN0   ;Adr Zag
        DEFB    "Select Area: "
WINTXT0 DEFB    0
        DEFB    "                 ",0
AWIN0   DEFB    " SELECT ",0
WINDOW1 DEFW    #0710
        DEFW    #0110
        DEFB    (8*1)+6
        DEFW    AWIN1
        DEFB    " Illegal Input ",0
AWIN1   DEFB    " ERROR! ",0
WINDOW2 DEFW    #0000
        DEFW    #0316
        DEFB    7
        DEFW    AWIN2
        DEFB    0
AWIN2   DEFB    " Tokens ",0
;************
PAK
        XOR     A
        LD      (23560),A
PAKL    LD      A,(23560)
        AND     A
        JP      Z,PAKL
        RET
;==================
INPUTLINE
        XOR     A
        LD      (23560),A
        LD      (23672),A
        LD      (23558),A
        LD      (FLAGCUR),A
        LD      (TAD_IN),HL
        LD      (FOR_KRD),DE
        LD      A,B
        DEC     A
        LD      (MAX_LEN),A
        PUSH    HL
LP_NU
        LD      A,(HL)
        AND     A
        JP      Z,NUNU1
        INC     HL
        JP      LP_NU
NUNU1
        POP     DE
        AND     A
        SBC     HL,DE
        LD      A,L
        AND     A
        JP      Z,NOTXT100
        LD      B,H
        LD      C,L
        EX      DE,HL
        LD      DE,BUF_IN
        LDIR
NOTXT100
        LD      (MAXOTST),A
        LD      (OTSTUP),A
        CALL    PRI_INP
        LD      A,(TMPX)
        LD      (CURX),A
INP_MAIN
        LD      A,(23558)
        CP      35
        JP      NZ,NOPRESS
        XOR     A
        LD      (23558),A
        LD      A,(23560)
        CP      7       ;ESC
        JP      NZ,NOESC_
        CALL    RES_CUR
        CALL    PRI_SP
        CALL    COORDIN
        LD      HL,0
TAD_IN  EQU     $-2
        CALL    FASTP
        SCF
        RET
NOESC_
        CP      8       ;LEFT
        JP      NZ,NOLEF_
;EFT_
        LD      A,0
OTSTUP  EQU     $-1
        AND     A
        JP      Z,INP_MAIN
        DEC     A
        LD      (OTSTUP),A
        CALL    RES_CUR
        LD      HL,CURX
        DEC     (HL)
        JP      INP_MAIN
NOLEF_
        CP      9       ;RIGHT
        JP      NZ,NORIG_
RIGHT_
        LD      A,(OTSTUP)
        CP      0
MAXOTST EQU     $-1
        JP      Z,INP_MAIN
        INC     A
        LD      (OTSTUP),A
        CALL    RES_CUR
        LD      HL,CURX
        INC     (HL)
        JP      INP_MAIN
NORIG_
        CP      6       ;INSERT
        JP      NZ,NOINSERT_
        CALL    RES_CUR
        LD      A,(MAX_LEN)
        LD      HL,MAXOTST
        CP      (HL)
        JP      Z,INP_MAIN
        LD      A,(OTSTUP)
        LD      C,A
        LD      B,0
        LD      HL,BUF_IN
        ADD     HL,BC
        LD      A,63
        SUB     C
        LD      C,A
        ADD     HL,BC
        DEC     HL
        LD      E,L
        LD      D,H
        INC     DE
        LDDR
        INC     HL
        LD      (HL)," "
        LD      HL,MAXOTST
        INC     (HL)
        CALL    PRI_INP
        JP      INP_MAIN
NOINSERT_
        CP      10      ;DOWN
        JP      Z,INP_MAIN
        CP      11      ;UP
        JP      Z,INP_MAIN
        CP      4       ;CS+3
        JP      Z,INP_MAIN
        CP      5       ;CS+4
        JP      Z,INP_MAIN
        CP      15      ;GRAPH
        JP      NZ,NOSW_
        CALL    RES_CUR
        LD      A,(OTSTUP)
        LD      HL,MAXOTST
        CP      (HL)
        JP      NZ,SWAP1
        LD      C,A
        LD      B,0
        LD      HL,BUF_IN
        ADD     HL,BC
        LD      (HL),0
        JP      SWAP_END
SWAP1
        LD      A,(OTSTUP)
        LD      C,A
        LD      B,0
        LD      HL,BUF_IN
        ADD     HL,BC
        LD      E,L
        LD      D,H
        INC     HL
        LD      A,63
        SUB     C
        LD      C,A
        LDIR
        LD      HL,MAXOTST
        DEC     (HL)
SWAP_END
        CALL    PRI_SP
        CALL    PRI_INP
        JP      INP_MAIN
NOSW_
        CP      12      ;DELETE
        JP      NZ,NODEL_
        CALL    RES_CUR
        LD      A,(OTSTUP)
        AND     A
        JP      Z,INP_MAIN
        DEC     A
        LD      (OTSTUP),A
        LD      HL,CURX
        DEC     (HL)
        LD      A,(OTSTUP)
        LD      C,A
        LD      B,0
        LD      HL,BUF_IN
        ADD     HL,BC
        LD      A," "
        LD      (HL),A
        CALL    PRI_INP
        JP      INP_MAIN
NODEL_
        CP      13      ;ENTER
        JP      NZ,NOENTER_
        CALL    RES_CUR
        CALL    PRI_INP
        LD      A,(MAXOTST)
        AND     A
        RET
NOENTER_
        LD      E,A
        LD      A,(OTSTUP)
        LD      C,A
        LD      B,0
        LD      HL,BUF_IN
        ADD     HL,BC
        LD      A,(HL)
        LD      (HL),E
        AND     A
        JP      Z,INP_W
        LD      HL,MAXOTST
        LD      A,(OTSTUP)
        CP      (HL)
        JP      NZ,INP_1
INP_W
        LD      HL,OTSTUP
        LD      A,0
MAX_LEN EQU     $-1
        CP      (HL)
        JP      Z,INP_1
INP_0
        LD      HL,MAXOTST
        INC     (HL)
INP_1
        CALL    RES_CUR
        CALL    PRI_INP
        JP      RIGHT_
NOPRESS
        LD      A,(23672)
        CP      10
        JP      NZ,INP_MAIN
        XOR     A
        LD      (23672),A
        CALL    CURSOR
        JP      INP_MAIN
RES_CUR
        LD      A,(FLAGCUR)
        AND     A
        RET     Z
CURSOR
        LD      A,0
FLAGCUR EQU     $-1
        XOR     1
        LD      (FLAGCUR),A
        LD      A,0
CURX    EQU     $-1
        LD      C,A
        SRL     A
        LD      HL,(FOADRS)
        ADD     A,L
        LD      L,A
        LD      A,C
        RRA
        LD      B,#0F
        JP      C,NOCHCUR
        LD      B,#F0
NOCHCUR
        LD      A,(HL)
        XOR     B
        LD      (HL),A
        INC     H
        LD      A,(HL)
        XOR     B
        LD      (HL),A
        INC     H
        LD      A,(HL)
        XOR     B
        LD      (HL),A
        INC     H
        LD      A,(HL)
        XOR     B
        LD      (HL),A
        INC     H
        LD      A,(HL)
        XOR     B
        LD      (HL),A
        INC     H
        LD      A,(HL)
        XOR     B
        LD      (HL),A
        INC     H
        LD      A,(HL)
        XOR     B
        LD      (HL),A
        INC     H
        LD      A,(HL)
        XOR     B
        LD      (HL),A
        RET
PRI_SP
        CALL    COORDIN
        LD      A,(MAX_LEN)
        INC     A
        LD      B,A
PRI_SP1
        PUSH    BC
        LD      A," "
        CALL    PRIA
        POP     BC
        DJNZ    PRI_SP1
        RET
PRI_INP
        CALL    COORDIN
        LD      HL,BUF_IN
        JP      FASTP
COORDIN
        LD      DE,0
FOR_KRD EQU     $-2
        LD      A,D
        LD      (TMPY),A
        LD      A,E
        LD      (TMPX),A
        JP      KOOR_Y
BUF_IN  DEFS    64
;==================
PUTSP
;HL=XY BC=dXdY
        PUSH    HL
        PUSH    BC
        PUSH    HL
        LD      HL,TMP_W
FOR_ATW EQU     $-2
        LD      DE,#C000
FOR_ASP EQU     $-2
        LD      (HL),E ;ADR Spr
        INC     HL
        LD      (HL),D
        INC     HL
        POP     BC
        LD      (HL),C  ;XY
        INC     HL
        LD      (HL),B
        INC     HL
        POP     BC
        LD      (HL),C  ;dXdY
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (FOR_ATW),HL
        POP     HL
        LD      (F_ATT1),HL
        LD      (F_ATT2),BC
PUT
        PUSH    BC
        PUSH    HL
        CALL    ADRS
        LD      B,8
PUT_Y
        PUSH    BC
        PUSH    HL
PUT_X
        LDI
        LD      A,C
        AND     A
        JP      NZ,PUT_X
        POP     HL
        INC     H
        POP     BC
        DJNZ    PUT_Y
        POP     HL
        INC     H       ;Y+
        POP     BC
        DJNZ    PUT
        LD      HL,0
F_ATT1  EQU     $-2
        LD      A,L
        LD      L,H
        LD      H,0
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     A,L
        LD      L,A
        LD      BC,#5800
        ADD     HL,BC
;Adr Attr
        LD      A,L
        LD      (DE),A
        INC     DE
        LD      A,H
        LD      (DE),A
        INC     DE
;
        LD      BC,0
F_ATT2  EQU     $-2
COLPUT0
        PUSH    BC
        PUSH    HL
COLPUT1
        LD      A,(HL)
        LD      (DE),A
        INC     DE
        INC     HL
        DEC     C
        JR      NZ,COLPUT1
        POP     HL
        LD      BC,32
        ADD     HL,BC
        POP     BC
        DJNZ    COLPUT0
        LD      (FOR_ASP),DE
        RET
;----------------------
CLOSEWIN
        LD      HL,(FOR_ATW)
        LD      BC,6
        AND     A
        SBC     HL,BC
        LD      (FOR_ATW),HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        LD      (FOR_ASP),DE
        INC     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        PUSH    BC
        INC     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        LD      (F_ATT0),BC
        POP     HL
GET
        PUSH    BC
        PUSH    HL
        CALL    ADRS
        EX      DE,HL   ;DE-SCR
        LD      B,8
GET_Y
        PUSH    BC
        PUSH    DE
GET_X
        LDI
        LD      A,C
        AND     A
        JP      NZ,GET_X
        POP     DE
        INC     D
        POP     BC
        DJNZ    GET_Y
        EX      DE,HL
        POP     HL
        INC     H       ;Y+
        POP     BC
        DJNZ    GET
        EX      DE,HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      BC,0
F_ATT0  EQU     $-2
        EX      DE,HL
COLGET0
        PUSH    BC
        PUSH    HL
COLGET1
        LD      A,(DE)
        LD      (HL),A
        INC     DE
        INC     HL
        DEC     C
        JR      NZ,COLGET1
        POP     HL
        LD      BC,32
        ADD     HL,BC
        POP     BC
        DJNZ    COLGET0
        RET
ADRS
        LD      A,L
        EX      AF,AF'
        LD      A,H
        LD      H,TABSCR/256
        ADD     A,A
        LD      L,A
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        EX      AF,AF'
        ADD     A,L
        LD      L,A
        RET
;++++++++++++++++++++++++++++++++
OPENWIN
        LD      L,(IX)        ;X
        SRA     L
        LD      H,(IX+1)
        LD      C,(IX+2)        ;DX
        SRA     C
        INC     C
        LD      B,(IX+3)
        INC     B
        INC     B
        CALL    PUTSP
        PUSH    IX
        POP     HL
        LD      BC,7
        ADD     HL,BC
        LD      (ADRTWI),HL
        LD      A,(IX)
        LD      (TMPX),A
        LD      A,(IX+1)
        LD      (TMPY),A
        CALL    KOOR_Y
        LD      A,#C9
        CALL    PRIA
        LD      B,(IX+2)
PRIX1
        PUSH    BC
        LD      A,#CD
        CALL    PRIA
        POP     BC
        DJNZ    PRIX1
        LD      A,#BB
        CALL    PRIA
;
        LD      B,(IX+3)        ;DY
        LD      C,1
LP_YY
        PUSH    BC
        LD      A,(IX)        ;X
        LD      (TMPX),A
        LD      A,(IX+1)        ;Y
        ADD     A,C
        LD      (TMPY),A
        CALL    KOOR_Y
        LD      A,#BA
        CALL    PRIA
;
        XOR     A               ;Res Enter
        LD      (FOR13),A
        LD      B,(IX+2)        ;DX
LP_XX
        PUSH    BC
        LD      A,0
FOR13   EQU     $-1
        AND     A
        JR      NZ,PRISPC0
        LD      HL,0
ADRTWI  EQU     $-2
        LD      A,(HL)
        CP      13
        CALL    Z,SET13
        AND     A
        JP      NZ,PRISPC
PRISPC0
        LD      A," "
        JP      PRISPC1
PRISPC
        INC     HL
        LD      (ADRTWI),HL
PRISPC1
        CALL    PRIA
        POP     BC
        DJNZ    LP_XX
;
        LD      A,#BA
        CALL    PRIA
        POP     BC
        INC     C
        DJNZ    LP_YY

        LD      A,(IX)        ;X
        LD      (TMPX),A
        LD      A,(IX+1)        ;Y
        ADD     A,C
        LD      (TMPY),A
        CALL    KOOR_Y
        LD      A,#C8
        CALL    PRIA
        LD      B,(IX+2)
PRIX2
        PUSH    BC
        LD      A,#CD
        CALL    PRIA
        POP     BC
        DJNZ    PRIX2
        LD      A,#BC
        CALL    PRIA
;'''COLOR
        LD      H,0
        LD      L,(IX+1)
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        LD      A,(IX)
        SRA     A
        ADD     A,L
        LD      L,A
        LD      BC,#5800
        ADD     HL,BC
        LD      A,(IX+4)        ;Color
        LD      C,(IX+2)        ;DX
        SRA     C
        INC     C
        LD      B,(IX+3)
        INC     B
        INC     B

COLL0
        PUSH    BC
        PUSH    HL
COLL1
        LD      (HL),A
        INC     HL
        DEC     C
        JR      NZ,COLL1
        POP     HL
        LD      BC,32
        ADD     HL,BC
        POP     BC
        DJNZ    COLL0
;''''Print Zag
        LD      A,(IX+6)
        AND     A
        RET     Z
        LD      H,A
        LD      L,(IX+5)
        LD      (FOR_ZAG),HL
        LD      C,0
LOOPZAG
        LD      A,(HL)
        AND     A
        JP      Z,ENDZAG
        INC     HL
        INC     C
        JP      LOOPZAG
ENDZAG
        LD      A,(IX+1)
        LD      (TMPY),A
        LD      A,(IX+2)
        SBC     A,C
        SRA     A
        LD      B,(IX)
        ADD     A,B
        INC     A
        LD      (TMPX),A
        CALL    KOOR_Y
        LD      HL,0
FOR_ZAG EQU     $-2
LOOPZAG2
        LD      A,(HL)
        AND     A
        RET     Z
        PUSH    HL
        CALL    PRIA
        POP     HL
        INC     HL
        JP      LOOPZAG2
SET13
        INC     HL
        LD      (ADRTWI),HL
        LD      A,1
        LD      (FOR13),A
        DEC     A
        RET
;----------------------
FASTP
        LD      A,(HL)
        AND     A
        RET     Z
        INC     HL
        CP      #16
        JR      Z,SETK
        EXX
        CALL    PRI_A
        EXX
        JP      FASTP
SETK
        CALL    SETKOR
        JP      FASTP
PRI_A
        CP      13
        LD      HL,TMPX
        JP      Z,ENTE
PRIA
        LD      (FOFO),A
        LD      A,0
TMPX    EQU     $-1
        LD      C,A
        SRL     A
        LD      HL,#4000
FOADRS  EQU     $-2
        ADD     A,L
        LD      L,A
        LD      A,C
        RRA
        LD      DE,FONT
FOFO    EQU     $-2
        LD      B,#0F
        JP      C,NOCHET
        LD      B,#F0
NOCHET
        LD      A,(DE)
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        LD      HL,TMPX
        INC     (HL)
        LD      A,63    ;MAX RIGHT (64)
        CP      (HL)
        RET     NC
ENTE
        LD      (HL),0
        LD      HL,TMPY
        INC     (HL)
        LD      A,23    ;MAX LINES (24)
        CP      (HL)
        JR      NC,KOOR_Y
        LD      A,23
        LD      (HL),A
        LD      B,24
        JP      #E00
SETKOR
        LD      A,(HL)          ;Y
        LD      (TMPY),A
        INC     HL
        LD      A,(HL)          ;X
        LD      (TMPX),A
        INC     HL
        EX      DE,HL
KOOR_Y
        LD      H,TABSCR/256
        LD      A,0
TMPY    EQU     $-1
        ADD     A,A
        LD      L,A
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        LD      (FOADRS),HL
        EX      DE,HL
        RET
;----------------------
E_O_F
        ORG     #A000
TABSCR
        DEFW    #4000,#4020,#4040,#4060,#4080,#40A0
        DEFW    #40C0,#40E0,#4800,#4820,#4840,#4860
        DEFW    #4880,#48A0,#48C0,#48E0,#5000,#5020
        DEFW    #5040,#5060,#5080,#50A0,#50C0,#50E0
TMP_W   DEFS    128
        ORG     #A800
FONT
;       .INCBIN FONT
        .RUN    #8000
