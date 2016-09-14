LB289   CALL    L998E
L90B0   LD      A,(IX)
        AND     A
        RET     Z
        LD      B,A
        INC     IX
LL90C4  PUSH    BC
        CALL    LL90D1
        POP     BC
        INC     IX
        INC     IX
        DJNZ    LL90C4
        JR      L90B0
LL90D1  LD      L,(IX)
        SLA     L
        SLA     L
        LD      H,#E3
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        INC     HL
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        ADD     HL,HL
        PUSH    HL
        EXX
        POP     BC
        EXX
        LD      L,(IX+1)
        SLA     L
        SLA     L
        LD      H,#E3
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        ADD     HL,HL
        PUSH    HL
        EXX
        POP     DE
        EXX
        LD      A,B
        OR      D
        EXX
        OR      B
        OR      D
        EXX
        JP      Z,LL91E1
        LD      A,B
        XOR     D
        ADD     A,A
        JR      C,LL9113
        LD      A,B
        AND     A
        JR      Z,LL9113
        LD      A,D
        AND     A
        RET     NZ
LL9113  EXX
        LD      A,B
        XOR     D
        ADD     A,A
        JR      C,LL9121
        LD      A,B
        AND     A
        JR      Z,LL9121
        LD      A,D
        AND     A
        JR      NZ,LL9154
LL9121  EXX
        LD      H,B
        LD      L,C
        AND     A
        SBC     HL,DE
        JP      Z,LL9269
        EXX
        LD      H,B
        LD      L,C
        AND     A
        SBC     HL,DE
        JP      Z,LL9242
        EXX
        LD      A,B
        EXX
        OR      B
        EXX
        JP      Z,LL91F1
        LD      A,D
        EXX
        OR      D
        JR      NZ,LL9156
        LD      H,B
        LD      L,C
        EX      DE,HL
        LD      B,H
        LD      C,L
        EXX
        LD      H,B
        LD      L,C
        EX      DE,HL
        LD      B,H
        LD      C,L
        JP      LL91F1
LL914E  INC     HL
        JP      LL9162
LL9151  INC     HL
        JP      LL9171
LL9154  EXX
        RET
LL9156  LD      H,B
        LD      L,C
        ADD     HL,DE
        LD      A,H
        AND     L
        INC     A
        JR      Z,LL914E
        SRA     H
        RR      L
LL9162  LD      A,H
        EX      AF,AF'
        EXX
        LD      H,B
        LD      L,C
        ADD     HL,DE
        LD      A,H
        AND     L
        INC     A
        JR      Z,LL9151
        SRA     H
        RR      L
LL9171  EX      AF,AF'
        OR      H
        JR      Z,LL91BC
        LD      A,B
        XOR     H
        ADD     A,A
        JR      C,LL9182
        LD      A,B
        AND     A
        JR      Z,LL9182
        LD      A,H
        AND     A
        JR      NZ,LL9198
LL9182  EXX
        LD      A,B
        XOR     H
        ADD     A,A
        JR      C,LL9190
        LD      A,B
        AND     A
        JR      Z,LL9190
        LD      A,H
        AND     A
        JR      NZ,LL9197
LL9190  EXX
        EX      DE,HL
        EXX
        EX      DE,HL
        JP      LL9156
LL9197  EXX
LL9198  LD      A,D
        XOR     H
        ADD     A,A
        JR      C,LL91A5
        LD      A,D
        AND     A
        JR      Z,LL91A5
        LD      A,H
        AND     A
        RET     NZ
LL91A5  EXX
        LD      A,D
        XOR     H
        ADD     A,A
        JR      C,LL91B3
        LD      A,D
        AND     A
        JR      Z,LL91B3
        LD      A,H
        AND     A
        JR      NZ,LL9154
LL91B3  EXX
        LD      B,H
        LD      C,L
        EXX
        LD      B,H
        LD      C,L
        JP      LL9156
LL91BC  PUSH    BC
        PUSH    HL
        LD      B,H
        LD      C,L
        EXX
        PUSH    BC
        PUSH    HL
        LD      B,H
        LD      C,L
        EXX
        CALL    LL91F8
        EXX
        LD      A,L
        POP     BC
        POP     DE
        EXX
        POP     BC
        POP     DE
LL91D0  SRL     A
        LD      H,A
        PUSH    HL
        CALL    LL91F8
        EXX
        LD      A,L
        EXX
        SRL     A
        LD      H,A
        POP     DE
        JP      LL9292
