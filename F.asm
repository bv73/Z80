        ORG     #8000
;
LL686B  EQU     #3D13

LL773B
        LD      HL,0
        LD      (LL7893),HL
        LD      (LL7885),HL
        LD      HL,(LL75D2)     ;FROM POSITION
        LD      BC,(LL74CE)     ;FILES
        LD      B,0
        ADD     HL,BC
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        SET     7,H
        SET     6,H
        LD      BC,#0C
        ADD     HL,BC
        LD      DE,LL7891
        LDI                     ;LEN ZIP
        LDI
        LDI
        LD      A,(HL)          ;NUM FILE
        LD      C,8
        CALL    LL686B          ;PARAMETERS OF FILE
        LD      HL,(#5CEB)      ;TrkSec
        LD      (LL7782),HL
        LD      IX,#8000
        LD      HL,#5CDD
        LD      DE,LL6FF2       ;NAME FILE
        LD      BC,8
        LDIR
LL7781  LD      DE,0
LL7782  EQU     $-2
        LD      HL,#E000
        LD      BC,#0205
        CALL    LL686B          ;Load From TrkSec
        LD      HL,(LL7894)
        LD      H,#E0
        PUSH    IX
        POP     DE
        LD      (IX),0
        INC     DE
;
        PUSH    HL
        LD      BC,#0C
        ADD     IX,BC
        CALL    LL6D1F
        POP     HL
;
        LD      BC,8
        ADD     HL,BC
        LD      A,(HL)
        INC     HL
        CP      "B"
        JR      NZ,LL77B9
        LD      E,(HL)  ;LEN If Basic
        INC     HL
        LD      D,(HL)
        INC     HL
        INC     HL
        INC     DE
        INC     DE
        INC     DE
        INC     DE
        JR      LL77BE
LL77B9  INC     HL
        INC     HL
        LD      E,(HL)  ;LEN If Not Basic File
        INC     HL
        LD      D,(HL)
LL77BE  INC     HL
        LD      A,D
        INC     E
        DEC     E
        JR      Z,LL77C5
        INC     A
LL77C5  CP      (HL)
        JR      Z,LL77CB
        LD      D,(HL)
        LD      E,0
LL77CB  INC     HL
        LD      (IX),E          ;LEN NOZIP
        LD      (IX+1),D
        LD      C,(HL)          ;ZIPLEN FILE
        INC     HL
        LD      B,(HL)
        PUSH    HL
        CALL    LL6D54
        LD      BC,4
        LD      E,(IX+2)
        LD      D,(IX+3)
        PUSH    DE
        ADD     IX,BC
        PUSH    IX
        POP     DE
        CALL    LL6DC0
        LD      A,(IX+2)
        CP      #20
        JR      NZ,LL77F6
        LD      (IX+2),#30
LL77F6  LD      A,(IX+3)
        LD      (IX+4),A
        LD      (IX+3),#2E
        LD      (IX+5),#25
        LD      (IX+6),0
        LD      HL,(LL7782)     ;TrkSec
        LD      (IX+7),L
        LD      (IX+8),H
        LD      A,(LL7894)
        LD      (IX+9),A
        LD      BC,#10
        ADD     IX,BC
        POP     DE
        POP     HL
        LD      C,5
        ADD     HL,BC
        LD      A,(HL)
        LD      (IX-6),A
        INC     HL
        LD      A,(HL)
        LD      (IX-5),A
        LD      HL,(LL7885)
        INC     HL
        LD      (LL7885),HL
        LD      HL,#16
        ADD     HL,DE
        EX      DE,HL
        LD      HL,(LL7894)
        LD      H,0
        ADD     HL,DE
        LD      A,L
        LD      (LL7894),A
        LD      L,H
        LD      H,0
        JR      NC,LL7846
        INC     H
LL7846  LD      BC,(LL7782)     ;TrkSec
LL784A  LD      A,H
        OR      L
        JR      Z,LL7859
        INC     C
        BIT     4,C
        JR      Z,LL7856
        INC     B
        LD      C,0
LL7856  DEC     HL
        JR      LL784A
LL7859  LD      (LL7782),BC     ;TrkSec
        LD      A,(LL7893)
        LD      HL,(LL7891)
        SBC     HL,DE
        SBC     A,0
        LD      (LL7891),HL     ;LEN ZIP
        LD      (LL7893),A
        JR      C,LL787B
        OR      L
        OR      H
        JR      Z,LL787B
        LD      A,(LL7886)
        CP      2
        JP      C,LL7781
LL787B  ; LD      HL,#6FEF        ;PRINT ZIPFILE
        ; CALL    LL6942
        LD      HL,#8000
        LD      DE,0
LL7885  EQU     $-2
LL7886  EQU     $-1
        LD      BC,#20
        RET
;--------------------------
LL6D1F  PUSH    HL
        LD      BC,8
        ADD     HL,BC
        EX      (SP),HL
        PUSH    HL
        ADD     HL,BC
        LD      A,#20
        LD      B,7
LL6D2B  DEC     HL
        CP      (HL)
        JR      NZ,LL6D31
        DJNZ    LL6D2B
LL6D31  INC     B
        POP     HL
LL6D33  LD      A,(HL)
        CALL    LL6D4A
        LD      (DE),A
        INC     HL
        INC     DE
        DJNZ    LL6D33
        LD      A,#2E
        LD      (DE),A
        INC     DE
        POP     HL
        LD      A,(HL)
        CALL    LL6D4A
        LD      (DE),A
        INC     DE
        XOR     A
        LD      (DE),A
        RET
LL6D4A  CP      #80
        JR      NC,LL6D51
        CP      #20
        RET     NC
LL6D51  LD      A,#3F
        RET
LL6D54  PUSH    DE
        LD      (IX+2),C
        LD      (IX+3),B
        EX      DE,HL
        OR      A
        SBC     HL,BC
        EXX
        LD      HL,0
        LD      C,L
        LD      B,L
        EXX
        JR      NC,LL6D6D
        LD      HL,0
        JR      LL6D82
LL6D6D  LD      B,#F9
        LD      E,L
        LD      D,H
LL6D71  ADD     HL,DE
        EXX
        ADC     HL,BC
        EXX
        DJNZ    LL6D71
        ADD     HL,HL
        EXX
        ADC     HL,HL
        EXX
        ADD     HL,HL
        EXX
        ADC     HL,HL
        EXX
LL6D82  POP     DE
        LD      A,D
        OR      E
        JR      NZ,LL6D8B
        LD      HL,0
        RET
LL6D8B  LD      BC,#FFFF
LL6D8E  SBC     HL,DE
        EXX
        SBC     HL,BC
        EXX
        INC     BC
        JR      NC,LL6D8E
        LD      L,C
        LD      H,B
        LD      A,HX
        OR      A
        RET     NZ
        LD      A,H
        CP      3
        RET     C
        JR      NZ,LL6DA7
        LD      A,L
        CP      #E8
        RET     C
LL6DA7  LD      HL,#03E7
        RET
        EX      AF,AF'
        LD      A,6
        EX      AF,AF'
        PUSH    DE
        JR      LL6DD2
        EX      AF,AF'
        LD      A,5
        EX      AF,AF'
        PUSH    DE
        JR      LL6DE8
        EX      AF,AF'
        LD      A,4
        EX      AF,AF'
        PUSH    DE
        JR      LL6DFE
LL6DC0  LD      A,3
        EX      AF,AF'
        PUSH    DE
        JR      LL6E10
        LD      A,2
        EX      AF,AF'
        PUSH    DE
        JR      LL6E1D
        LD      A,1
        EX      AF,AF'
        PUSH    DE
        JR      LL6E2A
LL6DD2  PUSH    DE
        LD      E,#2F
        LD      BC,#BDC0
LL6DD8  ADD     HL,BC
        ADC     A,#F0
        INC     E
        JR      C,LL6DD8
        SBC     HL,BC
        SBC     A,#F0
        LD      C,A
        LD      A,E
        POP     DE
        LD      (DE),A
        INC     DE
        LD      A,C
LL6DE8  LD      BC,#7960
        PUSH    DE
        LD      E,#2F
LL6DEE  ADD     HL,BC
        ADC     A,#FE
        INC     E
        JR      C,LL6DEE
        SBC     HL,BC
        SBC     A,#FE
        LD      C,A
        LD      A,E
        POP     DE
        LD      (DE),A
        INC     DE
        LD      A,C
LL6DFE  LD      BC,#D8F0
        PUSH    DE
        LD      E,#2F
LL6E04  ADD     HL,BC
        ADC     A,#FF
        INC     E
        JR      C,LL6E04
        SBC     HL,BC
        LD      A,E
        POP     DE
        LD      (DE),A
        INC     DE
LL6E10  LD      BC,#FC18
        LD      A,#2F
LL6E15  ADD     HL,BC
        INC     A
        JR      C,LL6E15
        SBC     HL,BC
        LD      (DE),A
        INC     DE
LL6E1D  LD      BC,#FF9C
        LD      A,#2F
LL6E22  ADD     HL,BC
        INC     A
        JR      C,LL6E22
        SBC     HL,BC
        LD      (DE),A
        INC     DE
LL6E2A  LD      BC,#FFF6
        LD      A,#2F
LL6E2F  ADD     HL,BC
        INC     A
        JR      C,LL6E2F
        LD      (DE),A
        INC     DE
        LD      A,#3A
        ADD     A,L
        LD      (DE),A
        POP     HL
        EX      AF,AF'
        LD      B,A
        LD      A,#30
LL6E3E  CP      (HL)
        RET     NZ
        LD      (HL),#20
        INC     HL
        DJNZ    LL6E3E
        RET
;----------------------
LL75D2  DEFW    0
LL74CE  DEFW    #0E00
LL7891  DEFW    0       ;LEN ZIP
LL7893  DEFB    0
LL7894  DEFW    0

LL6FF2  DEFB    "123456789"
