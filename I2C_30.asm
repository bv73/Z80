;==========================================
;== Panelboard interface for KANSAI tape ==
;== Written by (R)soft 27.2.1999         ==
;== Connect to AY port A                 ==
;== Bit0 - Enable Data  (Pin 3 on tape)  ==
;== Bit1 - Serial Data  (Pin 1)          ==
;== Bit2 - Serial Clock (Pin 2)          ==
;== GND (Pin 4)                          ==
;== Oscillator by 1MHz  (Old by 4,5MHz)  ==
;==========================================
        ORG     #8001
;
START   EQU     #9000
REG_AY  EQU     #FFFD
DAT_AY  EQU     #BFFD
SEG0    EQU     0       ;8
SEG1    EQU     #38
SEG7    EQU     7
;
        DI
        CALL    CLS
        LD      DE,#0000
        LD      HL,TXT0
        CALL    PRI_BB
        LD      DE,#0D00
        LD      HL,TXT1
        CALL    PRI_BB
        LD      DE,#0F00
        LD      HL,TXT2
        CALL    PRI_BB
;
        CALL    INIT
        LD      A,#7F
        LD      I,A
        IM      2
        LD      HL,ADRINT
        LD      (#7FFF),HL
LOOP
        LD      A,0             ;1
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
        LD      HL,0
L_000                           ;SEARCH 0
        IN      A,(C)
        RRA
        JP      C,L_000

        LD      HL,#0110
        CALL    PAUSE1

        IN      A,(C)
        RRA
        JP      C,L_000
L_001
        DEC     HL
        LD      A,H
        CP      #10
        JP      Z,EXIT_Z
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
EXIT_Z
        EI
        HALT
;
        JP      LOOP
;------------------------
GET_1_
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
        LD      A,(REG00)
        LD      HL,#0402
        CALL    SEGMENT
        CALL    SEGMENT7
        LD      A,(REG01)
        LD      HL,#0407
        CALL    SEGMENT
        CALL    SEGMENT7
        LD      A,(REG02)
        LD      HL,#040E
        CALL    SEGMENT
        CALL    SEGMENT7
        LD      A,(REG03)
        LD      HL,#0413
        CALL    SEGMENT
        CALL    SEGMENT7
;
        LD      HL,#59B7
        LD      A,(REG04)
        BIT     7,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
;
        LD      A,(REG04)
        LD      HL,#0F17
        CALL    SEGMENT
        CALL    OTHERS
        CALL    OTHERS0
        CALL    OTHERS1
;
        LD      A,6
        OUT     (#FE),A
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        EI
        RET
OTHERS1
;POINT0
        LD      HL,#5972
        LD      A,(REG06)
        BIT     6,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
;POINT1
        LD      DE,5
        ADD     HL,DE
        BIT     7,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
;POINT:
        LD      HL,#58CC
        LD      A,(REG07)
        BIT     4,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        LD      DE,#40
        ADD     HL,DE
        LD      (HL),B
;POINT[]
        LD      HL,#59BC
        LD      A,(REG08)
        BIT     2,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
;AM
        LD      HL,#59FC
        LD      A,(REG08)
        BIT     0,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;FM
        LD      A,(REG09)
        BIT     7,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;||
        LD      A,(REG08)
        BIT     5,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;|
        BIT     4,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        RET
;
OTHERS0
;TREBLE
        LD      HL,#59E0
        LD      A,(REG09)
        BIT     1,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        INC     HL
;BASS
        LD      A,(REG05)
        BIT     2,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        INC     HL
;SEARCH
        LD      A,(REG0A)
        BIT     7,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        INC     HL
;??
        LD      A,(REG07)
        BIT     0,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
;TUNER
        LD      DE,4
        ADD     HL,DE
        LD      A,(REG08)
        BIT     1,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
        RET
;
OTHERS
        LD      HL,#59A4
        LD      A,(REG05)
;9VOL
        BIT     1,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;8VOL
        BIT     0,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      A,(REG07)
;7VOL
        BIT     7,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;6VOL
        BIT     6,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;5VOL
        BIT     5,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;4VOL
        BIT     2,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;3VOL
        BIT     3,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;2VOL
        LD      A,(REG08)
        BIT     6,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
;1VOL
        BIT     7,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
;TAPE
        LD      DE,6
        ADD     HL,DE
        LD      A,(REG05)
        BIT     4,A
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        BIT     5,A
        LD      B,SEG0
        JR      Z,$+4
        LD      B,SEG1
        LD      (HL),B
        AND     #30
        LD      B,SEG7
        JR      NZ,$+4
        LD      B,SEG0
        DEC     HL
        DEC     HL
        DEC     HL
        DEC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),B
        RET
SEGMENT
        LD      C,A
        LD      A,L
        LD      L,H
        LD      H,0
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     A,L
        JR      NC,$+3
        INC     H
        LD      L,A
        LD      DE,#5800
        ADD     HL,DE
        LD      (ADRSEGM),HL
;- 0 Segment
        LD      DE,#00C1
        ADD     HL,DE
        BIT     0,C
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      (HL),B
;- 1 Segment
        LD      HL,0
ADRSEGM EQU     $-2
        LD      E,#83
        ADD     HL,DE
;
        BIT     1,C
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        LD      E,#20
        ADD     HL,DE
        LD      (HL),B
;- 2 Segment
        LD      HL,(ADRSEGM)
        LD      E,#80
        ADD     HL,DE
;
        BIT     2,C
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        LD      E,#20
        ADD     HL,DE
        LD      (HL),B
;- 3 Segment
        LD      HL,(ADRSEGM)
        LD      E,#61
        ADD     HL,DE
;
        BIT     3,C
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      (HL),B
;- 4 Segment
        LD      HL,(ADRSEGM)
        LD      E,#20
        ADD     HL,DE
;
        BIT     4,C
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        LD      E,#20
        ADD     HL,DE
        LD      (HL),B
;- 5 Segment
        LD      HL,(ADRSEGM)
        LD      E,#23
        ADD     HL,DE
;
        BIT     5,C
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        LD      E,#20
        ADD     HL,DE
        LD      (HL),B
;- 6 Segment
        LD      HL,(ADRSEGM)
        INC     HL
;
        BIT     6,C
        LD      B,SEG1
        JR      NZ,$+4
        LD      B,SEG0
        LD      (HL),B
        INC     HL
        LD      (HL),B
        RET
SEGMENT7
        LD      HL,(ADRSEGM)
        BIT     7,C
        JP      Z,SEGSEV
        LD      B,SEG1
        LD      (HL),B
        ADD     HL,DE
        LD      (HL),B
        ADD     HL,DE
        LD      (HL),B
        ADD     HL,DE
        LD      (HL),B
        ADD     HL,DE
        LD      (HL),B
        ADD     HL,DE
        LD      (HL),B
        ADD     HL,DE
        LD      (HL),B
        RET
SEGSEV
        LD      B,SEG0
        LD      (HL),B
        ADD     HL,DE
        ADD     HL,DE
        ADD     HL,DE
        LD      (HL),B
        ADD     HL,DE
        ADD     HL,DE
        ADD     HL,DE
        LD      (HL),B
        RET

;===============================
TXT0    DEFB    "00-01-02-03-04-05-06-07-08-09-0A-0B-0C-0D "
        DEFB    "PANELBOARD V1.1",0
TXT1    DEFB    "MAXIMUM <<<<<<<<<>>>>>>>>>     TAPE <==>"
        DEFB    "      PROGRAM   []",0
TXT2    DEFB    "TREBLE  BASS  SEARCH  ??       < TUNER >"
        DEFB    "                AMFM|||",0
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
        .RUN    #8001

