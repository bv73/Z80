        ORG     #8000
;
START   EQU     #9000
REG_AY  EQU     #FFFD
DAT_AY  EQU     #BFFD
;
        DI
        LD      A,1
        OUT     (#FE),A
        CALL    CLS
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
        JP      NC,LOOK1        ;BY <L>
        RRA                     ;SEARCH START SECTION
        JP      NC,SEARCH       ;BY <K>
        RRA                     ;MODE SENDING CODE
        JP      C,LOOP          ;BY <J>
;----------------------
SENDCODE
        LD      BC,REG_AY       ;SELECT B PORT
        LD      A,15
        OUT     (C),A
LOOPSEND
        DI
        LD      A,3
        OUT     (#FE),A
LOOPS1
        EI
        HALT
        LD      HL,23560
        LD      A,(HL)
        AND     A
        JP      Z,LOOPSEND
        LD      (HL),0
        CP      15
        JP      NZ,LOOPS2

        LD      BC,REG_AY       ;SELECT A PORT
        LD      A,14
        OUT     (C),A
        JP      LOOP
LOOPS2
        LD      B,8
        LD      E,A
LOOPSM_0
        PUSH    BC
        RL      E
        RL      A
        OR      #FE
        LD      BC,DAT_AY
        OUT     (C),A
        POP     BC
        DJNZ    LOOPSM_0

        LD      A,#FF           ;SET TO 1
        LD      BC,DAT_AY
        OUT     (C),A

        JP      LOOPSEND
;---------------------------
SEARCH
        XOR     A               ;SEARCH START SECTION
        OUT     (#FE),A         ;BY <K>
        LD      A,#7F
        IN      A,(#FE)         ;EXIT FROM SEARCH
        RRA                     ;BY <SHIFT>
        RRA
        JP      NC,LOOP
        LD      BC,REG_AY
SEARCH1
        IN      A,(C)
        RRA
        JP      NC,SEARCH       ;CS is NOT 1
        RRA
        JP      NC,SEARCH       ;SDA is NOT 1
        RRA
        JP      NC,SEARCH       ;SCL is NOT 1

;Wait SDA in 0

SEARCH2
        IN      A,(C)
        RRA
        JP      NC,SEARCH       ;CS is NOT 1
        RRA
        JP      C,SEARCH2       ;SDA in 1
        RRA
        JP      NC,SEARCH       ;SCL is NOT 1

;SDA in 0,
;SCL in 1, Wait SCL in 0

SEARCH3
        IN      A,(C)
        RRA
        JP      NC,SEARCH       ;CS is NOT 1
        RRA
        JP      C,SEARCH        ;SDA is NOT 0
        RRA
        JP      C,SEARCH3       ;SCL in 1

;SDA in 0
;SCL in 0
;*** START SECTION ***

        LD      A,7
        OUT     (#FE),A
        EI
        HALT
        DI
        JP      SEARCH
LOOK1
        LD      A,2
        OUT     (#FE),A
        LD      A,#7F           ;EXIT FROM LOOKOUT
        IN      A,(#FE)         ;BY <SHIFT>
        RRA
        RRA
        JP      NC,LOOP

        CALL    GET_1_
        LD      (#4000),HL
        CALL    GET_1_
        LD      (#4100),HL
        CALL    GET_1_
        LD      (#4200),HL
        CALL    GET_1_
        LD      (#4300),HL
        CALL    GET_1_
        LD      (#4400),HL
        CALL    GET_1_
        LD      (#4500),HL
        CALL    GET_1_
        LD      (#4600),HL
        CALL    GET_1_
        LD      (#4700),HL
;
        CALL    GET_1_
        LD      (#4020),HL
        CALL    GET_1_
        LD      (#4120),HL
        CALL    GET_1_
        LD      (#4220),HL
        CALL    GET_1_
        LD      (#4320),HL
        CALL    GET_1_
        LD      (#4420),HL
        CALL    GET_1_
        LD      (#4520),HL
        CALL    GET_1_
        LD      (#4620),HL
        CALL    GET_1_
        LD      (#4720),HL
;
        JP      LOOK1
;------------------------
GET_1_
        LD      HL,0
HANDH
        LD      BC,REG_AY
;
HANDH1
        IN      A,(C)           ;STROB 1
        RRA
        JP      NC,HANDH1
;
        LD      B,14
LP_H
        PUSH    BC
        CALL    GET_BYT
        RL      L
        RL      H
        POP     BC
        DJNZ    LP_H
        RET

GET_BYT
        LD      BC,REG_AY
GET_BYT0
        IN      A,(C)
        RRA
        BIT     1,A             ;NOT STROB
        JP      Z,GET_BYT0
        RRA
        PUSH    AF
GET_BYT1
        IN      A,(C)
        RRA
        BIT     1,A
        JP      NZ,GET_BYT1
        POP     AF
        RET




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
        DEFB    "<L> - MODE LOOKOUT (<SHIFT> - EXIT)",0
        DEFB    "<K> - MODE SEARCH START SECTION (<SHIFT> - EXIT)",0
        DEFB    "<J> - MODE SEND CODE (GRF - EXIT)",0
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
        CALL    PRI_BB
        LD      DE,#1406
        CALL    PRI_BB
        LD      DE,#1506
        JP      PRI_BB
;
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
        .RUN    #8000
