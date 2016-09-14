        ORG     #8002
;
START   EQU     #9000
REG_AY  EQU     #FFFD
DAT_AY  EQU     #BFFD
;
        DI
        LD      A,1
        OUT     (#FE),A
        CALL    CLS
        LD      A,#7F
        LD      I,A
        IM      2
        LD      HL,ADRINT
        LD      (#7FFF),HL
        LD      DE,0
        LD      HL,TXT1
        CALL    PRI_BB
L1
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,L1
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
        LD      (ADRES),HL
        EI
        CALL    INPUT

        CALL    PRINT

LOOP
        LD      A,1
        OUT     (#FE),A
;
        LD      A,#7F
        IN      A,(#FE)
        RRA                     ;EXIT FROM PROGRAM
        JR      C,CONT1         ;BY <SPACE>
        DI
        LD      A,#3F
        LD      I,A
        IM      1
        EI
        RET
CONT1
        RRA                     ;INC 1 ADDRESS
        JR      C,CONT2         ;BY <SHIFT>
        LD      HL,(ADRES)
        INC     HL
        LD      (ADRES),HL
        CALL    PRINT
        JR      LOOP
CONT2
        RRA                     ;DEC 1 ADDRESS
        JR      C,CONT3         ;BY <M>
        LD      HL,(ADRES)
        DEC     HL
        LD      (ADRES),HL
        CALL    PRINT
        JR      LOOP
CONT3
        RRA                     ;INC 256 ADDRESS
        JR      C,CONT4         ;BY "N"
        LD      HL,(ADRES)
        INC     H
        LD      (ADRES),HL
        CALL    PRINT
        CALL    PAUSE
        JR      LOOP
CONT4
        RRA                     ;DEC 256 ADDRESS
        JR      C,CONT5         ;BY "B"
        LD      HL,(ADRES)
        DEC     H
        LD      (ADRES),HL
        CALL    PRINT
        CALL    PAUSE
        JR      LOOP
CONT5
        LD      A,#BF           ;REINPUT DATA
        IN      A,(#FE)         ;BY <ENTER>
        RRA
        JP      C,LOOKOUT
        LD      A,4
        OUT     (#FE),A
        CALL    INPUT
        CALL    PRINT
        JP      LOOP
LOOKOUT
        RRA                     ;LOOKOUT DATA
        JP      C,LOOP          ;BY <L>
;
LOOK1
        LD      A,2
        OUT     (#FE),A
        LD      A,#7F           ;EXIT FROM LOOKOUT
        IN      A,(#FE)         ;BY <SHIFT>
        RRA
        RRA
        JP      NC,LOOP
;        ****************
;------- *** GET INFO *** -------
;        ****************
        DI
        LD      BC,REG_AY
L_000
        IN      A,(C)
        RRA
        JP      C,L_000

        LD      HL,#0090
        CALL    PAUSE1

        IN      A,(C)
        RRA
        JP      C,L_000
L_001
        IN      A,(C)           ;SEARCH 1
        RRA
        JP      NC,L_001
;
        CALL    GET_1_
        LD      (#4000),A
        CALL    GET_1_
        LD      (#4100),A
        CALL    GET_1_
        LD      (#4200),A
        CALL    GET_1_
        LD      (#4300),A
        CALL    GET_1_
        LD      (#4400),A
        CALL    GET_1_
        LD      (#4500),A
        CALL    GET_1_
        LD      (#4600),A
        CALL    GET_1_
        LD      (#4700),A
;
        CALL    GET_1_
        LD      (#4020),A
        CALL    GET_1_
        LD      (#4120),A
        CALL    GET_1_
        LD      (#4220),A
        CALL    GET_1_
        LD      (#4320),A
        CALL    GET_1_
        LD      (#4420),A
        CALL    GET_1_
        LD      (#4520),A
        EI
        HALT
;
        JP      LOOK1
;------------------------
GET_1_
        LD      BC,REG_AY
        LD      L,0
        CALL    GET_BYT
        RL      L
        CALL    GET_BYT
        RL      L
        CALL    GET_BYT
        RL      L
        CALL    GET_BYT
        RL      L
        CALL    GET_BYT
        RL      L
        CALL    GET_BYT
        RL      L
        CALL    GET_BYT
        RL      L
        CALL    GET_BYT
        RL      L
        LD      A,L
        RET
;
GET_BYT
        IN      A,(C)
        RRA
        BIT     1,A             ;NOT STROB
        JP      Z,GET_BYT
        RRA
        PUSH    AF
GET_BYT1
        IN      A,(C)
        BIT     2,A
        JP      NZ,GET_BYT1
        POP     AF
        RET
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
        LD      B,#33
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
;----------------------
;GENERAL INPUT FROM BUS
;----------------------
INPUT
        LD      BC,REG_AY       ;SELECT 7 REGISTER
        LD      A,7
        OUT     (C),A
        LD      BC,DAT_AY
        LD      A,#80           ;A PORT - INPUT
        OUT     (C),A           ;B PORT - OUTPUT
;
        LD      BC,REG_AY       ;SELECT B PORT
        LD      A,15
        OUT     (C),A
        LD      BC,DAT_AY       ;B PORT = #FF
        LD      A,#FF
        OUT     (C),A
;
        LD      BC,REG_AY       ;SELECT A PORT
        LD      A,14
        OUT     (C),A
;
        LD      HL,START
        LD      BC,REG_AY
LOOP_I
        INI
        INC     B
        LD      A,H
        AND     A
        JP      NZ,LOOP_I
        RET
;
ADRINT  PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      A,0
        OUT     (#FE),A
        LD      HL,(_OADRS)
        LD      (TMP1),HL
        LD      HL,(_MPX)
        LD      (TMP2),HL
;
        LD      HL,#0A00
        LD      (_MPX),HL
        CALL    _OOR_Y
        LD      A,(#4000)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4100)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4200)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4300)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4400)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4500)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4600)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4700)
        CALL    PRIHB
;
        INC     (HL)
        LD      A,(#4020)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4120)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4220)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4320)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4420)
        CALL    PRIHB
        INC     (HL)
        LD      A,(#4520)
        CALL    PRIHB
;
        LD      HL,0
TMP1    EQU     $-2
        LD      (_OADRS),HL
        LD      HL,0
TMP2    EQU     $-2
        LD      (_MPX),HL
        LD      A,6
        OUT     (#FE),A
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        EI
        RET
;----------------
TXT1    DEFB    "PRESS <SPACE> TO INPUT DATA FROM I2C",0
TXT2    DEFB    "SHOW CHANNELS FROM ADDRESS:",0
TXT20   DEFB    "     |0   |1   |2   |3   |4   |5   |6   |7"
        DEFB    "   |8   |9   |10",0
TXT3    DEFB    "CH0>",0
TXT4    DEFB    "CH1>",0
TXT5    DEFB    "CH2>",0
TXTHLP1 DEFB    "HELP: <SPACE> - EXIT",0
        DEFB    "<SHIFT> - RIGHT 1, <M> - LEFT 1",0
        DEFB    "<N> - RIGHT 256, <B> - LEFT 256",0
        DEFB    "<L> - MODE LOOK (<SHIFT> - EXIT)",0
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
        .RUN    #8002

