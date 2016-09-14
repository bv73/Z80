        ORG     #8000
;
        DI
        LD      A,0
        LD      (PRINTER),A
;
        LD      A,(PRINTER)
        AND     A
        JR      Z,GOSTART
        CALL    LPTINIT
GOSTART
        CALL    PRI_T
        DEFB    #1C,"Disk Searcher v0.1 "
        DEFB    "(C) (R)soft 1999",13
        DEFB    "May Detecting: TASM, ALASM, ZXZIP, "
        DEFB    "PROTRACKER 1.0-3.3",13
        DEFB    "Press <SPACE> to Abort.",13,13,0
        LD      DE,#0100
        LD      HL,#C000
MLP
        LD      (TRKSEC),DE
        LD      HL,#C000
        LD      BC,#0105
        CALL    #3D13
        LD      IX,#C000
        CALL    TASM
        CALL    NC,ALASM
        CALL    NC,ZXZIP
        CALL    NC,PROTR1
        CALL    NC,PROTR2
        CALL    NC,PROTR3
        JR      C,MLP2
        LD      A,(PRINTER)
        AND     A
        JR      NZ,MLP2

        LD      A,3
WORK    EQU     $-1
        DEC     A
        LD      (WORK),A
        AND     A
        JR      NZ,WORKS
        LD      A,3
        LD      (WORK),A
WORKS
        LD      HL,TABWORK
        ADD     A,L
        LD      L,A
        LD      A,(HL)
        CALL    PRIA
        LD      HL,TMPX
        DEC     (HL)
