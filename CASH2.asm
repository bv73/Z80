        ORG     #8000
;
        LD      SP,$
        DI
        LD      HL,PROG66       ;Copy NMI Prog
        LD      DE,#66
        LD      BC,LEN66
        IN      A,(#FB)
        LDIR
        IN      A,(#7B)
        LD      HL,0            ;Reset
        PUSH    HL
        JP      #3D2F
PROG66
        .PHASE   #66
PRO
        DI
        POP     HL
        LD      BC,#7FFD
        LD      A,#D7           ;Page STS 4.4
        OUT     (C),A
        LD      (#C000),HL
        LD      SP,#DA00
        LD      HL,#D000
        LD      (HL),#DB        ;IN A,(#7B)
        INC     HL
        LD      (HL),#7B
        INC     HL
        LD      (HL),#CD        ;CALL #DB00
        INC     HL
        LD      (HL),0
        INC     HL
        LD      (HL),#DB
        INC     HL
        LD      (HL),#DB        ;IN A,(#FB)
        INC     HL
        LD      (HL),#FB
        INC     HL
        LD      (HL),#C9        ;RET
        CALL    #D000           ;Call STS
        LD      SP,0
FSPM    EQU     $-2
JUMPING LD      BC,#7FFD
        LD      A,#10           ;Page Exit
        OUT     (C),A
        LD      HL,#4000
        LD      (HL),#DB        ;IN A,(#7B)
        INC     HL
        LD      (HL),#7B
        INC     HL
        LD      (HL),#F1        ;POP AF
        INC     HL
        LD      (HL),#31        ;LD SP,0
        LD      HL,0
FOSP    EQU     $-2
        LD      (#4004),HL
        LD      A,#C9           ;RET
        LD      (#4006),A
;-------
        POP     AF
        LD      R,A
        POP     AF
        LD      I,A
        DI
        LD      A,#FF
        JP      PO,LL2ECC
        LD      A,0
LL2ECC  LD      (L5C00),A
        POP     AF
        POP     HL
        POP     DE
        POP     BC
        EXX
        EX      AF,AF'
        POP     IY
        POP     IX
        POP     HL
        POP     DE
        POP     BC
        LD      A,0
L5C00   EQU     $-1
        OR      A
        JR      NZ,LL2F03
        EI
LL2F03
        JP      #4000
LEN66   EQU     $-PRO
        .UNPHASE
        DISPLAY $

