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
        LD      DE,#0000
        LD      HL,TXT0
        CALL    PRI_BB
        CALL    INIT
        LD      A,#7F
        LD      I,A
        IM      2
        LD      HL,ADRINT
        LD      (#7FFF),HL
LOOP
        LD      A,1
        OUT     (#FE),A
;
        LD      A,#7F
        IN      A,(#FE)
        RRA                     ;EXIT FROM PROGRAM
        JP      C,LOOK1         ;BY <SPACE>
        DI
        LD      A,#3F
        LD      I,A
        IM      1
        EI
        RET
LOOK1
;        ****************
;------- *** GET INFO *** -------
;        ****************
        DI
        LD      BC,REG_AY
L_000
        IN      A,(C)
        RRA
        JP      C,L_000

        LD      HL,#0110
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
        LD      (REG00),A
        CALL    GET_1_
        LD      (REG01),A
        CALL    GET_1_
        LD      (REG02),A
        CALL    GET_1_
        LD      (REG03),A
        CALL    GET_1_
        LD      (REG04),A
        CALL    GET_1_
        LD      (REG05),A
        CALL    GET_1_
        LD      (REG06),A
        CALL    GET_1_
        LD      (REG07),A
;
        CALL    GET_1_
        LD      (REG08),A
        CALL    GET_1_
        LD      (REG09),A
        CALL    GET_1_
        LD      (REG0A),A
        CALL    GET_1_
        LD      (REG0B),A
        CALL    GET_1_
        LD      (REG0C),A
        CALL    GET_1_
        LD      (REG0D),A
        EI
        HALT
;
        JP      LOOP
;------------------------
GET_1_
;       LD      BC,REG_AY
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
CLS
        LD      HL,#4000
        LD      D,H
        LD      E,L
        INC     DE
        LD      BC,#17FF
        LD      (HL),L
        LDIR
        RET
;
PAUSE1
        DEC     HL
        LD      A,L
        OR      H
        JP      NZ,PAUSE1
        RET
;========================
INIT
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
        LD      A,#1E
        OUT     (C),A
;
        LD      BC,REG_AY       ;SELECT A PORT
        LD      A,14
        OUT     (C),A
        RET
;
ADRINT  PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      A,0
        OUT     (#FE),A
;       LD      HL,(_OADRS)
;       LD      (TMP1),HL
;       LD      HL,(_MPX)
;       LD      (TMP2),HL
;
        LD      HL,#0200
        LD      (_MPX),HL
        CALL    _OOR_Y
        LD      A,0
REG00   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG01   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG02   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG03   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG04   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG05   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG06   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG07   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG08   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG09   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG0A   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG0B   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG0C   EQU     $-1
        CALL    PRIHB
        INC     (HL)
        LD      A,0
REG0D   EQU     $-1
        CALL    PRIHB
;
;       LD      HL,0
;MP1    EQU     $-2
;       LD      (_OADRS),HL
;       LD      HL,0
;MP2    EQU     $-2
;       LD      (_MPX),HL
;
        LD      A,6
        OUT     (#FE),A
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        EI
        RET
;===============================
TXT0    DEFB    "00-01-02-03-04-05-06-07-08-09-0A-0B-0C-0D",0
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

