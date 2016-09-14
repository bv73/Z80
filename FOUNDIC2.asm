        ORG     #8000
;----------------------------------------------\
; Program For Scanning Devices on I2C Bus V0.26/
; (C) By (R)soft 11 Feb 2001                  /
; Special Extended Version For FLASH MODULE  /
; PA0=SDA (Data)  (#1F)                     /
; PB0=SCL (Clock) (#3F)                    /
; PC2=LATCH (Bits A0-A2 Latch By PORT B)  /
;-----------\----------------------------/
;1C CLS      \
;1D Set X     \
;1E Set X,Y    \
;1F Fill Sym,Num\
;FF Inverse      \
;-----------------\
PORTA   EQU     #1F
PORTB   EQU     #3F
PORTC   EQU     #5F
PORTSET EQU     #7F     ;#80
MASKA   EQU     #FF
MASKB   EQU     #FF
MASKC   EQU     #FF
ADREEPROM EQU   0       ;0-7 (0,2,4,6,8,A,C,E)
TIMEP   EQU     #01     ;Delay Time
BORDER  EQU     0
BORDER2 EQU     2
ACKTIME EQU     #1000   ;Time Acknowledge From IC
FIRSTADR EQU    #90     ;First Addr Scanning
ENDADR  EQU     #FF     ;End Addr Scanning
;AND #FE     RES BIT0
;OR  #01     SET BIT0
;
        DI
        LD      HL,TABLEAD
        LD      (COUNTER),HL
        LD      D,H
        LD      E,L
        INC     DE
        LD      BC,255
        LD      (HL),0
        LDIR
        LD      A,#FF
        LD      (FLAG),A
        LD      A,BORDER
        OUT     (#FE),A
        LD      A,#80
        OUT     (PORTSET),A
        LD      A,MASKA
        OUT     (PORTA),A
        LD      A,MASKB
        OUT     (PORTB),A
        LD      A,MASKC
        OR      4
        OUT     (PORTC),A
        CALL    SETPORTD
        CALL    STOP
;
        CALL    PRI_T
        DEFB    #1C,#FF
        DEFB    " -=- Scanning Addresses of Devices "
        DEFB    "on I2C Bus -=- ",13
        DEFB    "     Ver 0.26 Copyright 2000-2001 "
        DEFB    "By (R)soft      ",#FF,13
        DEFB    "Please Wait for Scanning Addresses "
        DEFB    "on I2C Bus.",13
        DEFB    "Or Press <SPACE> to Abort...",13,13
        DEFB    ">> Start Address Scanning: #",0
        LD      A,FIRSTADR
        LD      (SCANADR),A
        CALL    PRIHB
        CALL    PRI_T
        DEFB    13,"Scan Address: #",0
        XOR     A
        LD      (DEVFOUN),A
LOOPADR
        LD      A,(SCANADR)
        CALL    PRIHB
        CALL    START
        LD      A,(SCANADR)
        CALL    PUTBYTE
        CALL    GETACK
        CALL    STOP
        JP      NC,LOOP1
        LD      HL,TMPX
        DEC     (HL)
        DEC     (HL)
LOOPC
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JP      NC,ABORT
        LD      A,(SCANADR)
        INC     A
        LD      (SCANADR),A
        CP      ENDADR+1
        JR      NZ,LOOPADR
        CALL    PRI_T
        DEFB    #1D,0,#1F," ",20,#1D,0
        DEFB    ">> End Address Scanning: #",0
        LD      A,ENDADR
        CALL    PRIHB
        LD      A,0
DEVFOUN EQU     $-1
        AND     A
        JR      NZ,LIBRARY1
        CALL    PRI_T
        DEFB    13,"Devices Not Found.",13
        DEFB    "Connect Your I2C Chip Into FLASH DRIVE "
        DEFB    "And Running Again.",13,0
        EI
        RET
LIBRARY1
        LD      A,0
LOADOK  EQU     $-1
        AND     A
        RET     Z
        CALL    PRI_T
        DEFB    13,"Loading Library OK. Searching TYPE "
        DEFB    "of Chip...",13
        DEFB    "Addr: ",0
        LD      HL,TABLEAD
FOUND
        LD      A,(HL)
        INC     HL
        AND     A
        JR      Z,FOUND1
        PUSH    HL
        CALL    PRIHB
        LD      A,","
        CALL    PRIA
        POP     HL
        JR      FOUND
FOUND1
        LD      HL,TMPX
        DEC     (HL)
        LD      A,"."
        CALL    PRIA
        EI
        RET
LOOP1
        CALL    STOP            ;!!! BUGFIX3
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
        DEFB    "Write",0
        JR      LOOP1C
LOOP1R
        CALL    PRI_T
        DEFB    "Read ",0
LOOP1C
        CALL    LIBRARY
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
SETPORTD
        IN      A,(PORTB)
        PUSH    AF
        LD      A,ADREEPROM
        OUT     (PORTB),A
        LD      A,MASKC         ;_
        AND     #FB             ; \_ Res Bit2
        OUT     (PORTC),A       ;Latch Addr IC EEPROM
        LD      A,MASKC         ;  _
        OR      4               ;_/  Set Bit2
        OUT     (PORTC),A
        POP     AF
        OUT     (PORTB),A
        RET
LIBRARY
        LD      A,(SCANADR)
        BIT     0,A
        JR      Z,LIBR0
LIBR9
        CALL    PRI_T
        DEFB    "< OK >",13,0
        RET
LIBR0
        LD      HL,TABLEAD
COUNTER EQU     $-2
        LD      (HL),A
        INC     HL
        LD      (COUNTER),HL
        LD      A,#FF
FLAG    EQU     $-1
        AND     A
        JR      Z,LIBR9
        INC     A
        LD      (FLAG),A
        LD      HL,NAMELIB
        LD      DE,23773
        LD      BC,9
        LDIR
        XOR     A
        LD      (#5D0F),A
        LD      (#5D10),A
        LD      C,10
        CALL    #3D13
        DI
        RET
        BIT     7,C
        JR      Z,LIBR1
        CALL    PRI_T
        DEFB    " < Library Not Found >",13,0
        XOR     A
        LD      (LOADOK),A
        RET
LIBR1
        LD      A,#FF
        LD      (LOADOK),A
        LD      HL,#C000
        LD      C,14
        LD      A,#FF
        CALL    #3D13
        CALL    PRI_T
        DEFB    " < Library Loading >",13,0
        RET
;---\/---\/---\/---\/---\/---
GETACK
        LD      A,MASKA
        OR      1               ;  _
        OUT     (PORTA),A       ;_/  SDA
        CALL    PAUSE
        LD      A,MASKB
        OR      1               ;  _
        OUT     (PORTB),A       ;_/  SCL
        CALL    PAUSE
        LD      BC,ACKTIME
GETA1
        DEC     BC              ;Counter of Wait
        LD      A,C
        OR      B
        JR      Z,GETERR
        IN      A,(PORTA)       ;Wait To SDA=0
        BIT     0,A
        JR      NZ,GETA1
        LD      A,MASKB
        AND     #FE             ;_
        OUT     (PORTB),A       ; \_ SCL
        AND     A               ; Res CARRY -> ACK OK
        JP      PAUSE
GETERR
        LD      A,MASKB
        AND     #FE             ;_
        OUT     (PORTB),A       ; \_ SCL
        CALL    PAUSE
        SCF                     ;Set CARRY -> NO ACK
        RET
PUTBYTE
        LD      B,8
PUTBL
        RLA
        PUSH    AF
        LD      A,MASKA
        JR      C,PUTB1
        AND     #FE             ;_
        JR      PUTB2           ; \_ Set SDA
PUTB1
        OR      1               ;  _
PUTB2                           ;_/  Set SDA
        OUT     (PORTA),A
        CALL    PAUSE
        LD      A,PORTB
        OR      1               ;  _
        OUT     (PORTB),A       ;_/  SCL
        CALL    PAUSE
        LD      A,PORTB
        AND     #FE             ;_
        OUT     (PORTB),A       ; \_ SCL
        CALL    PAUSE
        POP     AF
        DJNZ    PUTBL
;
        LD      A,MASKA
        OR      1               ;  _
        OUT     (PORTA),A       ;_/  SDA
        JP      PAUSE
START
        PUSH    AF
        LD      A,MASKB
        OR      1               ;  _
        OUT     (PORTB),A       ;_/  SCL    (BUGFIX1!)
        CALL    PAUSE
        LD      A,MASKA
        AND     #FE             ;_
        OUT     (PORTA),A       ; \_ SDA
        CALL    PAUSE
        LD      A,MASKB
        AND     #FE             ;_
        OUT     (PORTB),A       ; \_ SCL
        CALL    PAUSE
        LD      A,MASKA
        OR      1               ;  _
        OUT     (PORTA),A       ;_/  SDA
        CALL    PAUSE
        POP     AF
        RET
STOP
        PUSH    AF
        LD      A,MASKB
        AND     #FE             ;_
        OUT     (PORTB),A       ; \_ SCL    (BUGFIX2!)
        CALL    PAUSE
        LD      A,MASKA
        AND     #FE             ;_
        OUT     (PORTA),A       ; \_ SDA
        CALL    PAUSE
        LD      A,MASKB
        OR      1               ;  _
        OUT     (PORTB),A       ;_/  SCL
        CALL    PAUSE
        LD      A,MASKA
        OR      1               ;  _
        OUT     (PORTA),A       ;_/  SDA
        CALL    PAUSE
        POP     AF
        RET
;---/\---/\---/\---/\---/\---
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
PAUSEDE
        DEC     DE
        LD      A,E
        OR      D
        JR      NZ,PAUSEDE
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
NAMELIB DEFB    "I2C.LIB A"
SCANADR DEFB    0
TABLEAD DEFS    256
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

