        ORG     #8000
;
;       JP      LP9
LIN     EQU     24
        LD      IX,TABSCR
        LD      A,2
        LD      DE,#C004
MON2
        LD      B,8*(LIN-1)
MON1
        PUSH    BC
        LD      HL,COPY_
        LD      BC,COPY_L
        LDIR
        POP     BC
        DJNZ    MON1
        DEC     A
        AND     A
        JR      NZ,MON2
        PUSH    DE
        POP     IX
        LD      DE,3
        LD      (IX),#21
        LD      (IX+1),0
        LD      (IX+2),0
        ADD     IX,DE
        LD      BC,#0800
BELL1
        PUSH    BC
        LD      (IX),#31
        LD      (IX+1),#00
        LD      A,#51
        ADD     A,C
        LD      (IX+2),A
        ADD     IX,DE
        LD      B,16
BELL    LD      (IX),#E5
        INC     IX
        DJNZ    BELL
        POP     BC
        INC     C
        DJNZ    BELL1
        PUSH    IX
        POP     DE
        PUSH    DE
        LD      BC,4
        LDIR
        POP     DE
        INC     DE
        LD      HL,#C000
        LD      (HL),#ED
        INC     HL
        LD      (HL),#73
        INC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
;
        LD      IX,#C005
        LD      DE,#0D
        LD      HL,TABSCR
LP50
        LD      BC,#0800
LP100
        PUSH    BC
        PUSH    HL
        INC     HL
        INC     HL
        LD      A,(HL)
        LD      (IX),A
        INC     HL
        LD      A,(HL)
        ADD     A,C
        LD      (IX+1),A
        ADD     IX,DE
        DEC     HL
        DEC     HL
        LD      A,(HL)
        ADD     A,C
        LD      (IX+1),A
        DEC     HL
        LD      A,(HL)
        ADD     A,#10
        LD      (IX),A
        ADD     IX,DE
        INC     HL
        INC     HL
        LD      A,(HL)
        ADD     A,#10
        LD      (IX),A
        INC     HL
        LD      A,(HL)
        ADD     A,C
        LD      (IX+1),A
        ADD     IX,DE
        DEC     HL
        DEC     HL
        LD      A,(HL)
        ADD     A,C
        LD      B,A
        DEC     HL
        LD      A,(HL)
        ADD     A,#20
        AND     A
        JR      NZ,NOBIN
        INC     B
NOBIN
        LD      (IX),A
        LD      (IX+1),B
        ADD     IX,DE
        POP     HL
        POP     BC
        INC     C
        DJNZ    LP100
        INC     HL
        INC     HL
        LD      A,L
        CP      LIN*2-2
        JR      NZ,LP50
LP9
        LD      HL,#4000
        LD      DE,#4002
        LD      (HL),#55
        INC     HL
        LD      (HL),#AA
        DEC     HL
        LD      BC,#17FE
        LDIR
LP10
        EI
        HALT
        DI
        LD      A,7
        OUT     (#FE),A
        CALL    #C000
        XOR     A
        OUT     (#FE),A
        LD      BC,#7FFE
        IN      A,(C)
        RRA
        JR      C,LP10
        EI
        RET
COPY_
        LD      SP,0
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        EXX
        EX      AF,AF'
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        LD      SP,0
        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        EXX
        EX      AF,AF'
        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
COPY_E
COPY_L  =       COPY_E-COPY_
        LD      SP,0
        RET
        ORG     #9000
TABSCR
        DEFW    #4000,#4020,#4040,#4060,#4080,#40A0,#40C0
        DEFW    #40E0,#4800,#4820,#4840,#4860,#4880,#48A0
        DEFW    #48C0,#48E0,#5000,#5020,#5040,#5060,#5080
        DEFW    #50A0,#50C0,#50E0
        ORG     #8000

