        ORG     #8002
;-----------------------------------------
;Program Driver For LCD Display HT1613 (SC-1611M10T)
;(C) By (R)soft 16.4.2000
;Connected To Port #3F
;BIT0 - CLOCK
;BIT1 - DATA
;BIT2 - POWER
;Keys 1-0 For Change Indicate
;Press SPACE To Exit Program
;------------------------------------------
PORT    EQU     #3F
PORTSET EQU     #7F
        DI
        LD      A,#80
        OUT     (PORTSET),A
        CALL    POWER_HT
;       CALL    CLS_HT
        LD      HL,INT_HT
        LD      (#7FFF),HL
        LD      A,#7F
        LD      I,A
        IM      2
        EI
;
KEYLOOP0
        LD      A,5
        OUT     (#FE),A
        LD      HL,0
        LD      DE,0
        LD      BC,704
        LDIR
;
        LD      BC,#05FF
        LD      A,#F7
        IN      A,(#FE)
KEYLOOP1
        INC     C
        RRA
        JR      NC,KEYS1
        DJNZ    KEYLOOP1
;
        LD      BC,#050A
        LD      A,#EF
        IN      A,(#FE)
KEYLOOP2
        DEC     C
        RRA
        JR      NC,KEYS1
        DJNZ    KEYLOOP2
;
        XOR     A
        OUT     (#FE),A
        HALT
;
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,KEYLOOP0
;
        DI
        LD      A,#3F
        LD      I,A
        IM      1
        XOR     A
        OUT     (PORT),A
        EI
        RET
KEYS1
        LD      HL,BUFER
        LD      B,0
        ADD     HL,BC
        LD      A,#FE           ;Key CAPS
        IN      A,(#FE)
        RRA
        JR      NC,MINUS
        LD      A,(HL)
        AND     A
        JR      Z,KEYLOOP0
        CP      10
        JR      NZ,$+5
        LD      (HL),0
        XOR     A
        CP      9
        JR      NC,KEYLOOP0
        INC     (HL)
        CALL    PAUSE2
        JR      KEYLOOP0
MINUS
        LD      A,(HL)
        AND     A
        JR      Z,KEYLOOP0
        CP      10
        JR      NC,KEYLOOP0
        CP      2
        JR      NC,$+4
        LD      (HL),11
        DEC     (HL)
        CALL    PAUSE2
        JR      KEYLOOP0
INT_HT
        PUSH    AF
        PUSH    HL
        PUSH    DE
        PUSH    BC
        LD      HL,BUFER
        CALL    WIEV_HT2
        POP     BC
        POP     DE
        POP     HL
        POP     AF
        EI
        RET
;------- 0.50 mSec -----------
WIEV_HT2
        LD      BC,#5A3F        ;10     B=90
WIEV_HTL2
        LD      A,(HL)          ;7
        INC     HL              ;6
        ADD     A,A             ;4
        ADD     A,A             ;4
        ADD     A,A     ;x8     ;4
        EX      DE,HL           ;4
        LD      H,#BF           ;    Addr Table Of Numbers
        LD      L,A             ;4
        OUTI
        OUTI
        OUTI
        OUTI
        OUTI
        OUTI
        OUTI
        OUTI                    ;128
        EX      DE,HL           ;4
        DJNZ    WIEV_HTL2       ;8/13
        LD      A,4             ;7
        OUT     (PORT),A        ;11     SCL=0 SDA=0
        RET                     ;All
;------ 0.68 mSec --------
WIEV_HT
        LD      BC,#0A3F        ;10
WIEV_HTL
        LD      A,(HL)          ;7
        INC     HL              ;6
        RLA                     ;4
        RLA                     ;4
        RLA                     ;4
        RLA                     ;4      =29
;1 Takt
        RLA                     ;4
        LD      DE,#0706        ;10
        JR      C,$+5           ;7/12
        LD      DE,#0504        ;10
        OUT     (C),D           ;12
        OUT     (C),E           ;12     =55/60
;2 Takt
        RLA                     ;4
        LD      DE,#0706        ;10
        JR      C,$+5           ;7/12
        LD      DE,#0504        ;10
        OUT     (C),D           ;12
        OUT     (C),E           ;12     =55/60
;3 Takt
        RLA                     ;4
        LD      DE,#0706        ;10
        JR      C,$+5           ;7/12
        LD      DE,#0504        ;10
        OUT     (C),D           ;12
        OUT     (C),E           ;12     =55/60
;4 Takt
        RLA                     ;4
        LD      DE,#0706        ;10
        JR      C,$+5           ;7/12
        LD      DE,#0504        ;10
        OUT     (C),D           ;12
        OUT     (C),E           ;12     =55/60
;
        DJNZ    WIEV_HTL        ;8/13
        LD      A,4             ;7
        OUT     (PORT),A        ;11     SCL=0 SDA=0
        RET                     ;All 2643/2843 Takts
PAUSE
        PUSH    BC
        LD      B,10
        DJNZ    $
        POP     BC
        RET
CLS_HT
        LD      BC,#283F        ;10
        LD      DE,#0504        ;10
CLS_HTL
        OUT     (C),D           ;12     SCL=1 SDA=0
        OUT     (C),E           ;12     SCL=0 SDA=0
        DJNZ    CLS_HTL         ;8/13
        RET                     ;All 1495 Takts
POWER_HT
        LD      A,4             ;POWER ON, SCL=0 SDA=0
        OUT     (PORT),A
        RET
PAUSE2
        PUSH    DE
        LD      DE,#5000
PAUSE20
        DEC     DE
        LD      A,D
        OR      E
        JR      NZ,PAUSE20
        POP     DE
        RET
BUFER   DEFB    #0E,#01,#02,#0A,#0A,#00,#0B,#03,#07,#0A
;
        ORG     #BF00
TABNUMER
        DEFB    5,4,5,4,5,4,5,4
        DEFB    5,4,5,4,5,4,7,6
        DEFB    5,4,5,4,7,6,5,4
        DEFB    5,4,5,4,7,6,7,6
        DEFB    5,4,7,6,5,4,5,4
        DEFB    5,4,7,6,5,4,7,6
        DEFB    5,4,7,6,7,6,5,4
        DEFB    5,4,7,6,7,6,7,6
;
        DEFB    7,6,5,4,5,4,5,4
        DEFB    7,6,5,4,5,4,7,6
        DEFB    7,6,5,4,7,6,5,4
        DEFB    7,6,5,4,7,6,7,6
        DEFB    7,6,7,6,5,4,5,4
        DEFB    7,6,7,6,5,4,7,6
        DEFB    7,6,7,6,7,6,5,4
        DEFB    7,6,7,6,7,6,7,6
;
        .RUN    #8002