LL91E1  EXX
        LD      A,E
        EXX
        SRL     A
        LD      D,A
        EXX
        LD      A,C
        EXX
        SRL     A
        LD      H,A
        LD      L,C
        JP      LL9292
LL91F1  LD      L,C
        EXX
        LD      A,C
        EXX
        JP      LL91D0
LL91F8  LD      H,B
        LD      L,C
LL91FA  ADD     HL,DE
        LD      A,H
        AND     L
        INC     A
        JR      Z,LL9236
        SRA     H
        RR      L
LL9204  LD      A,H
        EX      AF,AF'
        EXX
        LD      H,B
        LD      L,C
        ADD     HL,DE
        LD      A,H
        AND     L
        INC     A
        JR      Z,LL9239
        SRA     H
        RR      L
LL9213  EX      AF,AF'
        OR      H
        JR      NZ,LL9230
        LD      A,L
        SRA     A
        INC     A
        JR      Z,LL923C
        DEC     A
        JR      Z,LL923C
        EXX
        INC     L
        JR      Z,LL923E
        DEC     L
        RET     Z
        EXX
        LD      B,H
        LD      C,L
        EXX
        LD      B,H
        LD      C,L
        JP      LL91FA
LL9230  EX      DE,HL
        EXX
        EX      DE,HL
        JP      LL91F8
LL9236  INC     HL
        JP      LL9204
LL9239  INC     HL
        JP      LL9213
LL923C  EXX
        RET
LL923E  DEC     L
        RET
LL9242  EXX
        LD      A,B
        AND     A
        JR      Z,LL9251
        JP      M,LL924F
        LD      C,#FF
        JP      LL9251
LL924F  LD      C,0
LL9251  LD      L,C
        LD      A,D
        AND     A
        JR      Z,LL9260
        JP      M,LL925E
        LD      E,#FF
        JP      LL9260
LL925E  LD      E,0
LL9260  EXX
        LD      A,E
        EXX
        SRL     A
        LD      H,A
        LD      D,A
        JP      LL9292
LL9269  EXX
        LD      A,B
        AND     A
        JR      Z,LL9278
        JP      M,LL9276
        LD      C,#FF
        JP      LL9278
LL9276  LD      C,0
LL9278  LD      A,C
        EX      AF,AF'
        LD      A,D
        AND     A
        JR      Z,LL9288
        JP      M,LL9286
        LD      E,#FF
        JP      LL9288
LL9286  LD      E,0
LL9288  LD      A,E
        EXX
        SRL     A
        LD      D,A
        EX      AF,AF'
        SRL     A
        LD      H,A
        LD      L,C
LL9292  PUSH    IX
        CALL    L8426
        POP     IX
        RET
L8426
        LD      A,H
        LD      H,L
        LD      L,A
        LD      A,D
        LD      D,E
        LD      E,A
        LD      A,D
        SUB     H
        JR      NC,LL8433
        NEG
        EX      DE,HL
LL8433  LD      C,A
        LD      A,E
        LD      DE,#20
        SUB     L
        JR      NC,LL8440
        NEG
        LD      DE,#FFE0
LL8440  LD      B,A
        PUSH    BC
        PUSH    DE
        LD      A,H
        LD      B,H
        LD      C,L
        LD      H,0
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        LD      DE,#EC00
        ADD     HL,DE
        AND     #F8
        RRCA
        RRCA
        RRCA
        ADD     A,L
        LD      L,A
        LD      A,B
        AND     7
        LD      (LL8572),A
        LD      B,A
        LD      A,#80
        JR      Z,LL8466
LL8463  RRCA
        DJNZ    LL8463
LL8466  LD      B,C
        LD      C,A
        LD      A,B
        POP     DE
        AND     7
        INC     A
        BIT     7,D
        JR      NZ,LL8475
        SUB     9
        NEG
LL8475  LD      B,A
        LD      A,(HL)
        EXX
        EX      AF,AF'
        POP     DE
        LD      A,D
        AND     A
        JP      Z,LL84EF
        LD      A,E
        AND     A
        JP      Z,LL8544
        SUB     D
        JR      C,LL84C1
        JP      Z,LL855E
        LD      B,E
        INC     E
        JP      NZ,LL8490
        DEC     E
LL8490  INC     D
        LD      A,E
