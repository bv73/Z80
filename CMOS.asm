        ORG     #8000
;
RTCDAT  EQU     #BFF7
RTCDATH EQU     #BF
RTCADR  EQU     #DFF7
RTCADRH EQU     #DF
RTCEN   EQU     #EFF7
RTCENH  EQU     #EF
;----- Register A ------
DV      EQU     #20     ;Oscillator 32768 Hz
RS      EQU     6       ;Freq SQW 1024 Hz
;----- Register B -----
CSET    EQU     #80
UIE     EQU     #10
H24     EQU     2
;----------------------
        DI
;       CALL    SETTIME
;       CALL    WRITXT
LOOP
        DI
        CALL    UPDATE
        LD      HL,0
        LD      (TMPX),HL
        CALL    KOOR_Y
        LD      A,(#C004)
        CALL    PRIHB
        LD      A,":"
        CALL    PRIA
        LD      A,(#C002)
        CALL    PRIHB
        LD      A,":"
        CALL    PRIA
        LD      A,(#C000)
        CALL    PRIHB
        LD      HL,TMPX
        LD      (HL),12
        LD      A,(#C007)
        CALL    PRIHB
        LD      A,"."
        CALL    PRIA
        LD      A,(#C008)
        CALL    PRIHB
        LD      A,"."
        CALL    PRIA
        LD      A,"1"
        CALL    PRIA
        LD      A,"9"
        CALL    PRIA
        LD      A,(#C009)
        CALL    PRIHB
        EI
        HALT
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,LOOP
        EI
        RET
UPDATE
        LD      HL,#C000
        LD      D,#0A
UPD1
        CALL    RDRTC
        RLA
        JR      C,UPD1
        LD      D,0
UPD2
        CALL    RDRTC
        LD      (HL),A
        INC     HL
        INC     D
        LD      A,D
        CP      #40
        JR      NZ,UPD2
        RET
WRITXT
        LD      HL,TEXT
        LD      D,#0E
WRT2
        LD      E,(HL)
        CALL    WRRTC
        INC     HL
        INC     D
        LD      A,D
        CP      #40
        JR      NZ,WRT2
        RET

SETTIME LD      D,#0A   ;ADR
        LD      E,DV+RS
        CALL    WRRTC
        INC     D
        LD      E,CSET+H24
        CALL    WRRTC
;
        LD      HL,HOUR
        LD      D,4
        LD      E,(HL)
        CALL    WRRTC           ;HOURS
        INC     HL
        LD      D,2
        LD      E,(HL)
        CALL    WRRTC           ;MINUTES
        LD      DE,0
        CALL    WRRTC           ;SECONDS
        INC     HL
        LD      D,6
        LD      E,(HL)
        CALL    WRRTC           ;DAY OF
        INC     HL
        INC     D
        LD      E,(HL)
        CALL    WRRTC           ;DATE
        INC     HL
        INC     D
        LD      E,(HL)
        CALL    WRRTC           ;MONTH
        INC     HL
        INC     D
        LD      E,(HL)
        CALL    WRRTC           ;YEAR
;
        LD      D,#0B
        CALL    RDRTC
        AND     #FF-CSET        ;Clock G0!
        OR      UIE             ;Interrupt by NEW
        LD      E,A
;
WRRTC   LD      A,#80
        LD      BC,RTCEN
        OUT     (C),A
        LD      B,RTCADRH
        LD      A,D
        OUT     (C),A
        LD      B,RTCDATH
        LD      A,E
        OUT     (C),A
        XOR     A
        LD      B,RTCENH
        OUT     (C),A
        RET
RDRTC   LD      A,#80
        LD      BC,RTCEN
        OUT     (C),A
        LD      B,RTCADRH
        LD      A,D
        OUT     (C),A
        LD      B,RTCDATH
        IN      E,(C)
        XOR     A
        LD      B,RTCENH
        OUT     (C),A
        LD      A,E
        RET
TEXT    DEFB    "        CMOS Timer Programming "
        DEFB    "By (R)soft         "
;
HOUR    DEFB    #05
MINUTE  DEFB    #34
DAYOF   DEFB    #04
DATE    DEFB    #11
MONTH   DEFB    #11
YEAR    DEFB    #99
;
TMPX    DEFB    0
TMPY    DEFB    0
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



