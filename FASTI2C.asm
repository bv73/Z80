        ORG     #8000
;
PORTA   EQU     #1F
PORTB   EQU     #3F
PORTC   EQU     #5F
PORTSET EQU     #7F
;
FAST1
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
        LD      BC,END-MAINP
        LDIR
        CALL    0
        LD      HL,0
        LD      DE,#C000
        LD      BC,#1000
        LDIR
;
        IN      A,(#7B)         ;ROM
        EI
        RET
;
MAINPP
        .PHASE  0
MAINP
        LD      DE,#C000
        LD      BC,#FFFF
        LD      HL,LOOPM
LOOPM
        IN      A,(PORTA)       ;11     1 Section=22
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     2
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     3
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     4
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     5
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     6
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     7
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     8
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     9
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     10
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     11
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     12
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     13
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     14
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     15
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     16
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     17
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     18
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     19
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     20
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     21
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     22
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     23
        CP      C               ;4
        JR      NZ,NEW          ;7
        IN      A,(PORTA)       ;11     24*22=
        CP      C               ;4
        JR      NZ,NEW          ;7      =528
;
        LD      A,#1F           ;7      KeyScan Section
        IN      A,(#FE)         ;11
        RRA                     ;4
        JP      C,LOOPM         ;10     =32
        RET
NEW
                                ;+12
        LD      (DE),A          ;7
        INC     DE              ;6
        LD      C,A             ;4
        JP      (HL)            ;4      =33
;
END

