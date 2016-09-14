;   _/_________________________________________________
;  / /                                                 \
; | |  Copyright 2000-2001 By (Research)soft Software  |
;  \ \_________________________________________________/
;__/\_____________/                                   /
;----=======================================---------/
; Program For Read/Write CARD                       /
; PA0=DAT (Data)  (#1F)                            /
; PB0=CLK (Clock) (#3F)                           /
; PB1=RES (Reset)                                /
; PB2=GND (Power Ground)                        /
; Special Version 0.31 for Parallel Port 8255  /
; Last Edition at 3 Feb 2001                  /
;-----======================================-/
;1C CLS
;1D Set X
;1E Set X,Y
;1F Fill Sym,Num
;FF Inverse
; ______________________________________
;/                     \                \
JACH    EQU     #2A     ; Writing Addr   \
BITS    EQU     #08     ; Writing Bits   /
;\_____________________/________________/
;
PA      EQU     #1F     ;Addr Of Port A
PB      EQU     #3F     ;Addr Of Port B
PORTSET EQU     #7F     ;Addr Of Setting Register 8255
PTIME   EQU     #40     ;Pause Time
BORDER2 EQU     2
BORDER  EQU     0
CHECK   EQU     #5C20
RAMPOINT EQU    #D000   ;Point Addr of Read From Memory-Card
;
        ORG     #8000
MAIN_GENERAL_START
        LD      A,BORDER
        OUT     (#FE),A
        LD      A,(CHECK)
        AND     A
        JR      NZ,CHECK_N1
        LD      A,#90
        OUT     (PORTSET),A
        LD      A,#FF
        OUT     (PB),A
        OUT     (PA),A
CHECK_N1
        CALL    PRI_T
DEFB    #1C,#FF
DEFB    " Driver For Read/Write Telephone CARD v0.31 ",#FF,13
DEFB    "Special Realization for Parallel Port 8255",13
DEFB    "Copyright Nov-Feb 2000/2001 By (R)soft",13,13,0
        LD      A,(CHECK)
        AND     A
        JR      NZ,CHECK_N2
REPEAT
        CALL    PRI_T
        DEFB    #1E,0,9
        DEFB    "Insert CARD & Press ",#FF
        DEFB    " ENTER ",#FF,13
        DEFB    "Or Press ",#FF," SPACE ",#FF
        DEFB    " To Exit...",13,0
REPEATKEY
        LD      A,#7F
        IN      A,(#FE)
        RRA
        RET     NC
        LD      A,#BF
        IN      A,(#FE)
        RRA
        JR      C,REPEATKEY
        LD      A,#FF
        LD      (CHECK),A
CHECK_N2
        CALL    PRI_T
        DEFB    #1E,0,4
        DEFB    "Reading & Check...",0
        CALL    POWER_ON
        CALL    RESET
        CALL    READBYTE
        CP      #FF
        JR      NZ,CHECK_N3
        CALL    POWER_OFF
        CALL    PRI_T
        DEFB    13,13,"Card Damaged or Not Inserted!",13
        DEFB    "Repeat Please.",13,0
        LD      DE,#8000
        CALL    PAUSEDE
        JP      REPEAT
CHECK_N3
        CALL    POWER_OFF
;  __________________________
; / ________________________ \
;| /                        \|
;||\    MAIN PROCEDURES    /||
;|| \_______        ______/ ||
; \\_______ \      / _______//
;  \______ \ \    / /_______/
;         \| |   | |/
;     _____| |   | |______
;    / ______|   | ______ \
;    \ \____/|   | \____/ /
;     \ _____/    \_____ /
;      \\              //
;       \\   ______   //
;        \\  \    /  //
;         \\  \  /  //
;          \\  \/  //
;           \\    //
;            \\  //
;             \\//
;              \/
;
        LD      B,JACH
        CALL    WRITE_BYTE
        LD      B,JACH
        CALL    READ_BYTE
        CALL    PRIHB
        CALL    PRINT_HEX
        RET
;-------------------------------------------
; _______________________________________
;/                                       \
CARD    DEFB    1       ;0-RamCard 1-Card
;\_______________________________________/
PRINT_N
        CALL    POWER_ON
        CALL    RESET
        LD      B,9
        LD      A,5
        CALL    PRINTBTOCT
        LD      B,2
        LD      A,8
        CALL    PRINTBTOCTLONG
        JP      POWER_OFF
READ_RAM
        CALL    POWER_ON
        CALL    RESET
        LD      HL,#C000        ;Addr Read
        LD      B,64            ;How Many
        CALL    READ
        JP      POWER_OFF
PRINT_OCT
        CALL    POWER_ON
        CALL    RESET
        LD      B,64
        LD      A,5
        CALL    PRINTBTOCT
        JP      POWER_OFF
PRINT_OCTLONG
        CALL    POWER_ON
        CALL    RESET
        LD      B,32
        LD      A,5
        CALL    PRINTBTOCTLONG
        JP      POWER_OFF
PRINT_HEX
        CALL    POWER_ON
        CALL    RESET
        LD      B,64            ;How Many Byte Prints
        LD      A,5             ;Koord Y
        CALL    PRINTBT16
        JP      POWER_OFF
READ_BYTE
        CALL    POWER_ON
        CALL    RESET
        LD      A,B
        AND     A
        JR      Z,READ_BYTE0
READ_BYTEL
        PUSH    BC
        CALL    READBYTE
        POP     BC
        DJNZ    READ_BYTEL
READ_BYTE0
        CALL    READBYTE
        PUSH    AF
        CALL    POWER_OFF
        POP     AF
        RET
WRITE_BYTE
        CALL    POWER_ON
        CALL    RESET
        LD      A,B
        AND     A
        JR      Z,WRITE_BYTE0
WRITE_BYTEL
        PUSH    BC
        CALL    READBYTE
        POP     BC
        DJNZ    WRITE_BYTEL
WRITE_BYTE0
        CALL    WRITEBYTE
        JP      POWER_OFF
;  __________________________________
; /                                  \
;| Check DATA Bit on Oscilloscope    |
;| After Every Pressing of ENTER Key |
;| SPACE + ENTER - Exit              |
; \__________________________________/
LP1
        CALL    PRESSENT
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JP      NC,POWER_OFF
        LD      A,7
        OUT     (#FE),A
        LD      A,1
BOX     EQU     $-1
        XOR     1
        LD      (BOX),A
        OUT     (PB),A
        CALL    PAUSE
        JP      LP1
READ
        PUSH    BC
        PUSH    HL
        CALL    READBYTE
        POP     HL
        LD      (HL),A
        INC     HL
        POP     BC
        DJNZ    READ
        RET
READBYTE
        LD      A,(CARD)
        AND     A
        JR      NZ,READBYTE0
        PUSH    HL
        LD      HL,RAMPOINT
RAMP    EQU     $-2
        LD      A,(HL)
        INC     HL
        PUSH    AF
        LD      A,L
        AND     #3F
        LD      L,A
        POP     AF
        LD      (RAMP),HL
        POP     HL
        RET
READBYTE0                       ;RES = 0
        LD      B,8
READB1
        LD      A,1             ;        __
        OUT     (PB),A          ; CLK __/
        IN      A,(PA)
        RRA                     ; DAT -> READ
        RL      C
        XOR     A               ;     __
        OUT     (PB),A          ; CLK   \__
        DJNZ    READB1
        LD      A,C
        RET
WRITEBYTE
        LD      B,BITS
WRITEB1
        RLA
        PUSH    AF
; -= WRITE 1 =-
        LD      A,1
        JR      C,WRITEB2
; -= WRITE 0 =-
        LD      A,0
WRITEB2
        LD      A,2             ;       _
        OUT     (PB),A          ; RES _/ \_
        XOR     A
        OUT     (PB),A
;
        LD      A,1
        OUT     (PB),A
        LD      A,1             ;Pause 20mSec
        CALL    PAUSEA
        XOR     A               ;      _________
        OUT     (PB),A          ;CLK _/ 20 mSec \_
;
        JR      WRITEB3
        LD      A,1             ;       _
        OUT     (PB),A          ; CLK _/ \_
        XOR     A
        OUT     (PB),A
WRITEB3
        POP     AF
        DJNZ    WRITEB1
        RET
POWER_ON
        LD      A,(CARD)
        AND     A
        RET     Z
        LD      A,3             ;     ____
        OUT     (PB),A          ; RES     \__
        LD      A,2             ;     __
        OUT     (PB),A          ; CLK   \____
        XOR     A
        OUT     (PB),A
        RET
RESET
        LD      A,(CARD)
        AND     A
        JR      NZ,RESET0
        PUSH    HL
        LD      HL,RAMPOINT
        LD      (RAMP),HL
        POP     HL
        RET
RESET0
        LD      A,2             ;        ___
        OUT     (PB),A          ; RES __/   \_
        LD      A,3             ;         _
        OUT     (PB),A          ; CLK ___/ \__
        LD      A,2
        OUT     (PB),A
        XOR     A
        OUT     (PB),A
        RET
POWER_OFF
        LD      A,(CARD)
        AND     A
        RET     Z
        LD      A,2             ;        ____
        OUT     (PB),A          ; RES __/
        LD      A,3             ;          __
        OUT     (PB),A          ; CLK ____/
        LD      A,#FF
        OUT     (PB),A
        RET
PRINTBT16
        LD      (PRINTBY),A
        XOR     A
        LD      (PBTA),A
        PUSH    BC
        CALL    SHAP16
        CALL    PRI_T
        DEFB    "  ",0
        LD      A,(PBTA)
        CALL    PRIHB
        CALL    PRI_T
        DEFB    ": ",0
        POP     BC
PRINTBT160
        PUSH    BC
        CALL    READBYTE
        CALL    PRIHB
        LD      HL,PBTA
        INC     (HL)
        LD      A," "
        CALL    PRIA
        LD      A,(TMPX)
        CP      48+4
        JR      C,NOENBT160
        CALL    PRI_T
        DEFB    13,"  ",0
        LD      A,0
PBTA    EQU     $-1
        CALL    PRIHB
        CALL    PRI_T
        DEFB    ": ",0
NOENBT160
        POP     BC
        DJNZ    PRINTBT160
        RET
SHAP16
        CALL    PRI_T
        DEFB    #1E,0,2
PRINTBY EQU     $-1
        DEFB    "Addr| +0 +1 +2 +3 +4 +5 +6 +7 +8 "
        DEFB    "+9 +A +B +C +D +E +F",13
        DEFB    #1F,"-",53,13,0
        RET
PRINTBTOCT
        LD      (PRINTBZ),A
        XOR     A
        LD      (PBTZ),A
        PUSH    BC
        CALL    SHAPOCT
        LD      A," "
        CALL    PRIA
        LD      A,(PBTZ)
        CALL    PRIOCT
        CALL    PRI_T
        DEFB    ": ",0
        POP     BC
PRINTBTOCT0
        PUSH    BC
        CALL    READBYTE
        CALL    PRIOCT
        LD      HL,PBTZ
        INC     (HL)
        LD      A," "
        CALL    PRIA
        LD      A,(TMPX)
        CP      32+4
        JR      C,NOENBTOCT0
        CALL    PRI_T
        DEFB    13," ",0
        LD      A,0
PBTZ    EQU     $-1
        CALL    PRIOCT
        CALL    PRI_T
        DEFB    ": ",0
NOENBTOCT0
        POP     BC
        DJNZ    PRINTBTOCT0
        RET
SHAPOCT
        CALL    PRI_T
        DEFB    #1E,0,2
PRINTBZ EQU     $-1
DEFB    "Addr| +0  +1  +2  +3  +4  +5  +6  +7",13
        DEFB    #1F,"-",37,13,0
        RET
PRINTBTOCTLONG
        LD      (PRINTBX),A
        XOR     A
        LD      (PBTX),A
        PUSH    BC
        CALL    SHAPOCTL
        LD      A," "
        CALL    PRIA
        LD      A,(PBTX)
        CALL    PRIOCT
        CALL    PRI_T
        DEFB    ": ",0
        POP     BC
PRINTBTOCT0L
        PUSH    BC
        CALL    READBYTE
        LD      L,A
        CALL    READBYTE
        LD      H,A
        CALL    PRIOCTLONG
        LD      HL,PBTX
        INC     (HL)
        INC     (HL)
        LD      A," "
        CALL    PRIA
        LD      A,(TMPX)
        CP      28+4
        JR      C,NOENBTOCT0L
        CALL    PRI_T
        DEFB    13," ",0
        LD      A,0
PBTX    EQU     $-1
        CALL    PRIOCT
        CALL    PRI_T
        DEFB    ": ",0
NOENBTOCT0L
        POP     BC
        DJNZ    PRINTBTOCT0L
        RET
SHAPOCTL
        CALL    PRI_T
        DEFB    #1E,0,2
PRINTBX EQU     $-1
DEFB    "Addr|   +0     +2     +4     +6",13
        DEFB    #1F,"-",33,13,0
        RET
PRESSP  LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,PRESSP
        LD      DE,#8000
        JP      PAUSEDE
PRESSENT
        LD      A,#BF
        IN      A,(#FE)
        RRA
        JR      C,PRESSENT
        LD      DE,#8000
PAUSEDE
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ,PAUSEDE
        RET
PAUSEA
        PUSH    AF
        LD      A,BORDER2
        OUT     (#FE),A
        POP     AF
        PUSH    BC
        LD      B,A
        HALT
        DJNZ    $-1
        POP     BC
        LD      A,BORDER
        OUT     (#FE),A
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
;####################################################
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
        LD      HL,FPRIA        ;DE,HL',A'- Free Regs
        LD      (#5C51),HL
        JP      #1A1B
FPRIA   DEFW    PRIA
PRIOCTLONG
        AND     A
        RR      H
        PUSH    AF
        AND     A
        LD      A,H
        CALL    PRIOCTALL
        POP     AF
        LD      A,L
        JP      PRIOCTALL
PRIOCT
        AND     A
PRIOCTALL
        PUSH    AF
        AND     7
        LD      E,A
        POP     AF
        RRA
        RRA
        RRA
        PUSH    AF
        AND     7
        LD      D,A
        POP     AF
        RRA
        RRA
        RRA
        AND     7
        PUSH    HL
        CALL    DEC99
        LD      A,D
        CALL    DEC99
        LD      A,E
        CALL    DEC99
        POP     HL
        RET
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
;================================================
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
;-------------------------------------------------
        ORG     #B700
TABSCR  DEFW    #4000,#4020,#4040,#4060,#4080,#40A0
        DEFW    #40C0,#40E0,#4800,#4820,#4840,#4860
        DEFW    #4880,#48A0,#48C0,#48E0,#5000,#5020
        DEFW    #5040,#5060,#5080,#50A0,#50C0,#50E0
;--------------------------------------------------
        ORG     #B800
FONT
;       .INCBIN FONT
        .RUN    #8000

