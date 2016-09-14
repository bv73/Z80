        ORG     #7800
;--------------------------
BUFSPRT EQU     #A000
TABUD   EQU     BUFDOS2+#100
FONT    EQU     #8500
TABECR  EQU     FONT+#800
BUFDOS  EQU     TABECR+#100
BUFDOS2 EQU     BUFDOS+#800
;----------------------------
        DISPLAY BUFDOS-#7800

        DI
        XOR     A
        OUT     (#FE),A
        LD      HL,#4000
        LD      DE,#4001
        LD      BC,#17FF
        LD      (HL),A
        LDIR
        INC     HL
        INC     DE
        LD      BC,#2FF
        LD      (HL),7
        LDIR
MAIN_M
        LD      HL,TABUD
        LD      (FTABUD),HL
        LD      IX,WINMAIN
        CALL    OPENWIN
        CALL    PAK_EN
        CALL    CLOSEWIN
MAIN
        CALL    SLCFILE
        JR      C,MAIN_M
        LD      L,A
        LD      A,(MARKFIL)
        AND     A
        JR      Z,MAIN0
MAIN000 LD      HL,0
FTABUD  EQU     $-2
MAIN00  LD      A,(HL)
        INC     HL
        CP      " "
        JR      Z,MAIN00
        LD      (FTABUD),HL
        LD      A,(MARKFIL)
        DEC     A
        LD      (MARKFIL),A
        DEC     L
MAIN0   LD      A,L
        LD      (FIRFIL),A
        CALL    SEARCHF
        PUSH    IX
        POP     HL
        LD      DE,23773
        LD      BC,9
        LDIR
        LD      C,10
        CALL    DOS
        JR      C,MAIN_M
        BIT     7,C
        JR      NZ,MAIN_M
        LD      A,C
        LD      C,8
        CALL    DOS
        JR      C,MAIN_M
        LD      IX,WIDOSNAM
        CALL    OPENWIN
        LD      HL,#594D
        LD      BC,#615
        CALL    FILLATR
        LD      L,#56
        LD      B,3
        CALL    FILLATR
        LD      L,#6D
        LD      B,6
        CALL    FILLATR
        LD      L,#76
        LD      B,3
        CALL    FILLATR
        LD      DE,#A1A
        LD      A,(#5CE5)
        CALL    PRIFIL
        LD      HL,(#5CE8)
        LD      DE,#A2C
        CALL    DECIMAL
        CALL    CLSBUF
        CALL    CONVERT
        CALL    CLOSEWIN
        JP      C,MAIN_E
        LD      A,(MARKFIL)
        AND     A
        JP      Z,MAIN_M
        JP      MAIN000
MAIN_E  LD      IX,WIDOS_E
        CALL    OPENWIN
        CALL    PAK_EN
        CALL    CLOSEWIN
        JP      MAIN_M
CLSBUF  XOR     A
CLSB    PUSH    AF
        CALL    SETPAGE_HL
        LD      HL,#C000
        LD      DE,#C001
        LD      BC,#3FFF
        LD      (HL),L
        LDIR
        POP     AF
        INC     A
        CP      3
        JR      NZ,CLSB
        RET
PRIFIL
        PUSH    AF
        LD      HL,23773
        LD      B,8
        CALL    PRI_B
        LD      HL,_MPX
        INC     (HL)
        LD      A,"<"
        CALL    _RIA
        POP     AF
        CALL    _RIA
        LD      A,">"
        JP      _RIA
CONVERT
        CALL    LOAD_TX
        RET     C
        LD      HL,0
        LD      DE,0
MLOOP
        CALL    SETP_HL
        PUSH    HL
        LD      HL,(ADRHL)
        LD      A,(HL)
        POP     HL
        AND     A
        JP      Z,SAVE_TX
        CP      #0D
        JR      Z,VERI0A
        CP      #0A
        JR      Z,VERI0D
        CALL    SETP_DE
        PUSH    DE
        LD      DE,(ADRDE)
        LD      (DE),A
        POP     DE
        INC     HL
        INC     DE
        JP      MLOOP
VERI0A
        CALL    SETP_DE
        PUSH    DE
        LD      DE,(ADRDE)
        LD      (DE),A
        POP     DE
        INC     DE
        INC     HL
        CALL    SETP_HL
        PUSH    HL
        LD      HL,(ADRHL)
        LD      A,(HL)
        POP     HL
        CP      #0A
        JR      NZ,WSTAW0A
        CALL    SETP_DE
        PUSH    DE
        LD      DE,(ADRDE)
        LD      (DE),A
        POP     DE
        INC     HL
        INC     DE
        JP      MLOOP
WSTAW0A
        EX      AF,AF'
        LD      A,#0A
        CALL    SETP_DE
        PUSH    DE
        LD      DE,(ADRDE)
        LD      (DE),A
        POP     DE
        INC     DE
        EX      AF,AF'
        CALL    SETP_DE
        PUSH    DE
        LD      DE,(ADRDE)
        LD      (DE),A
        POP     DE
        INC     HL
        INC     DE
        JP      MLOOP
VERI0D
        EX      AF,AF'
        LD      A,#0D
        CALL    SETP_DE
        PUSH    DE
        LD      DE,(ADRDE)
        LD      (DE),A
        POP     DE
        INC     DE
        EX      AF,AF'
        CALL    SETP_DE
        PUSH    DE
        LD      DE,(ADRDE)
        LD      (DE),A
        POP     DE
        INC     DE
        INC     HL
        JP      MLOOP
SETP_HL
        PUSH    BC
        PUSH    HL
        PUSH    DE
        PUSH    AF
        LD      A,H
        RLCA
        RLCA
        AND     3
        PUSH    HL
        LD      HL,TABHL
        LD      C,A
        LD      B,0
        ADD     HL,BC
        LD      A,(HL)
        LD      BC,#7FFD
        OUT     (C),A
        POP     HL
        LD      A,H
        AND     #3F
        OR      #C0
        LD      H,A
        POP     AF
        LD      (ADRHL),HL
        POP     DE
        POP     HL
        POP     BC
        RET
SETP_DE
        PUSH    BC
        PUSH    HL
        PUSH    DE
        PUSH    AF
        LD      A,D
        RLCA
        RLCA
        AND     3
        LD      HL,TABDE
        LD      C,A
        LD      B,0
        ADD     HL,BC
        LD      A,(HL)
        LD      BC,#7FFD
        OUT     (C),A
        LD      A,D
        AND     #3F
        OR      #C0
        LD      D,A
        POP     AF
        LD      (ADRDE),DE
        POP     DE
        POP     HL
        POP     BC
        RET
SETPAGE_HL
        PUSH    HL
        PUSH    AF
        PUSH    BC
        LD      HL,TABHL
        LD      C,A
        LD      B,0
        ADD     HL,BC
        LD      A,(HL)
        LD      BC,#7FFD
        OUT     (C),A
        POP     BC
        POP     AF
        POP     HL
        RET
SETPAGE_DE
        PUSH    HL
        PUSH    AF
        PUSH    BC
        LD      HL,TABDE
        LD      C,A
        LD      B,0
        ADD     HL,BC
        LD      A,(HL)
        LD      BC,#7FFD
        OUT     (C),A
        POP     BC
        POP     AF
        POP     HL
        RET
LOAD_TX LD      A,(#5CEA)
        OR      A
        JP      Z,LOAD_ER
        CP      192
        JP      NC,LOAD_ER
        LD      B,A
        LD      HL,(#5CEB)
        LD      (#5CF4),HL
        XOR     A
        CALL    SETPAGE_HL
        LD      C,A
LOAD_T2 LD      A,B
        SUB     64
        JR      C,LOAD_T3
        LD      B,A
        PUSH    BC
        LD      BC,#4005
        LD      DE,(#5CF4)
        LD      HL,#C000
        CALL    DOS
        POP     BC
        RET     C
        INC     C
        LD      A,C
        CALL    SETPAGE_HL
        JR      LOAD_T2
LOAD_T3 LD      A,B
        AND     A
        RET     Z
        LD      C,5
        LD      DE,(#5CF4)
        LD      HL,#C000
        JP      DOS
LOAD_ER SCF
        RET
SAVE_TX LD      A,D
        OR      E
        JR      Z,LOAD_ER
        PUSH    DE
        EX      DE,HL
        LD      DE,#B2C
        CALL    DECIMAL
        LD      DE,#B1A
        LD      A,"+"
        CALL    PRIFIL
        LD      BC,#105
        LD      DE,8
        LD      HL,BUFDOS2
        CALL    DOS
        POP     DE
        RET     C
        LD      (23784),DE
        LD      A,E
        AND     A
        JR      Z,$+3
        INC     D
        LD      A,D
        LD      (#5CEA),A
        LD      E,D
        LD      D,0
        LD      HL,(BUFDOS2+#E5)
        OR      A
        SBC     HL,DE
        RET     C
        LD      (BUFDOS2+#E5),HL

        LD      A,(BUFDOS2+#E4)
        CP      127
        JP      NC,LOAD_ER
        INC     A
        LD      (BUFDOS2+#E4),A

        LD      HL,(BUFDOS2+#E1)
        LD      (#5CF4),HL
        LD      (#5CEB),HL
        XOR     A
        CALL    SETPAGE_DE
SAVE_T1 LD      A,E
        SUB     64
        JR      C,SAVE_T2
        LD      E,A
        PUSH    DE
        LD      BC,#4006
        LD      DE,(#5CF4)
        LD      HL,#C000
        CALL    DOS
        POP     DE
        RET     C
        INC     D
        LD      A,D
        CALL    SETPAGE_DE
        JR      SAVE_T1
SAVE_T2 LD      A,E
        OR      A
        JR      Z,SAVE_T3
        LD      B,E
        LD      C,6
        LD      DE,(#5CF4)
        LD      HL,#C000
        CALL    DOS
        RET     C
SAVE_T3 LD      HL,(#5CF4)
        LD      (BUFDOS2+#E1),HL
        LD      A,"+"
        LD      (23781),A
        LD      C,9
        LD      A,(BUFDOS2+#E4)
        DEC     A
        CALL    DOS
        RET     C
        LD      BC,#106
        LD      DE,8
        LD      HL,BUFDOS2
        JP      DOS
ADRDE   DEFW    0
ADRHL   DEFW    0
TABDE   DEFB    #14,#16,#17
TABHL   DEFB    #10,#11,#13
;----------------------------
PUTSP   PUSH    HL
        PUSH    BC
        PUSH    HL
        LD      HL,TMP_W
FOR_ATW EQU     $-2
        LD      DE,BUFSPRT
FOR_ASP EQU     $-2
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        POP     BC
        LD      (HL),C
        INC     HL
        LD      (HL),B
        INC     HL
        POP     BC
        LD      (HL),C
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (FOR_ATW),HL
        POP     HL
        LD      (F_ATT1),HL
        LD      (F_ATT2),BC
PUT     PUSH    BC
        PUSH    HL
        CALL    ADRS
        LD      B,8
PUT_Y   PUSH    BC
        PUSH    HL
PUT_X   LDI
        LD      A,C
        AND     A
        JR      NZ,PUT_X
        POP     HL
        INC     H
        POP     BC
        DJNZ    PUT_Y
        POP     HL
        INC     H
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
        LD      A,L
        LD      (DE),A
        INC     DE
        LD      A,H
        LD      (DE),A
        INC     DE
        LD      BC,0
F_ATT2  EQU     $-2
COLPUT0 PUSH    BC
        PUSH    HL
COLPUT1 LD      A,(HL)
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
CLOSEWIN PUSH   AF
        PUSH    HL
        PUSH    DE
        PUSH    BC
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
GET     PUSH    BC
        PUSH    HL
        CALL    ADRS
        EX      DE,HL
        LD      B,8
GET_Y   PUSH    BC
        PUSH    DE
GET_X   LDI
        LD      A,C
        AND     A
        JR      NZ,GET_X
        POP     DE
        INC     D
        POP     BC
        DJNZ    GET_Y
        EX      DE,HL
        POP     HL
        INC     H
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
COLGET0 PUSH    BC
        PUSH    HL
COLGET1 LD      A,(DE)
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
        XOR     A
        LD      (23672),A
        POP     BC
        POP     DE
        POP     HL
        POP     AF
        RET
ADRS    LD      A,L
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
OPENWIN LD      L,(IX)
        SRA     L
        LD      H,(IX+1)
        LD      C,(IX+2)
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
        LD      L,(IX)
        LD      H,(IX+1)
        LD      (_MPX),HL
        CALL    _OOR_Y
        LD      A,#C9
        CALL    _RIA
        LD      B,(IX+2)
PRIX1   PUSH    BC
        LD      A,#CD
        CALL    _RIA
        POP     BC
        DJNZ    PRIX1
        LD      A,#BB
        CALL    _RIA
        LD      B,(IX+3)
        LD      C,1
LP_YY   PUSH    BC
        LD      A,(IX)
        LD      (_MPX),A
        LD      A,(IX+1)
        ADD     A,C
        LD      (_MPY),A
        CALL    _OOR_Y
        LD      A,#BA
        CALL    _RIA
        XOR     A
        LD      (FOR13),A
        LD      (FOR9),A
        LD      B,(IX+2)
LP_XX   PUSH    BC
        LD      A,0
FOR9    EQU     $-1
        AND     A
        JR      Z,CPRISP9
        DEC     A
        LD      (FOR9),A
        JR      PRISPC0
CPRISP9 LD      A,0
FOR13   EQU     $-1
        AND     A
        JR      NZ,PRISPC0
        LD      HL,0
ADRTWI  EQU     $-2
        LD      A,(HL)
        CP      13
        CALL    Z,SET13
        CALL    C,SET9
        AND     A
        JR      NZ,PRISPC
PRISPC0 LD      A," "
        JR      PRISPC1
PRISPC  INC     HL
        LD      (ADRTWI),HL
PRISPC1 CALL    _RIA
        POP     BC
        DJNZ    LP_XX
        LD      A,#BA
        CALL    _RIA
        POP     BC
        INC     C
        DJNZ    LP_YY
        LD      A,(IX)
        LD      (_MPX),A
        LD      A,(IX+1)
        ADD     A,C
        LD      (_MPY),A
        CALL    _OOR_Y
        LD      A,#C8
        CALL    _RIA
        LD      B,(IX+2)
PRIX2   PUSH    BC
        LD      A,#CD
        CALL    _RIA
        POP     BC
        DJNZ    PRIX2
        LD      A,#BC
        CALL    _RIA
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
        LD      A,(IX+4)
        LD      C,(IX+2)
        SRA     C
        INC     C
        LD      B,(IX+3)
        INC     B
        INC     B
COLL0   PUSH    BC
        PUSH    HL
COLL1   LD      (HL),A
        INC     HL
        DEC     C
        JR      NZ,COLL1
        POP     HL
        LD      BC,32
        ADD     HL,BC
        POP     BC
        DJNZ    COLL0
        LD      A,(IX+6)
        AND     A
        RET     Z
        LD      H,A
        LD      L,(IX+5)
        LD      C,0
LOOPZAG LD      A,(HL)
        AND     A
        JR      Z,ENDZAG
        INC     HL
        INC     C
        JR      LOOPZAG
ENDZAG  LD      A,(IX+1)
        LD      (_MPY),A
        LD      A,(IX+2)
        SBC     A,C
        SRA     A
        LD      B,(IX)
        ADD     A,B
        INC     A
        LD      (_MPX),A
        CALL    _OOR_Y
        LD      L,(IX+5)
        LD      H,(IX+6)
LOOPZG2 LD      A,(HL)
        AND     A
        RET     Z
        PUSH    HL
        CALL    _RIA
        POP     HL
        INC     HL
        JR      LOOPZG2
SET9    AND     A
        RET     Z
        INC     HL
        LD      (ADRTWI),HL
        DEC     A
        LD      (FOR9),A
        XOR     A
        RET
SET13   INC     HL
        LD      (ADRTWI),HL
        LD      A,1
        LD      (FOR13),A
        DEC     A
        RET
_RIA    LD      (_OFO),A
        LD      A,(_MPX)
        LD      C,A
        SRL     A
        LD      HL,#4000
_OADRS  EQU     $-2
        ADD     A,L
        LD      L,A
        LD      A,C
        RRA
        LD      DE,FONT
_OFO    EQU     $-2
        LD      B,#0F
        JP      C,_OCHET
        LD      B,#F0
_OCHET  DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0
        DEFB    #77
        LD      HL,_MPX
        INC     (HL)
        RET
_OOR_Y  LD      H,TABSCR/256
        LD      A,(_MPY)
        ADD     A,A
        LD      L,A
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        LD      (_OADRS),HL
        EX      DE,HL
        RET
;--- SELECT FILE ---
SLCFILE
        XOR     A
        LD      (MARKFIL),A
        CALL    CATBIN
        RET     C
        JR      Z,SLCFIL1
        LD      (FILES),A
        LD      HL,TABUD
        LD      BC,#8020
        CALL    FILLATR
        XOR     A
        LD      (FIRFIL),A
        CALL    SEARCHF
        LD      DE,#504
        PUSH    IX
        CALL    PFILES
        XOR     A
        CALL    PUDCODE
        POP     IX
        CALL    PLENS
        EI
        CALL    SELFILE
        CP      #FF
        JP      NZ,SLCFIL2
        LD      IX,WIDOSBR
        CALL    OPENWIN
        CALL    PAK_EN
        CALL    CLOSEWIN
SLCFIL1 SCF
        JP      CLOSEWIN
SLCFIL2 PUSH    AF
        LD      HL,TABUD
        LD      BC,#8000
        LD      A,(HL)
        INC     HL
        CP      " "
        JR      Z,$+3
        INC     C
        DJNZ    $-7
        LD      A,C
        LD      (MARKFIL),A
        POP     AF
        AND     A
        JP      CLOSEWIN
PUDCODE LD      C,A
        LD      B,0
        LD      HL,TABUD
        ADD     HL,BC
        LD      B,10
        LD      DE,#512
PUDCL   PUSH    BC
        PUSH    HL
        PUSH    DE
        LD      (_MPX),DE
        EX      DE,HL
        CALL    _OOR_Y
        LD      A,(HL)
        CALL    _RIA
        POP     DE
        POP     HL
        INC     D
        INC     HL
        POP     BC
        DJNZ    PUDCL
        RET
SEARCHF LD      A,0
FIRFIL  EQU     $-1
        AND     A
        LD      IX,BUFDOS
        RET     Z
        LD      E,A
        LD      BC,16
SERCHF1 LD      A,(IX)
        ADD     IX,BC
        AND     A
        RET     Z
        CP      1
        JR      Z,SERCHF1
        DEC     E
        JR      NZ,SERCHF1
SERCHF2 LD      A,(IX)
        CP      1
        RET     NZ
        ADD     IX,BC
        JR      SERCHF2
PLENS   XOR     A
        LD      (F_PLE1),A
PLENSLL LD      A,(IX)
        AND     A
        RET     Z
        CP      1
        JR      Z,PLEN1
        LD      DE,#514
        LD      A,0
F_PLE1  EQU     $-1
        ADD     A,D
        LD      D,A
        LD      (F_PLE2),A
        LD      (F_PLE3),A
        LD      A,(IX+13)
        CALL    DECIMA2
        LD      L,(IX+9)
        LD      H,(IX+10)
        LD      D,0
F_PLE2  EQU     $-1
        LD      E,#1A
        CALL    DECIMAL
        LD      L,(IX+11)
        LD      H,(IX+12)
        LD      D,0
F_PLE3  EQU     $-1
        LD      E,#22
        CALL    DECIMAL
        LD      HL,F_PLE1
        INC     (HL)
PLEN1   LD      BC,16
        ADD     IX,BC
        LD      A,(F_PLE1)
        CP      10
        JR      NZ,PLENSLL
        RET
SELFILE XOR     A
        LD      (TABSF),A
        LD      (TABSF+5),A
        LD      A,(TABSF+4)
        LD      HL,FILES
        CP      (HL)
        JR      C,SELFILG
        LD      A,(HL)
SELFILG LD      (F_SELF0),A
SELFILF XOR     A
        LD      IX,TABSF
        LD      (23560),A
        CALL    INVER_S
SELFI_  LD      IX,TABSF
        LD      HL,23560
        LD      A,(HL)
        AND     A
        JR      Z,SELFI_
        LD      (HL),0
        CP      10
        JR      NZ,CSELF1
SELFID0 LD      A,0
F_SELF0 EQU     $-1
        DEC     A
        CP      (IX)
        JR      Z,SELFID
        CALL    INVER_S
        INC     (IX)
        INC     (IX+5)
        JR      SELFILF
SELFID  LD      A,(FIRFIL)
        ADD     A,10
        CP      0
FILES   EQU     $-1
        JR      NC,SELFI_
        INC     (IX+5)
        SUB     9
        LD      (FIRFIL),A
CSELF11 CALL    SEARCHF
        LD      DE,#504
        PUSH    IX
        CALL    PFILES
        LD      A,(FIRFIL)
        CALL    PUDCODE
        POP     IX
        CALL    PLENS
        JR      SELFI_
CSELF1  CP      11
        JR      NZ,CSELF2
        LD      A,(IX)
        AND     A
        JR      Z,SELFIU
        CALL    INVER_S
        DEC     (IX)
        DEC     (IX+5)
        JR      SELFILF
SELFIU  LD      A,(FIRFIL)
        AND     A
        JR      Z,SELFI_
        DEC     (IX+5)
        DEC     A
        LD      (FIRFIL),A
        JP      CSELF11
CSELF2  CP      13
        JR      NZ,CSELF3
        CALL    INVER_S
        LD      A,(IX+5)
        RET
CSELF3  CP      14
        JP      NZ,CSELF33
        CALL    INVER_S
        LD      A,#FF
        RET
CSELF33 CP      #20
        JP      NZ,SELFI_
        LD      C,(IX+5)
        LD      B,0
        LD      HL,TABUD
        ADD     HL,BC
        LD      A,(HL)
        CP      32
        LD      A,#FB
        JR      Z,CSELF4
        LD      A,32
CSELF4  LD      (HL),A
        LD      A,(FIRFIL)
        CALL    PUDCODE
        JP      SELFID0
CATBIN  LD      BC,#905
        LD      HL,BUFDOS
        LD      DE,0
        CALL    DOS
        RET     C
        LD      HL,BUFDOS2+245
        LD      DE,F_DNAME
        LD      BC,8
        LDIR
        LD      IX,WIDOSCT
        CALL    OPENWIN
        LD      HL,#B0B
        LD      (#59E6),HL
        LD      (#59EF),HL
        LD      (#59F4),HL
        LD      A,L
        LD      (#59F6),A
        LD      DE,#F1F
        LD      A,(BUFDOS2+244)
        PUSH    AF
        CALL    DEC99
        POP     BC
        LD      A,(BUFDOS2+228)
        SUB     B
        LD      DE,#F0D
        CALL    DEC99
        LD      BC,(BUFDOS2+229)
        LD      DE,#F29
        CALL    DEC9999
        CALL    AFILES
        LD      A,E
        PUSH    AF
        LD      DE,#F12
        CALL    DEC99
        POP     AF
        AND     A
        RET     NZ
        LD      IX,WIDOSNF2
        CALL    OPENWIN
        CALL    PAK_EN
        CALL    CLOSEWIN
        XOR     A
        AND     A
        RET
PFILES  LD      (F_PFI2),DE
        XOR     A
        LD      (F_PFI1),A
PFILESL LD      A,(IX)
        AND     A
        RET     Z
        CP      1
        JR      Z,PFIL1
        LD      DE,0
F_PFI2  EQU     $-2
        LD      A,0
F_PFI1  EQU     $-1
        ADD     A,D
        LD      D,A
        PUSH    IX
        POP     HL
        LD      B,8
        CALL    PRI_B
        LD      A," "
        CALL    _RIA
        LD      A,"<"
        CALL    _RIA
        LD      A,(IX+8)
        CALL    _RIA
        LD      A,">"
        CALL    _RIA
        LD      HL,F_PFI1
        INC     (HL)
PFIL1   LD      BC,16
        ADD     IX,BC
        LD      A,(F_PFI1)
        CP      10
        JR      NZ,PFILESL
        RET
AFILES  LD      IX,BUFDOS
        LD      E,0
        LD      BC,16
AFIL1   LD      A,(IX)
        ADD     IX,BC
        AND     A
        RET     Z
        CP      1
        JR      Z,AFIL1
        INC     E
        JR      AFIL1
FILLATR LD      (HL),C
        INC     HL
        DJNZ    FILLATR
        RET
;------------------
INVER_S LD      A,(IX+2)
        ADD     A,(IX)
        LD      L,A
        LD      H,0
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        LD      A,(IX+1)
        ADD     A,L
        LD      L,A
        LD      BC,#5800
        ADD     HL,BC
        LD      A,(HL)
        XOR     #3F
        LD      (HL),A
        LD      D,H
        LD      E,L
        INC     DE
        LD      C,(IX+3)
        DEC     C
        LD      B,0
        LDIR
        RET
PRI_B   LD      (_MPX),DE
        EX      DE,HL
        CALL    _OOR_Y
LPRI_B  PUSH    BC
        LD      A,(HL)
        AND     A
        JR      Z,LPRI_C
        PUSH    HL
        CALL    _RIA
        POP     HL
        INC     HL
LPRI_C  POP     BC
        DJNZ    LPRI_B
        RET
DEC99   LD      C,A
        LD      B,0
DEC9999 PUSH    BC
        LD      HL,FPRIA
        LD      (#5C51),HL
        LD      (_MPX),DE
        CALL    _OOR_Y
        POP     BC
        JP      #1A1B
FPRIA   DEFW    _RIA
DECIMA2 PUSH    AF
        LD      (_MPX),DE
        CALL    _OOR_Y
        POP     AF
        LD      L,A
        LD      H,0
        JR      DECIMA3
DECIMAL LD      (_MPX),DE
        EX      DE,HL
        CALL    _OOR_Y
        LD      DE,#2710
        CALL    PRIDCM
        LD      DE,#3E8
        CALL    PRIDCM
DECIMA3 LD      DE,#64
        CALL    PRIDCM
        LD      DE,10
        CALL    PRIDCM
        LD      A,L
        ADD     A,#30
        JP      _RIA
PRIDCM  LD      A,#2F
PRIDCM2 ADD     A,1
        SBC     HL,DE
        JR      NC,PRIDCM2
        ADD     HL,DE
        PUSH    HL
        CALL    _RIA
        POP     HL
        RET
PAK_SP  LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,PAK_SP
        RET
PAK_EN  LD      A,#BF
        IN      A,(#FE)
        RRA
        JR      C,PAK_EN
        RET
;----------------
DOS     DI
        CALL    DOS1
        EI
        LD      A,(#5C3A)
        CP      #FF
        JR      Z,DOS02
        CP      #14
        JR      NZ,DOS00
        LD      IX,WIDOSBR
DOS10   CALL    OPENWIN
        CALL    PAK_EN
DOS03   CALL    CLOSEWIN
        SCF
        RET
DOS00   CP      #1A
        JR      NZ,DOS04
        LD      A,(#5D0F)
        CP      7
        JR      Z,DOS04
        LD      IX,WIDOSND
        CALL    OPENWIN
        CALL    ABORET
        CALL    CLOSEWIN
        AND     A
        JP      Z,DOS
DOS04   SCF
        RET
DOS02   AND     A
        RET
ER_DOS  LD      A,(#5D0F)
        CP      1
        LD      IX,WIDOSNF
        JR      Z,DOS20
        CP      3
        LD      IX,WIDOSRD
        JR      Z,DOS10
        CP      #FF
        JR      NZ,DOS02
        JR      DOS10
DOS20   CALL    OPENWIN
        CALL    PAK_SP
        JR      DOS03
DOS1    PUSH    HL
        LD      HL,#5C3A
        LD      (HL),#FF
        LD      L,#C2
        LD      (HL),#C3
        LD      HL,C9PROG
        LD      (#5CC3),HL
        LD      HL,0
        LD      (#5D0F),HL
        POP     HL
        CALL    IN3D13
        LD      HL,#5CC2
        LD      (HL),#C9
        LD      HL,(#5CB2)
        DEC     HL
        DEC     HL
        LD      (HL),#13
        DEC     HL
        LD      (HL),3
        LD      (#5C3D),HL
        RET
IN3D13  LD      (#5C3D),SP
        CALL    #3D13
        RET
        NOP
        NOP
C9PROG  EX      (SP),HL
        PUSH    HL
        PUSH    AF
        PUSH    DE
        EX      DE,HL
        OR      A
        LD      HL,#28E
        SBC     HL,DE
        JR      Z,C9PROG9
        OR      A
        LD      HL,#31E
        SBC     HL,DE
        JR      Z,C9PROG8
        OR      A
        LD      HL,#333
        SBC     HL,DE
        JR      Z,KEYDOS
        OR      A
        LD      HL,#D6B
        SBC     HL,DE
        JR      Z,C9PROG1
        OR      A
        LD      HL,#10
        SBC     HL,DE
        JR      Z,C9PROGA
        OR      A
        LD      HL,#1A1B
        SBC     HL,DE
        JR      Z,C9PROG1
        POP     DE
        POP     AF
        POP     HL
        EX      (SP),HL
        RET
C9PROG8 SCF
C9PROG9 POP     DE
        INC     SP
        INC     SP
        POP     HL
        POP     HL
        RET
C9PROG1 POP     DE
C9PROG0 POP     AF
C9PROG2 POP     HL
        POP     HL
        RET
C9PROGA POP     DE
        POP     AF
        PUSH    AF
        CP      #3F
        JR      Z,C9PROG0
        LD      HL,TRIGGER
        CP      #64
        JR      NZ,C9PROGB
        LD      (HL),0
        JR      C9PROG0
C9PROGB CP      #69
        JR      NZ,C9PROG0
        LD      (HL),1
        JR      C9PROG0
KEYDOS  LD      IX,WIDOSPR
        LD      A,0
TRIGGER EQU     $-1
        AND     A
        JR      Z,PRIWND2
        LD      IX,WIDOSDM
PRIWND2 CALL    OPENWIN
        CALL    ABORET
        AND     A
        LD      A,"R"
        JP      Z,PRIWND3
        LD      A,"A"
PRIWND3 CALL    CLOSEWIN
        JP      C9PROG9
ABORET  LD      IX,WIDOSRA
        CALL    OPENWIN
        LD      A,16
        LD      (#5927),A
        LD      (#592A),A
ABORET2 LD      A,#7B
        IN      A,(#FE)
        BIT     3,A
        LD      A,0
        JP      Z,CLOSEWIN
        LD      A,#FD
        IN      A,(#FE)
        RRA
        JR      C,ABORET2
        LD      A,1
        JP      CLOSEWIN
;-----------------------
WIDOSNAM DEFW   #80A,#428
        DEFB    #16
        DEFW    HEAD1
        DEFB    13," Convert File:",6,8,"Len:",13
        DEFB    " To New File :",6,8,"Len:",0
HEAD1   DEFB    " Please Wait! ",0
WINMAIN DEFW    #60E,#820
        DEFB    #17
        DEFW    HEAD0
        DEFB    13,2,"*** Converter Text Files ***",13
        DEFB    5,"Ver 1.0 (C) By (R)soft",13
        DEFB    11,"19/10/1998",13
        DEFB    2,"/--------------------------\",13
        DEFB    3,"Special For ZX-Word Format",13
        DEFB    3,"Max Length of File is 48Kb",0
HEAD0   DEFB    " WELCOME! ",0
WIDOSPR DEFW    #408,#312
        DEFB    15
        DEFW    DEHEAD
        DEFB    13,2,"Write protect!",0
DEHEAD  DEFB    " ERROR ",0
WIDOSDM DEFW    #408,#310
        DEFB    15
        DEFW    DEHEAD
        DEFB    13,2,"Disk Damaged",0
WIDOSRA DEFW    #80C,#110
        DEFB    22
        DEFW    0
        DEFB    2,"Retry Abort",0
WIDOSND DEFW    #408,#310
        DEFB    15
        DEFW    DEHEAD
        DEFB    13,4,"No Disk",0
WIDOSBR DEFW    #408,#410
        DEFB    22
        DEFW    DEHEAD
        DEFB    13,5,"Break!",13
        DEFB    2,"Press ENTER",13,0
WIDOSNF DEFW    #408,#410
        DEFB    15
        DEFW    DEHEAD
        DEFB    13,4,"No file",13
        DEFB    2,"Press SPACE",13,0
WIDOSEX DEFW    #408,#512
        DEFB    22
        DEFW    DEHEAD2
        DEFB    13,3,"File Exists",13,13
        DEFB    2,"Overwrite Abort",13,0
DEHEAD2 DEFB    " WARNING! ",0
WIDOSRD DEFW    #408,#310
        DEFB    22
        DEFW    DEHEAD
        DEFB    13,3,"Disk Full!",0
WIDOS_E DEFW    #408,#310
        DEFB    22
        DEFW    DEHEAD
        DEFB    13,3,"Disk Error",0
WIDOSCT DEFW    #402,#B2C
        DEFB    15
        DEFW    DEHEAD3
        DEFB    13,13,13,13,13,13,13,13,13,13
        DEFB    " File(s):",5,"(",3,") Delete:",5,"Free:",0
DEHEAD3 DEFB    " Disk Name: "
F_DNAME DEFB    "         ",0
WIDOSNF2 DEFW    #80C,#310
        DEFB    6
        DEFW    0
        DEFB    13,4,"No files",13,0
TABSF   DEFB    0
        DEFW    #502,#A15
        DEFB    0       ;SELFILE
SDOS1   DEFB    0
        DEFW    #907,#405
;-------------
_MPX    DEFB    0
_MPY    DEFB    0
MARKFIL DEFB    0
TMP_W   DEFS    64
FREE    DISPLAY FREE
        ORG     TABECR
TABSCR  DEFW    #4000,#4020,#4040,#4060,#4080,#40A0
        DEFW    #40C0,#40E0,#4800,#4820,#4840,#4860
        DEFW    #4880,#48A0,#48Cóÿÿ> Óþ>? Ã‚=íGÃ Ã'   Ãr/ÉbkÃ##6+¼ úÿÿÿÿÿûÉ·íR#05(5(ó+"´\¯>¨ {ë1 `" _!y å!/=å