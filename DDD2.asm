LL8A06  EX      AF,AF'
        EXX
        LD      HL,(#5C3D)
        LD      (LL8A2B),HL
        LD      HL,LL8A29
        PUSH    HL
        LD      (#5C3D),SP
        XOR     A
        LD      (#5D0F),A
        LD      (#5D10),A
        DEC     A
        LD      (#5C3A),A
        EXX
        EX      AF,AF'
        JP      #3D13
LL8A29  DI
        LD      HL,0
LL8A2B  EQU     $-2
        LD      (#5C3D),HL
        RET



LL89BB  CALL    LL82AE  ;IM 1
        LD      (LL8A6B),DE     ;TRKSEC
        LD      (LL8A6D),BC     ;LENCOM
        PUSH    AF
        POP     DE
        LD      (LL8A6F),DE
LL89CC  LD      C,1             ;SELECT DRIV
        LD      A,(LL6EA3)      ;DRIVE
        SUB     #41
        AND     3
        CALL    LL8A06;                                                          CALL3D13
        CALL    LL8A4A;                                                          ERRORS
        JR      Z,LL89E2
LL89DD  JR      NC,LL89CC
        LD      A,#FF
        RET
LL89E2  LD      C,#18           ;INIT DRIVE
        CALL    LL8A06
        CALL    LL8A4A
        JR      NZ,LL89DD
        LD      DE,0
LL8A6F  EQU     $-2
        PUSH    DE
        POP     AF
        LD      BC,0            ;LENCOM
LL8A6D  EQU     $-2
        LD      DE,0            ;TRKSEC
LL8A6B  EQU     $-2
        LD      HL,0            ;FROM
LL8A69  EQU     $-2
        CALL    LL8A06
        CALL    LL8A4A
        JR      NZ,LL89DD
        RET
LL8A4A  EX      AF,AF'
        EXX
        LD      A,(#5C3A)
        CP      #FF
        JR      NZ,LL8A57
        EXX
        EX      AF,AF'
        CP      A
        RET
LL8A57  EXX
        EX      AF,AF'
        LD      IX,LL899B
LL8A5D  LD      A,2
        CALL    LL6BE2
LL8A62  PUSH    AF
        POP     BC
        RES     6,C
        PUSH    BC
        POP     AF
        RET
LL82CF  EX      (SP),HL
        PUSH    AF
        LD      A,13
        CP      H
        JR      NZ,LL82DE
        LD      A,#6B
        CP      L
        JR      NZ,LL82DE
LL82DB  POP     AF
        POP     HL
        RET
LL82DE  LD      A,0
        CP      H
        JR      NZ,LL82ED
        LD      A,#10
        CP      L
        JR      Z,LL8318
        JR      LL82ED
LL82EA  POP     AF
        EX      (SP),HL
        RET
LL82ED  LD      A,2
        CP      H
        JR      NZ,LL82FB
        LD      A,#8E
        CP      L
        JR      NZ,LL82FB
LL82F7  INC     SP
        INC     SP
        POP     HL
        RET
LL82FB  LD      A,#1A
        CP      H
        JR      NZ,LL8304
        INC     A
        CP      L
        JR      Z,LL82DB
LL8304  LD      A,3
        CP      H
        JR      NZ,LL82EA
        LD      A,#1E
        CP      L
        JR      NZ,LL8311
        SCF
        JR      LL82F7
LL8311  LD      A,#33
        CP      L
        JR      NZ,LL82EA
        JR      LL838A
LL8318  POP     AF
        PUSH    AF
        CP      #3F
        JR      Z,LL82DB
        LD      HL,LL8331
        CP      #64
        JR      NZ,LL8329
        LD      (HL),0
        JR      LL82DB
LL8329  CP      #69
        JR      NZ,LL82DB
        LD      (HL),1
        JR      LL82DB
LL8331  DEFB    0
LL8356  LD      A,(DE)
        CP      #2E
        JR      Z,LL837A
        CP      #40
        JR      NC,LL8362
        XOR     (HL)
        JR      LL8377
LL8362  AND     #F0
        XOR     #90
        JR      Z,LL836A
        XOR     #70
LL836A  LD      A,(DE)
        JR      NZ,LL8374
        XOR     (HL)
        JR      Z,LL837A
        XOR     #70
        JR      LL8377
LL8374  XOR     (HL)
        AND     #DF
LL8377  RET     NZ
        JR      LL8382
LL837A  LD      A,(HL)
        XOR     13
        JR      NZ,LL8381
        INC     A
        RET
LL8381  XOR     A
LL8382  INC     DE
        INC     HL
        DJNZ    LL8356
        RET
LL838A  LD      IX,LL83C6
        LD      A,(LL8331)
        AND     A
        JR      Z,LL8398
        LD      IX,LL83BA
LL8398  LD      A,2
        CALL    LL6BE2
        JP      LL82F7
LL83A0  LD      IX,LL8609
        LD      A,3
        CALL    LL6BE2
        LD      A,(IX+8)
        LD      (IX+8),0
        AND     A
        LD      A,"R"
        RET     Z
        LD      A,"A"
        RET
LL83BA  DEFB    3,45,3,16
        DEFW    LL83A0,0
        DEFB    0
        DEFW    LL8332
        DEFB    #57
LL83C6  DEFB    4,45,3,16
        DEFW    LL83A0,0
        DEFB    0
        DEFW    LL8342
        DEFB    #57





