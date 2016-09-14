        ORG     #8000
;
        LD      SP,$
        DI
        LD      BC,#7FFD
        LD      A,#17           ;Page 7
        OUT     (C),A
        LD      HL,NAME
        LD      DE,23773
        LD      BC,9
        LDIR
        LD      C,#0E
        XOR     A
        LD      (23801),A
        CALL    #3D13           ;Load STS
        DI
        LD      BC,#7FFD        ;Page 0
        LD      A,#10
        OUT     (C),A
        LD      HL,PROG66       ;Copy NMI Prog
        LD      DE,#66
        LD      BC,LEN66
        IN      A,(#FB)
        LDIR
        IN      A,(#7B)
        LD      HL,0            ;Reset
        PUSH    HL
        JP      #3D2F
NAME    DEFB    "sts4.4a C"
PROG66
        .PHASE   #66
PRO
        LD      (FOSP),SP
        LD      SP,#07FF
        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        PUSH    IX
        PUSH    IY
        EXX
        PUSH    BC
        PUSH    DE
        PUSH    HL
        EX      AF,AF'
        PUSH    AF
        LD      A,I
        PUSH    AF
        LD      A,R
        PUSH    AF
        LD      (FSPM),SP
;-------
        PUSH    BC
        PUSH    AF
        PUSH    HL
        LD      (FOO),SP
        LD      SP,(FOSP)
        POP     HL
        LD      BC,#7FFD
        LD      A,#17
        OUT     (C),A
        LD      (#DC87),HL
        LD      SP,0
FOO     EQU     $-2
        POP     HL
        POP     AF
        POP     BC
        LD      SP,(FOSP)
        CALL    56064           ;Call STS
        LD      SP,0
FSPM    EQU     $-2
JUMPING LD      BC,#7FFD
        LD      A,#10
        OUT     (C),A
        LD      HL,#4000
        LD      (HL),#DB
        INC     HL
        LD      (HL),#7B
        INC     HL
        LD      (HL),#F1
        INC     HL
        LD      (HL),#31
        LD      HL,0
FOSP    EQU     $-2
        LD      (#4004),HL
        LD      A,#C9
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

