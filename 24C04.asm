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
ACKTIME EQU     #F000
PTIME   EQU     #01
BORDER2 EQU     2
BORDER  EQU     0
;
        DI
        LD      A,BORDER
        OUT     (#FE),A
        LD      A,#80
        OUT     (PORTSET),A
        LD      A,#FF
        OUT     (SCL),A
        OUT     (SDA),A
;
        CALL    PRI_T
        DEFB    #1C,#FF
        DEFB    " Driver For Read/Write on I2C Bus ",#FF
        DEFB    " Copyright 2000 By (R)soft",13
        DEFB    0
;
;=========== Read Sequence of Bytes From Adr ========
        LD      A,#A4
        LD      (DEVADR),A
        LD      A,0             ;From Adr EEPROM
        LD      HL,#C000        ;Read To
        LD      DE,#100         ;How Many
        CALL    RND_READ
        RET     C
        LD      HL,#C000
        LD      BC,#100
        LD      A,2             ;Koord Y
        CALL    PRINTB
        CALL    MMM
        EI
        RET
        CALL    PRESSP
        LD      HL,#C100
        LD      BC,#100
        LD      A,2
        CALL    PRINTB
        EI
        RET
;========== Read From EEPROM =============
        LD      HL,#C000        ;Read To
        LD      DE,#100         ;How Many
        CALL    READ
        RET
;========== Read One Byte From EEPROM ========
MMM
        LD      A,#00           ;Adr EEPROM
        CALL    READBYTE
        RET     C
        CALL    PRIHB
        LD      A,#C0
        CALL    READBYTE
        RET     C
        CALL    PRIHB
;       CALL    NNN
        EI
        RET
;========== Write One Byte To EEPROM ==========
NNN
        LD      A,"-"
        CALL    PRIA
        LD      A,#00           ;Adr EEPROM
        LD      C,#55           ;Byte To Write
        CALL    WRITEBYTE
        RET     C
        LD      A,#00
        CALL    READBYTE
        CALL    PRIHB
        RET
;
        LD      A,#C8
        LD      C,#55
        CALL    WRITEBYTE
        LD      A,#C8
        CALL    READBYTE
        CALL    PRIHB
        RET
;========== Write Sequence of Bytes From Adr ========
LLL
        LD      A,#C8           ;To Adr EEPROM
        LD      HL,#7FF0        ;From MEMORY
        LD      DE,8            ;How Many (Maximum 8)
        CALL    RND_WRITE
        RET
RND_READ
        LD      (POINTAD),A
;
        CALL    START
        LD      A,(DEVADR)
        RES     0,A             ;Write Mode
        CALL    PUTBYTE
        LD      A,1             ;!1
        CALL    GETACK
        JP      C,NOACK
        LD      A,0             ;ADR EEPROM
POINTAD EQU     $-1
        CALL    PUTBYTE
        LD      A,2             ;!2
        CALL    GETACK
        JP      C,NOACK
;
        CALL    START
        LD      A,(DEVADR)
        SET     0,A             ;Read Mode
        CALL    PUTBYTE
        LD      A,3             ;!3
        CALL    GETACK
        JP      C,NOACK
        DEC     DE
LOOPRDM
        CALL    GETBYTE
        LD      (HL),A
        INC     HL              ;!!!
        CALL    GIVEACK
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ,LOOPRDM
        CALL    GETBYTE
        LD      (HL),A
        CALL    GIVENACK
        CALL    STOP
        AND     A
        RET
READBYTE
        LD      (POINT1),A
;
        CALL    START
        LD      A,(DEVADR)
        RES     0,A             ;Write Mode
        CALL    PUTBYTE
        LD      A,4             ;!4
        CALL    GETACK
        JP      C,NOACK
        LD      A,0             ;ADR EEPROM
POINT1  EQU     $-1
        CALL    PUTBYTE
        LD      A,5             ;!5
        CALL    GETACK
        JP      C,NOACK
;
        CALL    START
        LD      A,(DEVADR)
        SET     0,A             ;Read Mode
        CALL    PUTBYTE
        LD      A,6             ;!6
        CALL    GETACK
        JP      C,NOACK
        CALL    GETBYTE
        CALL    GIVENACK
        CALL    STOP
        AND     A
        RET
READ
        CALL    START
        LD      A,(DEVADR)
        SET     0,A             ;Read Mode
        CALL    PUTBYTE
        LD      A,7             ;!7
        CALL    GETACK
        JR      C,NOACK
        DEC     DE
LOOPRD
        CALL    GETBYTE
        LD      (HL),A
        INC     HL
        CALL    GIVEACK
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ,LOOPRD
        CALL    GETBYTE
        LD      (HL),A
        CALL    GIVENACK
        CALL    STOP
        AND     A
        RET
NOACK
        PUSH    AF
        CALL    PRI_T
        DEFB    "Error ",0
        POP     AF
        CALL    DEC99
        CALL    PRI_T
        DEFB    "! No ACKNOWLEDGE Signal",0
        SCF
        RET
WRITEBYTE
        LD      (POINT2),A
        LD      A,C
        LD      (WBYTE),A
;
        CALL    START
        LD      A,(DEVADR)
        RES     0,A             ;Write Mode
        CALL    PUTBYTE
        LD      A,8             ;!8
        CALL    GETACK
        JP      C,NOACK
;
        LD      A,0             ;ADR EEPROM
POINT2  EQU     $-1
        CALL    PUTBYTE
        LD      A,9             ;!9
        CALL    GETACK
        JP      C,NOACK
;
        LD      A,0
WBYTE   EQU     $-1
        CALL    PUTBYTE
        LD      A,10            ;!10
        CALL    GETACK
        JP      C,NOACK
;
        CALL    START           ;Check Writing Byte
        LD      A,(DEVADR)
        RES     0,A             ;Write Mode
        CALL    PUTBYTE
        LD      A,11            ;!11
        CALL    GETACK
        JP      C,NOACK
        LD      A,(POINT2)      ;ADR EEPROM
        CALL    PUTBYTE
        LD      A,12            ;!12
        CALL    GETACK
        JP      C,NOACK
;
        CALL    START
        LD      A,(DEVADR)
        SET     0,A             ;Read Mode
        CALL    PUTBYTE
        LD      A,13            ;!13
        CALL    GETACK
        JP      C,NOACK
        CALL    GETBYTE
        CALL    GIVENACK
        CALL    STOP
        LD      HL,WBYTE
        CP      (HL)
        JR      NZ,ERRWRI
        AND     A
        RET
ERRWRI
        CALL    PRI_T
        DEFB    "Error 17! Illegal Writing To Memory!",13,0
        SCF
        RET
RND_WRITE
        LD      (POINT3),A
;
        CALL    START
        LD      A,(DEVADR)
        RES     0,A             ;Write Mode
        CALL    PUTBYTE
        LD      A,14            ;!14
        CALL    GETACK
        JP      C,NOACK
;
        LD      A,0             ;ADR EEPROM
POINT3  EQU     $-1
        CALL    PUTBYTE
        LD      A,15            ;!15
        CALL    GETACK
        JP      C,NOACK
RNDWR
        LD      A,(HL)
        INC     HL
        CALL    PUTBYTE
        LD      A,16            ;!16
        CALL    GETACK
        JP      C,NOACK
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ,RNDWR
;
        CALL    STOP
        AND     A
        RET
PRINTB
        LD      (PRINTBY),A
        PUSH    BC
        PUSH    HL
        CALL    PRI_T
        DEFB    #1E,0,2
PRINTBY EQU     $-1
        DEFB    "Addr| +0 +1 +2 +3 +4 +5 +6 +7 +8 "
        DEFB    "+9 +A +B +C +D +E +F",13
        DEFB    #1F,"-",53,13,0
        POP     HL
        PUSH    HL
        CALL    PRIHEX
        LD      A,":"
        CALL    PRIA
        LD      A," "
        CALL    PRIA
        POP     HL
        POP     BC
PRINTB1
        LD      A,(HL)
        INC     HL
        PUSH    BC
        PUSH    HL
        CALL    PRIHB
        LD      A," "
        CALL    PRIA
        LD      A,(TMPX)
        CP      48+6
        JR      C,NOEN
        CALL    PRI_T
        DEFB    13,0
        POP     HL
        PUSH    HL
        CALL    PRIHEX
        LD      A,":"
        CALL    PRIA
        LD      A," "
        CALL    PRIA
NOEN
        POP     HL
        POP     BC
        DEC     BC
        LD      A,C
        OR      B
        JR      NZ,PRINTB1
        RET
GIVEACK
        PUSH    AF
        XOR     A
        OUT     (SDA),A         ;SDA -> 0
        CALL    PAUSE
        LD      A,#FF
        OUT     (SCL),A         ;SCL -> 1
        CALL    PAUSE
        XOR     A
        OUT     (SCL),A         ;SCL -> 0
        CALL    PAUSE
        LD      A,#FF
        OUT     (SDA),A         ;SDA -> 1
        CALL    PAUSE
        POP     AF
        RET
GIVENACK
        PUSH    AF
        XOR     A
        OUT     (SDA),A         ;SDA -> 0
        CALL    PAUSE
        LD      A,#FF
        OUT     (SDA),A         ;SDA -> 1
        CALL    PAUSE
        POP     AF
        RET
GETACK
        PUSH    AF
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
        POP     AF
        XOR     A
        OUT     (SCL),A         ;SCL -> 0
        CALL    PAUSE
        RET
GETERR
        POP     AF
        CALL    STOP
        SCF                     ;Set CARRY -> NO ACK
        RET
PAUSEDE
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ,PAUSEDE
        RET
GETBYTE
        LD      B,8
GETBL
        LD      A,#FF
        OUT     (SCL),A         ;SCL -> 1
        CALL    PAUSE
        IN      A,(SDA)
        RRA
        RL      C
        XOR     A
        OUT     (SCL),A         ;SCL -> 0
        CALL    PAUSE
        DJNZ    GETBL
;
        LD      A,#FF
        OUT     (SDA),A         ;SDA -> 1
        CALL    PAUSE
        LD      A,C
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
        OUT     (SCL),A         ;SCL -> 1
        CALL    PAUSE
        LD      A,0
        OUT     (SCL),A         ;SCL -> 0
        CALL    PAUSE
        POP     AF
        DJNZ    PUTBL
;
        LD      A,#FF
        OUT     (SDA),A         ;SDA -> 1
        CALL    PAUSE
        RET

START
        PUSH    AF
        LD      A,#FF
        OUT     (SCL),A         ;SCL -> 1
        CALL    PAUSE
        XOR     A
        OUT     (SDA),A         ;SDA -> 0
        CALL    PAUSE
        OUT     (SCL),A         ;SCL -> 0
        CALL    PAUSE
        LD      A,#FF
        OUT     (SDA),A         ;SDA -> 1
        CALL    PAUSE
        POP     AF
        RET
STOP
        PUSH    AF
        XOR     A
        OUT     (SDA),A         ;SDA -> 0
        CALL    PAUSE
        LD      A,#FF
        OUT     (SCL),A         ;SCL -> 1
        CALL    PAUSE
        OUT     (SDA),A         ;SDA -> 1
        CALL    PAUSE
        POP     AF
        RET
PAUSE
        PUSH    AF
        LD      A,BORDER2
        OUT     (#FE),A
        PUSH    BC
        LD      B,PTIME
        DJNZ    $
        POP     BC
        LD      A,BORDER
        OUT     (#FE),A
        POP     AF
        RET
PRESSP  LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,PRESSP
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
        LD      A,(HL)
        CP      23
        JR      Z,PRIBB0
        INC     (HL)
PRIBB0
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
        JP      PRI_BB
DEC99   LD      C,A             ;Decimal 0-99
        LD      B,0             ;A - Byte
        LD      HL,FPRIA
        LD      (#5C51),HL
        JP      #1A1B
FPRIA   DEFW    PRIA
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
DEVADR  DEFB    #A6     ;Address of Device EEPROM 24C02
TMPX    DEFB    0
TMPY    DEFB    0
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