LL8492  SUB     D
        JR      C,LL84A9
        EXX
        EX      AF,AF'
        OR      C
        RRC     C
        JP      NC,LL84A0
        LD      (HL),A
        INC     L
        LD      A,(HL)
LL84A0  EXX
        EX      AF,AF'
        DJNZ    LL8492
        EXX
        EX      AF,AF'
        OR      C
        LD      (HL),A
        RET
LL84A9  ADD     A,E
        EXX
        EX      AF,AF'
        OR      C
        RRC     C
        JP      NC,LL84B5
        LD      (HL),A
        INC     L
        LD      A,(HL)
LL84B5  LD      (HL),A
        ADD     HL,DE
        LD      A,(HL)
        EXX
        EX      AF,AF'
        DJNZ    LL8492
        EXX
        EX      AF,AF'
        OR      C
        LD      (HL),A
        RET
LL84C1  LD      B,D
        INC     D
        INC     E
        LD      A,D
LL84C5  SUB     E
        JR      C,LL84D8
        EXX
        EX      AF,AF'
        LD      A,C
        OR      (HL)
        LD      (HL),A
        ADD     HL,DE
        EXX
        EX      AF,AF'
        DJNZ    LL84C5
        EXX
        EX      AF,AF'
        LD      A,C
        OR      (HL)
        LD      (HL),A
        RET
LL84D8  ADD     A,D
        EXX
        EX      AF,AF'
        LD      A,C
        OR      (HL)
        LD      (HL),A
        RRC     C
        JP      NC,LL84E4
        INC     L
LL84E4  ADD     HL,DE
        EXX
        EX      AF,AF'
        DJNZ    LL84C5
        EXX
        EX      AF,AF'
        LD      A,C
        OR      (HL)
        LD      (HL),A
        RET
LL84EF  LD      A,E
        AND     A
        EXX
        JR      NZ,LL84F8
        EX      AF,AF'
        OR      C
        LD      (HL),A
        RET
LL84F8  INC     A
        JR      NZ,LL8504
        LD      BC,#20FF
LL84FE  LD      (HL),C
        INC     L
        INC     E
        DJNZ    LL84FE
        RET
LL8504  CP      #10
        JR      C,LL8535
        LD      B,A
        BIT     7,C
        JR      NZ,LL8517
        EX      AF,AF'
LL850E  OR      C
        DEC     B
        RRC     C
        JP      NC,LL850E
        LD      (HL),A
        INC     L
LL8517  LD      C,B
        SRL     B
        SRL     B
        SRL     B
LL851E  LD      (HL),#FF
        INC     L
        INC     E
        DJNZ    LL851E
        LD      A,C
        AND     7
        RET     Z
        LD      B,A
        LD      A,#80
        JP      LL8530
LL852E  SRA     A
LL8530  DJNZ    LL852E
        OR      (HL)
        LD      (HL),A
        RET
LL8535  LD      B,A
        EX      AF,AF'
LL8537  OR      C
        RRC     C
        JR      NC,LL8540
        LD      (HL),A
        INC     L
        INC     E
        LD      A,(HL)
LL8540  DJNZ    LL8537
        LD      (HL),A
        RET
LL8544  LD      A,0
LL8572  EQU     $-1
        CPL
        SCF
        ADC     A,A
        ADC     A,A
        ADD     A,A
        LD      (LL8555),A
        LD      (LL855C),A
        LD      A,D
        EXX
LL8554  SET     1,(HL)
LL8555  EQU     $-1
        ADD     HL,DE
        DEC     A
        JP      NZ,LL8554
        SET     1,(HL)
LL855C  EQU     $-1
        RET
LL855E  LD      B,D
LL855F  EXX
        LD      A,C
        OR      (HL)
        LD      (HL),A
        RRC     C
        JP      NC,LL8569
        INC     L
LL8569  ADD     HL,DE
        EXX
        DJNZ    LL855F
        EXX
        LD      A,C
        OR      (HL)
        LD      (HL),A
        RET
L9A38
        LD      HL,LL9A49
        PUSH    HL
        LD      L,(IX)
        LD      H,(IX+1)
        LD      A,(IX+2)
        LD      (LFE46),A
        JP      (HL)
LL9A49  LD      DE,3
        ADD     IX,DE
        CALL    L9916
        LD      A,(IX)
        LD      (LFE47),A
        INC     IX
        PUSH    IX
        CALL    L956F
        POP     IX
        CALL    L90B0
        RET

