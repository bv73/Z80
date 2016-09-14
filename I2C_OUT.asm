        ORG     #8000
;
FIRSTB  EQU     37807
LASTB   EQU     42561
START   EQU     FIRSTB
REG_AY  EQU     #FFFD
DAT_AY  EQU     #BFFD
;
        DI
        XOR     A
        LD      (FIRSTB-1),A
        LD      (LASTB+1),A
        CALL    CLS
        LD      DE,#0005
        LD      HL,TXT2
        CALL    PRI_BB
        LD      DE,#0100
        LD      HL,TXT20
        CALL    PRI_BB
;
        LD      HL,TXT3
        LD      DE,#0200
        CALL    PRI_BB
        LD      HL,TXT4
        LD      DE,#0300
        CALL    PRI_BB
        LD      HL,TXT5
        LD      DE,#0400
        CALL    PRI_BB
        CALL    PRINTHLP
        LD      HL,START
RESET
        LD      (ADRES),HL
        EI
        CALL    OUTPUT_INI

        CALL    PRINT
        CALL    OUTPUT

LOOP
        LD      A,1
        OUT     (#FE),A
;
        LD      A,#7F
        IN      A,(#FE)
        RRA                     ;EXIT FROM PROGRAM
        JR      C,CONT1         ;BY <SPACE>
        EI
        RET
CONT1
        RRA                     ;INC 1 ADDRESS
        JR      C,CONT2         ;BY <SHIFT>
        LD      HL,(ADRES)
        INC     HL
        LD      A,(HL)
        AND     A
        JR      NZ,CONT111
        LD      HL,FIRSTB
CONT111
        LD      (ADRES),HL
        CALL    PRINT
        CALL    OUTPUT
        JR      LOOP
CONT2
        RRA                     ;DEC 1 ADDRESS
        JR      C,CONT3         ;BY <M>
        LD      HL,(ADRES)
        DEC     HL
        LD      A,(HL)
        AND     A
        JR      NZ,CONT222
        LD      HL,LASTB
CONT222
        LD      (ADRES),HL
        CALL    PRINT
        CALL    OUTPUT
        JR      LOOP
CONT3
        RRA                     ;INC 1 ADDRESS WITH PAUSE
        JR      C,CONT4         ;BY "N"
        LD      HL,(ADRES)
        INC     HL
        LD      A,(HL)
        AND     A
        JR      NZ,CONT333
        LD      HL,FIRSTB
CONT333
        LD      (ADRES),HL
        CALL    PRINT
        CALL    OUTPUT
        CALL    PAUSE
        JR      LOOP
CONT4
        RRA                     ;DEC 1 ADDRESS WITH PAUSE
        JR      C,CONT5         ;BY "B"
        LD      HL,(ADRES)
        DEC     HL
        LD      A,(HL)
        AND     A
        JR      NZ,CONT444
        LD      HL,LASTB
CONT444
        LD      (ADRES),HL
        CALL    PRINT
        CALL    OUTPUT
        CALL    PAUSE
        JR      LOOP
CONT5
        LD      A,#F7
        IN      A,(#FE)
        RRA
        JR      C,CONT6
        LD      A,#0B
CONT555
        LD      (LEN_PRINT),A
        CALL    CLS_LIN
        CALL    PRINT
        CALL    PAUSE
        JP      LOOP
CONT6
        RRA
        JR      C,CONT7
        LD      A,#1A
        JR      CONT555
CONT7
        RRA
        JR      C,CONT8
        LD      A,#33
        JR      CONT555
CONT8
        LD      A,#BF
        IN      A,(#FE)
        RRA
        JR      C,CONT9
        LD      HL,37978
        JP      RESET
CONT9
        RRA
        JP      C,LOOP
        LD      HL,42318
        JP      RESET
;
PAUSE
        LD      HL,#4000
PAUSE1
        DEC     HL
        LD      A,H
        OR      L
        JR      NZ,PAUSE1
        RET
;
CLS
        LD      HL,#4000
        LD      D,H
        LD      E,L
        INC     DE
        LD      BC,#17FF
        LD      (HL),L
        LDIR
        RET
PRINT
        DI
        LD      HL,(ADRES)
        LD      DE,#0021
        CALL    DECIMAL
;
        LD      C,1
        LD      HL,(ADRES)
        LD      DE,#0205
        CALL    LINE1
;
        LD      C,2
        LD      HL,(ADRES)
        LD      DE,#0305
        CALL    LINE1
;
        LD      C,4
        LD      HL,(ADRES)
        LD      DE,#0405
        CALL    LINE1
        EI
        RET
;
LINE1
        LD      (_MPX),DE
        EX      DE,HL
        CALL    _OOR_Y
        LD      B,#33           ;LEN_PRINT #33 OR #1A
LEN_PRINT EQU   $-1
LINE2
        PUSH    HL
        PUSH    BC
        LD      A,(HL)
        AND     C
        LD      E,"0"
        JR      Z,LINE3
        LD      E,"1"
LINE3
        LD      A,E
        CALL    _RIA
        POP     BC
        POP     HL
        INC     HL
        DJNZ    LINE2
        RET
CLS_LIN
        LD      DE,#0205
        CALL    CLSLINE
        LD      DE,#0305
        CALL    CLSLINE
        LD      DE,#0405
CLSLINE
        LD      (_MPX),DE
        CALL    _OOR_Y
        LD      B,#33
CLSLINE1
        PUSH    BC
        LD      A," "
        CALL    _RIA
        POP     BC
        DJNZ    CLSLINE1
        RET
;----------------------
OUTPUT_INI
        LD      BC,REG_AY       ;SELECT 7 REGISTER
        LD      A,7
        OUT     (C),A
        LD      BC,DAT_AY
        LD      A,#C0           ;A PORT - OUTPUT
        OUT     (C),A           ;B PORT - OUTPUT
;
        LD      BC,REG_AY       ;SELECT A PORT
        LD      A,14
        OUT     (C),A
        LD      BC,DAT_AY
        XOR     A
        OUT     (C),A
        RET
;
OUTPUT
        LD      BC,DAT_AY
        LD      HL,(ADRES)
        LD      A,(HL)
        OUT     (C),A
        RET
;----------------
TXT2    DEFB    "SHOW CHANNELS FROM ADDRESS:",0
TXT20   DEFB    "     |0   |1   |2   |3   |4   |5   |6   |7"
        DEFB    "   |8   |9   |10",0
TXT3    DEFB    "EN :",0
TXT4    DEFB    "DAT:",0
TXT5    DEFB    "CLK:",0
TXTHLP1 DEFB    "HELP: <SPACE> - EXIT <ENTER> - INIT "
        DEFB    "<L> - RESET TRIGGER",0
        DEFB    "<SHIFT> - RIGHT 1, <M> - LEFT 1",0
        DEFB    "<N> - RIGHT 1 PAUSE, <B> - LEFT 1 PAUSE",0
        DEFB    "<1>,<2>,<3> - LENGTH OF PRINT",0
;------------------------
PRINTHLP
        LD      HL,TXTHLP1
        LD      DE,#1000
        CALL    PRI_BB
        LD      DE,#1106
        CALL    PRI_BB
        LD      DE,#1206
        CALL    PRI_BB
        LD      DE,#1306
        JP      PRI_BB
;=================================
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
;
PRI_BB  LD      (_MPX),DE
        EX      DE,HL
        CALL    _OOR_Y
LPRI_BB LD      A,(HL)
        INC     HL
        AND     A
        RET     Z
        CP      #20
        JR      C,LPRI_BB
        PUSH    HL
        CALL    _RIA
        POP     HL
        JP      LPRI_BB
;
DEC99   LD      C,A
        LD      B,0
DEC9999 LD      HL,FPRIA
        LD      (#5C51),HL
        LD      (_MPX),DE
        CALL    _OOR_Y
        JP      #1A1B
FPRIA   DEFW    _RIA
;
DECIMA2 PUSH    AF
        LD      (_MPX),DE
        CALL    _OOR_Y
        POP     AF
        LD      L,A
        LD      H,0
        JR      DECIMA3
;
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
PRI_HEX1 PUSH AF
        LD      (_MPX),DE
        CALL    _OOR_Y
        POP     AF
        JR      PRIHB
PRI_HEX2 LD     (_MPX),DE
        EX      DE,HL
        CALL    _OOR_Y
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
_RIA    LD      (_OFO),A
        LD      A,(_MPX)
        LD      C,A
        SRL     A
        LD      HL,(_OADRS)
        ADD     A,L
        LD      L,A
        LD      A,C
        RRA
        LD      DE,FONT
_OFO    EQU     $-2
        LD      B,#0F
        JR      C,_OCHET
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
;---------------------
_MPX    DEFB    0
_MPY    DEFB    0
_OADRS  DEFW    0
ADRES   DEFW    0
;
EOF     DISPLAY EOF
        ORG     #8700
TABSCR  DEFW    #4000,#4020,#4040,#4060,#4080,#40A0
        DEFW    #40C0,#40E0,#4800,#4820,#4840,#4860
        DEFW    #4880,#48A0,#48C0,#48E0,#5000,#5020
        DEFW    #5040,#5060,#5080,#50A0,#50C0,#50E0
;
        ORG     #8800
FONT
;       .INCBIN FONT
        ORG     37807
;       .INCBIN DATA2
        .RUN    #8000

