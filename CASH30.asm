        ORG     #8000
;
        LD      SP,$
        DI
        LD      BC,#7FFD
        LD      A,#17
        OUT     (C),A
        LD      HL,NAME
        LD      DE,23773
        LD      BC,9
        LDIR
        LD      C,#0E
        XOR     A
        LD      (23801),A
        CALL    #3D13
        DI
        LD      BC,#7FFD
        LD      A,#10
        OUT     (C),A
        LD      HL,PROG66
        LD      DE,#66
        LD      BC,LEN66
        IN      A,(#FB)
        LDIR
        IN      A,(#7B)
        LD      HL,0
        PUSH    HL
        JP      #3D2F
NAME    DEFB    "sts4.4a C"
;'''''''''''''''''''''''''''''
PROG66
        .PHASE   #66
PRO
        LD      (FOSP),SP
        LD      SP,#1FFF
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
        LD      (FOSP2),SP
;----------
        LD      BC,#7FFD
        LD      A,#10+8+7
        OUT     (C),A
        LD      HL,#C000
        LD      DE,#C001
        LD      BC,#1AFF
        LD      (HL),L
        LDIR
        POP     AF
        LD      L,A
        POP     AF
        LD      H,A
        LD      (FOIR),HL
        POP     HL
        LD      (FOAF2),HL
        POP     HL
        LD      (FOHL2),HL
        POP     HL
        LD      (FODE2),HL
        POP     HL
        LD      (FOBC2),HL
        POP     HL
        LD      (FOIY),HL
        POP     HL
        LD      (FOIX),HL
        POP     HL
        LD      (FOHL),HL
        POP     HL
        LD      (FODE),HL
        POP     HL
        LD      (FOBC),HL
        POP     HL
        LD      (FOAF),HL
        LD      BC,#7FFD
        LD      A,#10
        OUT     (C),A
        LD      SP,(FOSP)
        POP     HL
        LD      (FOPC),HL
        LD      BC,#7FFD
        LD      A,#10+8+7
        OUT     (C),A
        LD      SP,(FOSP2)
        CALL    PRI64
        DEFB    #16,0,0,#FF,3,"Magic+ Cash Cracker ver1.1",#0D
        DEFB    "(C) By (R)soft 1996-97",#0D
        DEFB    "STS3.3 location at bank #17",#0D
        DEFB    "Minimum Cash-RAM 8Kb.",#0D
        DEFB    #FF,6,"Z80 After NMI:",#0D,#0D
        DEFB    #FF,7,"  PC #",0
        LD      HL,0
FOPC    EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  SP #",0
        LD      HL,(FOSP)
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  IX #",0
        LD      HL,0
FOIX    EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  IY #",0
        LD      HL,0
FOIY    EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  HL #",0
        LD      HL,0
FOHL    EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    "   HL' #",0
        LD      HL,0
FOHL2   EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  DE #",0
        LD      HL,0
FODE    EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    "   DE' #",0
        LD      HL,0
FODE2   EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  BC #",0
        LD      HL,0
FOBC    EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    "   BC' #",0
        LD      HL,0
FOBC2   EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  AF #",0
        LD      HL,0
FOAF    EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    "   AF' #",0
        LD      HL,0
FOAF2   EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  IR #",0
        LD      HL,0
FOIR    EQU     $-2
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"  Interrupt: ",0
        LD      HL,(FOIR)
        LD      A,H
        JP      PO,NOINT
        CALL    PRI64
        DEFB    "ON",#0D,0
        JR      CONN
NOINT
        CALL    PRI64
        DEFB    "OFF",#0D,0
CONN
        CALL    PRI64
        DEFB    #0D,#FF,5,"For select ROM command IN A,(#7B)",#0D
        DEFB    "For return to program Jump to #",0
        LD      HL,JUMP__
        CALL    PRIHEX
        CALL    PRI64
        DEFB    #0D,"For start STS press <ENTER>",#0D,0
CICLKE
        LD      A,#BF
        IN      A,(#FE)
        BIT     0,A
        JR      NZ,CICLKE
;
        LD      BC,#7FFD
        LD      A,#17
        OUT     (C),A
        LD      HL,(FOPC)
        LD      (#DC87),HL
        LD      SP,(FOSP2)
        POP     AF      ;R
        LD      R,A
        POP     AF      ;I
        LD      I,A
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
        POP     AF
        CALL    56064
JUMP__  LD      BC,#7FFD
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
        LD      HL,(FOSP)
        LD      (#4004),HL
        LD      A,#C9
        LD      (#4006),A

;----------------------
        LD      SP,(FOSP2)
        POP     AF      ;R
        LD      R,A
        POP     AF      ;I
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
        JP      PRIA
PRI64   POP     HL
        CALL    LL73EF
        JP      (HL)
LL73EF  LD      A,(HL)
        INC     HL
        OR      A
        RET     Z
        CP      #16
        JR      Z,LL7409
        CP      #FF
        JR      Z,LL7402
        EXX
        CALL    LL7425
        EXX
        JR      LL73EF
LL7402  LD      A,(HL)
        INC     HL
        LD      (LL7440),A
        JR      LL73EF
LL7409  LD      D,(HL)
        INC     HL
        LD      E,(HL)
        INC     HL
        PUSH    HL
        LD      (LL6012),DE
        CALL    SODA2
        POP     HL
        JR      LL73EF
LLSPACE LD      A," "
LL7425  CP      #0D
        JR      Z,LL746A
PRIA
        LD      (LL7454),A
        LD      A,(LL6012)
        LD      B,A
        SRL     A
        LD      C,A
        LD      HL,0
LL743A  EQU     $-2
        LD      A,L
        ADD     A,C
        LD      L,A
        LD      (HL),7
LL7440  EQU     $-1
        LD      DE,0
LL7442  EQU     $-2
        LD      A,E
        ADD     A,C
        LD      E,A
        LD      A,B
        RRA
        SBC     A,A
        XOR     #F0
        LD      (LL745A),A
        CPL
        LD      (LL745E),A
        LD      HL,FONT
LL7454  EQU     $-2
        LD      B,8
LL7458  LD      A,(HL)
        AND     0
LL745A  EQU     $-1
        LD      C,A
        LD      A,(DE)
        AND     0
LL745E  EQU     $-1
        OR      C
        LD      (DE),A
        INC     H
        INC     D
        DJNZ    LL7458
        LD      HL,LL6012
        INC     (HL)
        LD      A,(HL)
        CP      64
        JR      NC,LL746A
        RET
LL746A
        LD      HL,LL6012
        LD      (HL),0
        INC     HL
        LD      A,(HL)
        INC     A
        CP      24
        JR      NC,SDVIG
        LD      (HL),A
        JR      SD2
SDVIG
        LD      A,23
        LD      (HL),A
;       LD      B,0
;       CALL    #DFE
SD2
        LD      DE,(LL6012)
SODA2
        LD      E,0
        CALL    LL6D3D  ;ADR SCR
        LD      (LL7442),HL
        CALL    LL6D4C  ;ADR ATR
        LD      (LL743A),HL
        RET
LL6D3D  LD      A,D
        AND     #18
        ADD     A,#C0
        LD      H,A
        LD      A,D
        AND     7
        RRCA
        RRCA
        RRCA
        ADD     A,E
        LD      L,A
        RET
LL6D4C  LD      H,0
        LD      L,D
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        LD      A,L
        ADD     A,E
        LD      L,A
        LD      A,#D8
        ADD     A,H
        LD      H,A
        RET
LL6012  DEFW    0
FOSP    DEFW    0
FOSP2   DEFW    0
        DEFS    #CD
FONT
        .INCBIN FONT
EOF
;++++++++++++++++++
LEN66   EQU     $-PRO
        .UNPHASE
        DISPLAY $
