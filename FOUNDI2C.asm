        ORG     #8000
;------------------------------------
; Program For Read/Write EEPROM 24C02
; PA0=SDA (Data)  (#1F)
; PB0=SCL (Clock) (#3F)
;------------------------------------
;1C CLS
;1D Set X
;1E Set X,Y
;1F Fill Sym,Num
;FF Inverse
;-----------------
SDA     EQU     #1F
SCL     EQU     #3F
PORTSET EQU     #7F
TIMEP   EQU     #01
BORDER  EQU     0
BORDER2 EQU     2
ACKTIME EQU     #1000
FIRSTADR EQU    #00
;
        DI
        LD      A,BORDER
        OUT     (#FE),A
        LD      A,#80
        OUT     (PORTSET),A
        CALL    STOP
;
        CALL    PRI_T
        DEFB    #1C,#FF
        DEFB    " Search Address of Devices on I2C Bus ",#FF
        DEFB    " Copyright 2000 By (R)soft",13,13
        DEFB    "Please Wait for Scanning Device Addresses "
        DEFB    "on I2C Bus.",13
        DEFB    "Or Press <SPACE> to Abort...",13,13
        DEFB    "Scan Address: #",0
        XOR     A
        LD      (DEVFOUN),A
        LD      A,FIRSTADR
        LD      (SCANADR),A
LOOPADR
        LD      A,(SCANADR)
        CALL    PRIHB
        CALL    START
        LD      A,(SCANADR)
        CALL    PUTBYTE
        CALL    GETACK
        JR      NC,LOOP1
        CALL    STOP
        LD      HL,TMPX
        DEC     (HL)
        DEC     (HL)
LOOPC
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JP      NC,ABORT
        LD      HL,SCANADR
        INC     (HL)
        JR      NZ,LOOPADR
        EI
        CALL    PRI_T
        DEFB    #1D,0,#1F," ",20,#1D,0,0
        LD      A,0
DEVFOUN EQU     $-1
        AND     A
        RET     NZ
        CALL    PRI_T
        DEFB    "Devices Not Found.",0
        RET
LOOP1
        CALL    STOP
        CALL    PRI_T
        DEFB    #1D,0,"Found Device",0
        LD      B,6
        LD      HL,TMPX
        INC     (HL)
        DJNZ    $-1
        LD      A,(SCANADR)
        BIT     0,A
        JR      NZ,LOOP1R       ;Bit 0=1 -> Read Mode
        CALL    PRI_T
        DEFB    "(Write)",13,0
        JR      LOOP1C
LOOP1R
        CALL    PRI_T
        DEFB    "(Read)",13,0
LOOP1C
        CALL    PRI_T
        DEFB    "Scan Address: #",0
        LD      A,#FF
        LD      (DEVFOUN),A
        JP      LOOPC
ABORT
        CALL    STOP
        CALL    PRI_T
        DEFB    13,13,"Aborting...",13,0
        EI
        RET
GETACK
        LD      A,#FF
        OUT     (SDA),A         ;SDA -> 1
        CALL    PAUSE
        OUT     (SCL),A         ;SCL -> 1
        CALL    PAUSE
        LD      BC,ACKTIME
GETA1
        DEC     BC              ;Counter of Wait
        LD      A,C
        OR      B
        JR      Z,GETERR
        IN      A,(SDA)         ;Wait To SDA=0
        BIT     0,A
        JR      NZ,GETA1
        XOR     A
        OUT     (SCL),A         ;SCL -> 0  (Res CARRY)
        CALL    PAUSE
        RET
GETERR
        XOR     A
        OUT     (SCL),A
        CALL    PAUSE
        SCF                     ;Set CARRY -> NO ACK
        RET
PAUSEDE
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ,PAUSEDE
        RET
PUTBYTE
        LD      B,8
PUTBL
        RLA
        PUSH    AF
        LD      A,#FF
        JR      C,PUTB1
        LD      A,0
PUTB1
        OUT     (SDA),A
        CALL    PAUSE
        LD      A,#FF
        OUT     (SCL),A
        CALL    PAUSE
        LD      A,0
        OUT     (SCL),A
        CALL    PAUSE
        POP     AF
        DJNZ    PUTBL
;
        LD      A,#FF
        OUT     (SDA),A
        CALL    PAUSE
        RET

START
        PUSH    AF
        LD      A,#FF
        OUT     (SCL),A
        CALL    PAUSE
        XOR     A
        OUT     (SDA),A
        CALL    PAUSE
        OUT     (SCL),A
        CALL    PAUSE
        LD      A,#FF
        OUT     (SDA),A
        CALL    PAUSE
        POP     AF
        RET
STOP
        PUSH    AF
        XOR     A
        OUT     (SDA),A
        CALL    PAUSE
        LD      A,#FF
        OUT     (SCL),A
        CALL    PAUSE
        OUT     (SDA),A
        CALL    PAUSE
        POP     AF
        RET
PAUSE
        PUSH    AF
        LD      A,BORDER2
        OUT     (#FE),A
        PUSH    BC
        LD      B,TIMEP
        DJNZ    $
        POP     BC
        LD      A,BORDER
        OUT     (#FE),A
        POP     AF
        RET
;
PRI_T   POP     HL
        CALL    PRI_BB
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
TMPX    DEFB    0
TMPY    DEFB    0
SCANADR DEFB    0
;
;
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