MLP2
        LD      DE,(#5CF4)
        LD      A,D
        CP      160
        RET     Z
        LD      A,#7F
        IN      A,(#FE)
        RRA
        RET     NC
        JP      MLP
TASM
        XOR     A
        LD      (SPTAS),A
        LD      (LNTAS),A
        PUSH    IX
        POP     HL
TASMLOO
        LD      A,L
        CP      #E0
        JR      NC,TASM1
        LD      A,(HL)
        INC     HL
        AND     A
        JR      Z,ZTASM
        LD      B,A
TASM0   INC     HL
        DJNZ    TASM0
        LD      C,(HL)
        INC     HL
        CP      C
        JR      Z,LTASM
        AND     A       ;No TASM LINE
        RET
LTASM
        LD      A,0
LNTAS   EQU     $-1
        INC     A
        LD      (LNTAS),A
        JR      TASMLOO
ZTASM
        LD      A,(HL)
        INC     HL
        AND     A
        JR      Z,ZTASM1
        AND     A
        RET
ZTASM1
        LD      A,0
SPTAS   EQU     $-1
        INC     A
        LD      (SPTAS),A
        JR      TASMLOO
TASM1
        LD      A,(SPTAS)
        CP      10
        JR      C,TASM10
        RET
TASM10
        LD      A,(LNTAS)
        CP      5
        JR      NC,TASM100
        AND     A
        RET
TASM100
        CALL    PRI_T
        DEFB    "TASM 4.12 <A> at #",0
        CALL    PRITS
TASMB
        PUSH    IX
        POP     HL
        LD      B,0
TASM2
        LD      A,(HL)
        INC     HL
        CP      #FF
        JR      Z,TASM20
        DJNZ    TASM2
        LD      DE,(#5CF4)
        LD      (TRKSEC),DE
        LD      HL,#C000
        LD      BC,#0105
        CALL    #3D13
        LD      IX,#C000
        JR      TASMB
TASM20
        CALL    PRI_T
        DEFB    " - END at #",0
        CALL    PRITS
        CALL    PRI_T
        DEFB    13,0
        SCF
        RET
ALASM
        LD      A,(IX+8)
        CP      "H"
        JP      NZ,ALASME
        LD      A,(IX+#28)
        CP      #F3
        JR      NZ,ALASME
        LD      A,(IX+#29)
        CP      #76
        JR      NZ,ALASME
        LD      A,(IX+#2A)
        CP      #C7
        JR      NZ,ALASME
        LD      A,(IX+#2B)
        CP      #DD
        JR      NZ,ALASME
        LD      A,(IX+#2C)
        CP      #FD
        JR      NZ,ALASME
        LD      A,(IX+#2D)
        CP      #ED
        JR      NZ,ALASME
        LD      A,(IX+#2E)
        CP      #B0
        JR      NZ,ALASME
        LD      A,(IX+#2F)
        CP      #D9
        JR      NZ,ALASME
        CALL    PRI_T
        DEFB    "ALASM 4.1 <H> at #",0
        CALL    PRITS
        CALL    PRI_T
        DEFB    " Len #",0
        LD      L,(IX+#21)
        LD      H,(IX+#22)
        LD      BC,#40
        ADD     HL,BC
        CALL    PRIHEX
        CALL    PRI_T
        DEFB    " - Name: ",0
        PUSH    IX
        POP     HL
        LD      B,8
        CALL    PRI_B
        CALL    PRI_T
        DEFB    ".H",13,0
ALASME  AND     A
        RET
PRITS   LD      HL,(TRKSEC)
        JP      PRIHEX
PROTR1
        PUSH    IX
        POP     HL
        LD      BC,#45
        ADD     HL,BC
        LD      B,30
        LD      DE,#2060
        CALL    SYMBLER
        RET     NC
        PUSH    IX
        POP     HL
        LD      B,1
        LD      DE,#030F
        CALL    SYMBLER
        RET     NC
        LD      A,(IX+3)
        AND     A
        JR      NZ,PROTR1E
        LD      A,(IX+4)
        AND     A
        JR      NZ,PROTR1E
        CALL    PRI_T
        DEFB    "ProTracker 1.0 <P> at #",0
        CALL    PRITS
        CALL    PRI_T
        DEFB    " - ",0
        PUSH    IX
        POP     HL
        LD      BC,#45
        ADD     HL,BC
        LD      B,30
        CALL    PRI_B
        CALL    PRI_T
        DEFB    13,0
        SCF
        RET
PROTR1E
        AND     A
        RET
PROTR2
        PUSH    IX
        POP     HL
        LD      BC,#65
        ADD     HL,BC
        LD      B,30
        LD      DE,#2060
        CALL    SYMBLER
        RET     NC
        PUSH    IX
        POP     HL
        LD      B,1
        LD      DE,#030F
        CALL    SYMBLER
        RET     NC
        LD      A,(IX+3)
        AND     A
        JR      NZ,PROTR2E
        LD      A,(IX+4)
        AND     A
        JR      NZ,PROTR2E
        CALL    PRI_T
        DEFB    "ProTracker 2.1 <M> at #",0
        CALL    PRITS
        CALL    PRI_T
        DEFB    " - ",0
        PUSH    IX
        POP     HL
        LD      BC,#65
        ADD     HL,BC
        LD      B,30
        CALL    PRI_B
        CALL    PRI_T
        DEFB    13,0
        SCF
        RET
PROTR2E
        AND     A
        RET
PROTR3
        PUSH    IX
        POP     HL
        LD      DE,#207F
        LD      B,#62
        CALL    SYMBLER
        RET     NC
        LD      A,(IX)
        CP      "P"
        JR      NZ,PROTR3E
        LD      A,(IX+1)
        CP      "r"
        JR      NZ,PROTR3E
        LD      A,(IX+2)
        CP      "o"
        JR      NZ,PROTR3E
        LD      A,(IX+3)
        CP      "T"
        JR      NZ,PROTR3E
        LD      A,(IX+4)
        CP      "r"
        JR      NZ,PROTR3E
        CALL    PRI_T
        DEFB    "ProTracker 3.3 <m> at #",0
        CALL    PRITS
        CALL    PRI_T
        DEFB    " - ",0
        PUSH    IX
        POP     HL
        LD      BC,#1E
        ADD     HL,BC
        LD      B,30
        CALL    PRI_B
        CALL    PRI_T
        DEFB    13,0
        SCF
        RET
PROTR3E AND     A
        RET
ZXZIP
        LD      A,(IX+8)
        CP      "B"
        JR      Z,ZXZIP1
        CP      "C"
        JR      Z,ZXZIP1
        CP      "A"
        JR      Z,ZXZIP1
        CP      "H"
        JR      Z,ZXZIP1
        CP      "P"
        JR      Z,ZXZIP1
        CP      "M"
        JR      Z,ZXZIP1
ZXZIPE  AND     A
        RET
ZXZIP1
        LD      A,(IX+#14)
        CP      3
        JR      Z,ZXZIP10
        CP      2
        JR      Z,ZXZIP10
        CP      1
        JR      Z,ZXZIP10
        AND     A
        JR      NZ,ZXZIPE
ZXZIP10 LD      A,(IX+#15)
        AND     A
        JR      Z,ZXZIP11
        CP      1
        JR      NZ,ZXZIPE
ZXZIP11 LD      A,1
        LD      (ZIPNUM),A
        LD      HL,0
        LD      (STZIP),HL
        CALL    PRI_T
        DEFB    "ZXZIP <Z> at #",0
        LD      HL,(TRKSEC)
        LD      (TRK2),HL
        CALL    PRITS
        CALL    PRI_T
        DEFB    " Files: ",0
        PUSH    IX
        POP     HL
ZXZIP2
        CALL    PRINAME
        RET     C
;
        DISPLAY $
        LD      L,(IX+#0E)      ;PackLen File
        LD      H,(IX+#0F)
        LD      BC,#16
        ADD     HL,BC
        EX      DE,HL
        LD      HL,0
STZIP   EQU     $-2
        LD      A,H
        ADD     HL,DE
        LD      (STZIP),HL
        CP      H
        JR      Z,ZXZIPM
        CALL    POSIT           ;Len -> Sec
        LD      DE,0
TRK2    EQU     $-2
        CALL    CALCPOS
        LD      (TRK2),DE       ;Next TrkSec
        LD      HL,#C000
        LD      BC,#0205
        CALL    #3D13           ;Load 2 Sec
        LD      HL,(STZIP)
ZXZIPM  LD      H,#C0
        PUSH    HL
        POP     IX
        JR      ZXZIP2
CALCPOS                         ;In:  DE - TrkSec
        LD      B,0             ;     A  - Sectors
        LD      C,#10           ;Out: DE - New TrkSec
CALCP1
        SBC     A,C
        JR      C,CALCP3
        INC     B
        JR      CALCP1
CALCP3
        ADD     A,C
        ADD     A,E
        CP      #10
        JR      C,CALCP4
        SUB     #10
        INC     B
CALCP4
        LD      E,A
        LD      A,D
        ADD     A,B
        LD      D,A
        RET
POSIT                           ;In:  HL - Len Data
        LD      A,L             ;Out: A - Sectors
        AND     A
        JR      Z,POSIT1
        INC     H
POSIT1
        LD      A,H
        RET
PRINAME
        PUSH    HL
        LD      B,8
        LD      DE,#207F
        CALL    SYMBLER
        POP     HL
        JR      NC,PRIN0        ;End
        LD      A,(IX+8)
        CP      "Z"             ;ZIP File
        JR      Z,PRIN0
        LD      A,(IX+#14)
        CP      3
        JR      Z,ZXZIP20
        CP      2
        JR      Z,ZXZIP20
        CP      1
        JR      Z,ZXZIP20
        AND     A
        JR      NZ,PRIN0
ZXZIP20
        LD      A,(IX+#15)
        AND     A
        JR      Z,ZXZIP21
        CP      1
        JR      NZ,PRIN0
ZXZIP21
        PUSH    HL
        LD      A,0
ZIPNUM  EQU     $-1
        CALL    PRIHB
        LD      A," "
        CALL    PRIA
        POP     HL
        LD      B,8
        CALL    PRI_B
        LD      A,"."
        CALL    PRIA
        LD      A,(IX+8)
        CALL    PRIA
        CALL    PRI_T
        DEFB    " ",0
        LD      A,(TMPX)
        SUB     14
        LD      (TMPX),A
        LD      HL,ZIPNUM
        INC     (HL)
        AND     A
        RET
PRIN0
        LD      HL,TMPX
        INC     (HL)
        INC     (HL)
        INC     (HL)
        CALL    PRI_T
        DEFB    "ZIP-Len #",0
        LD      HL,(STZIP)
        CALL    PRIHEX
        CALL    PRI_T
        DEFB    13,0
        LD      HL,(TRK2)       ;!!!
        LD      (#5CF4),HL
        SCF
        RET
SYMBLER
        LD      A,(HL)
        INC     HL
        CP      D
        JR      C,SYMBLE1
        CP      E
        JR      NC,SYMBLE1
        DJNZ    SYMBLER
        SCF
        RET
SYMBLE1
        AND     A
        RET
PRI_B   PUSH    BC
        PUSH    HL
        LD      A,(HL)
        CALL    PRIA
        POP     HL
        INC     HL
        POP     BC
        DJNZ    PRI_B
        RET
PRI_T   POP     HL
        LD      A,(PRINTER)
        AND     A
        JR      NZ,PRI_TT
        CALL    PRI_BB
        JP      (HL)
PRI_TT
        CALL    LPT_BB
        JP      (HL)
PRI_BB  LD      A,(HL)
        INC     HL
        AND     A
        RET     Z               ;0 - Exit
        CP      13
        JR      NZ,PRI_BB0
        EX      DE,HL
        LD      HL,TMPX
        LD      (HL),0
        INC     HL
        INC     (HL)
        CALL    KOOR_Y
        JR      PRI_BB
PRI_BB0 CP      #FF             ;Inverse
        JR      NZ,PRI_BB1
        LD      A,(INVERSE)
        XOR     #FF
        LD      (INVERSE),A
        JR      PRI_BB
PRI_BB1 CP      #20
        JR      C,PRI_BB2       ;<#20 - Attr Code
        PUSH    HL
        CALL    PRIA
        POP     HL
        JR      PRI_BB
PRI_BB2 CP      #1F             ;Fill
        JR      NZ,PRI_BB3
        LD      A,(HL)          ;Symbol Fill
        INC     HL
        LD      B,(HL)          ;Num Fill
        INC     HL
        PUSH    HL
PRI_BB4 PUSH    BC
        PUSH    AF
        CALL    PRIA
        POP     AF
        POP     BC
        DJNZ    PRI_BB4
        POP     HL
        JR      PRI_BB
PRI_BB3 CP      #1E             ;Set Koord
        JR      NZ,PRI_BB5
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      (TMPX),DE
        EX      DE,HL
        CALL    KOOR_Y
        JR      PRI_BB
PRI_BB5 CP      #1D             ;Set X Koor
        JR      NZ,PRI_BB6
        LD      A,(HL)
        INC     HL
        LD      (TMPX),A
        JR      PRI_BB
PRI_BB6 CP      #1C             ;Clear Screen
        JR      Z,PRI_BB7
        LD      C,A             ;1-#1B Add X Koor
        LD      A,(TMPX)        ;(Without #0D)
        ADD     A,C
        LD      (TMPX),A
        JR      PRI_BB
PRI_BB7 PUSH    HL
        CALL    CLSCR
        LD      HL,0
        LD      (TMPX),HL
        CALL    KOOR_Y
        POP     HL
        JR      PRI_BB
;
PRIHEX  LD      A,H
        PUSH    HL
        CALL    PRIHB
        POP     HL
        LD      A,L
PRIHB   PUSH    AF
        RRCA
        RRCA
        RRCA
        RRCA
        CALL    PRITET
        POP     AF
PRITET  AND     #0F
        ADD     A,#90
        DAA
        ADC     A,#40
        DAA
;==============================
PRIA    LD      E,A             ;Symbols Print
        LD      A,(PRINTER)
        AND     A
        JP      NZ,LPT_AA
        LD      A,(TMPX)
        LD      C,A
        SRL     A
        LD      HL,0
FOADRS  EQU     $-2
        ADD     A,L
        LD      L,A
        LD      A,C
        RRA
        LD      D,FONT/256
        LD      C,0
INVERSE EQU     $-1
        LD      B,#0F
        JR      C,NOCHET
        LD      B,#F0
NOCHET  LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        LD      HL,TMPX
        INC     (HL)
        INC     HL
        RET
KOOR_Y  LD      H,TABSCR/256
        LD      A,(TMPY)
        ADD     A,A
        LD      L,A
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        LD      (FOADRS),HL
        EX      DE,HL
        RET
CLSCR   LD      HL,#4000
        LD      E,L
        LD      D,H
        INC     DE
        LD      (HL),L
        LD      BC,#17FF
        LDIR
        INC     DE
        INC     HL
        LD      (HL),7
        LD      BC,#2FF
        LDIR
        RET
LPT_BB  LD      A,(HL)
        INC     HL
        AND     A
        RET     Z               ;0 - Exit
        CP      13
        JR      NZ,LPT_BB0
LPT_BBE CALL    LPT_A
        LD      A,10
        CALL    LPT_A
        JR      LPT_BB
LPT_BB0 CP      #20
        JR      C,LPT_BB1       ;<#20 - Attr Code
        CP      #FF
        JR      Z,LPT_BB
        CALL    LPT_A
        JR      LPT_BB
LPT_BB1 CP      #1F
        JR      NZ,LPT_BB2
        LD      A,(HL)
        INC     HL
        LD      B,(HL)
        INC     HL
LPT_BBL PUSH    BC
        PUSH    AF
        CALL    LPT_A
        POP     AF
        POP     BC
        DJNZ    LPT_BBL
        JR      LPT_BB
LPT_BB2 CP      #1E
        JR      NZ,LPT_BB3
        INC     HL
        INC     HL
        LD      A,13
        JR      LPT_BBE
LPT_BB3 CP      #1D
        JR      NZ,LPT_BB4
        INC     HL
        JR      LPT_BB
LPT_BB4 CP      #1C
        JR      NZ,LPT_BB
        LD      A,13
        JR      LPT_BBE
LPTINIT LD      HL,TABINI
        LD      B,5
SOFER   PUSH    BC
        LD      A,(HL)
        INC     HL
        CALL    LPT_A
        POP     BC
        DJNZ    SOFER
        RET
LPT_AA  LD      A,E
LPT_A   PUSH    AF
WAIT_   CALL    #1F54
        JR      NC,SHOWLPE
        IN      A,(#7B)
        AND     #80
        JR      NZ,WAIT_
        POP     AF
        OUT     (#FB),A
        OUT     (#7B),A
        OUT     (#FB),A
        RET
SHOWLPE POP     AF
        RET
;---------------------
TMPX    DEFB    0
TMPY    DEFB    0
TRKSEC  DEFW    0
TABWORK DEFB    "|\-/"
TABINI  DEFB    27,"@",27,#6C,12
PRINTER DEFB    0
;
EOF     DISPLAY EOF
        ORG     #B700
TABSCR  DEFW    #4000,#4020,#4040,#4060,#4080,#40A0
        DEFW    #40C0,#40E0,#4800,#4820,#4840,#4860
        DEFW    #4880,#48A0,#48C0,#48E0,#5000,#5020
        DEFW    #5040,#5060,#5080,#50A0,#50C0,#50E0
;
        ORG     #B800
FONT
;       .INCBIN FONT
        .RUN    #8000

