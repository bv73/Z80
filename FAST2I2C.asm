        ORG     #8000
;
PORTA   EQU     #1F
PORTB   EQU     #3F
PORTC   EQU     #5F
PORTSET EQU     #7F
;
FAST2
        DI
        LD      A,#80
        OUT     (PORTSET),A
        LD      A,#FF
        OUT     (PORTA),A
        OUT     (PORTB),A
        OUT     (PORTC),A
;
        IN      A,(#FB)         ;CASH
;
        LD      HL,MAINPP
        LD      DE,0
        LD      BC,CON-MAINP
        LDIR
        LD      HL,CON
        LD      (HL),#ED
        INC     HL
        LD      (HL),#A2
        DEC     HL
        LD      DE,CON+2
        LD      BC,#3FDE+10
        LDIR
        LD      (HL),#C9
;
        CALL    MAINP
;
        IN      A,(#7B)         ;ROM
        EI
        RET
MAINPP
        .PHASE  0
MAINP
        LD      DE,#FFFF
        LD      BC,#001F
        LD      HL,#C000
LOOPF2
        IN      A,(PORTA)       ;11     1 Section=22
        CP      E               ;4
        JR      NZ,CON          ;7
        LD      A,#1F           ;7      KeyScan Section
        IN      A,(#FE)         ;11
        RRA                     ;4
        JP      C,LOOPF2        ;10     =32
        RET
CON

