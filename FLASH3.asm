        ORG     #8000
;-------------------------------------
; Flash Drive V1.0 for Flash Card 256K
;-------------------------------------
;Port A: Data FLASH
;Port B: Set High & Low Byte of FLASH Address
;Port C: 0 - BANK 0-1
;        1 - BANK 2-3
;        2 - /STROB  (For Latch Low Byte of FLASH Address)
;        3 - /WE     (Write Enable)
;        4 - /CS     (Chip Select)
;        5 -  ---
;        6 -  ---
;        7 -  ---
;Mask #FC
;======================================
PORTA   EQU     #1F
PORTB   EQU     #3F
PORTC   EQU     #5F
PORTSET EQU     #7F
MASK    EQU     #FC
FILWIN  EQU     10              ;Files in Window
START
        DI
        CALL    CLSCR
        LD      HL,0
        LD      (TMPX),HL
        CALL    KOOR_Y
        LD      A,#DA
        CALL    PRIA
        LD      BC,#2DC4
        CALL    PRI_S
        CALL    PRI_T
        DEFB    #BF,13,#B3
        DEFB    " Flash Drive for Speccy V1.0 by (R)soft'1999 "
        DEFB    #B3,13,#C0,0
        LD      BC,#2DC4
        CALL    PRI_S
        CALL    PRI_T
        DEFB    #D9,13,"Flash Drive ",0
        LD      A,#80
        OUT     (PORTSET),A
        XOR     A
        OUT     (PORTA),A
        OUT     (PORTB),A
        DEC     A
        OUT     (PORTC),A
        IN      A,(PORTA)
        CP      #FF
        JP      Z,EXIT
        CALL    PRI_T
TXTDET  DEFB    "Detected.",13,0
        XOR     A
        LD      (TSTBYTE),A
        LD      C,PORTA
        LD      A,#41
        CALL    TESTP
        LD      C,PORTB
        LD      A,#42
        CALL    TESTP
        LD      C,PORTC
        LD      A,#43
        CALL    TESTP
        LD      A,0
TSTBYTE EQU     $-1
        AND     A
        JP      NZ,EXIT0
;
        CALL    PRI_T
        DEFB    13,"Flash Card ",0
        LD      A,#FF
        OUT     (PORTA),A
        OUT     (PORTB),A
        LD      A,MASK
        LD      (MASKB),A
        OUT     (PORTC),A
        LD      C,0             ;Page
        LD      HL,#000C
        CALL    RD_FL0
        CP      #FF
        JR      Z,WARNING
        LD      HL,TXTDET
        CALL    PRI_BB
        JP      NOWARN
WARNING
        LD      A,1
        OUT     (#FE),A
        CALL    PRI_T
        DEFB    "Not Present.",13
        DEFB    "Insert Flash Card into Drive "
        DEFB    "and Press <ENTER> to Continue.",13,13,0
KEY_LOOP
        LD      A,#BF
        IN      A,(#FE)
        RRA
        JR      C,KEY_LOOP
        LD      A,1
        OUT     (#FE),A
NOWARN
        CALL    PRI_T
        DEFB    "Reading Catalogue. ",0
        LD      C,0     ;Page
        LD      HL,0    ;Addr
        CALL    READ_PAGE
        LD      A,(#C00C)
        CP      #FF
        JR      NZ,CATSHOW
        CALL    PRI_T
        DEFB    "Flash Card Clean or Not Inserted.",13,0
        JP      EXIT0
CATSHOW
        CALL    CLSCR
        LD      HL,0
        LD      (TMPX),HL
        CALL    KOOR_Y
        CALL    PRI_T
        DEFB    "Card Name: ",0
        LD      HL,#C004
        LD      B,8
        CALL    PRI_B
;
        LD      HL,TMPX
        LD      (HL),32
        CALL    PRI_T
        DEFB    "Length All: ",0
        CALL    LENPS
        LD      HL,(LENHL0)
        LD      DE,(LENDE0)
        CALL    DECDB
;
        CALL    PRI_T
        DEFB    13,"Version:   ",0
        LD      HL,#C00C
        LD      B,8
        CALL    PRI_B
;
        LD      HL,TMPX
        LD      (HL),32
        CALL    PRI_T
        DEFB    "Size All:   ",0
        LD      HL,(SIZHL0)
        LD      DE,(SIZDE0)
        CALL    DECDB
;
        CALL    PRI_T
        DEFB    13,"Programs:  ",0
        CALL    PROGS
        CALL    DEC9999
;
        LD      HL,TMPX
        LD      (HL),32
        CALL    PRI_T
        DEFB    "Size Archiv:",0
        LD      DE,0
        LD      HL,#1080
        CALL    SIZADD
        LD      HL,(SIZHL0)
        LD      DE,(SIZDE0)
        CALL    DECDB
;
        LD      HL,(TMPX)
        INC     H
        LD      L,32
        LD      (TMPX),HL
        CALL    KOOR_Y
        CALL    PRI_T
        DEFB    "Free Memory:",0
        LD      HL,(SIZHL0)
        LD      (FREE0),HL
        LD      DE,(SIZDE0)
        LD      (FREE1),DE
        CALL    FREE
        CALL    DECDB
;
        CALL    PRI_T
        DEFB    13,#DA
        DEFB    #C4,#C4
        DEFB    #C2,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C2,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C2,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C2,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C2,#C4,#C4,#C4,#C4,#C4
        DEFB    #BF,13
        DEFB    #B3,"N/",#B3,"  Name  "
        DEFB    #B3,"Length ",#B3
        DEFB    " Size  ",#B3,"   Date   ",#B3
        DEFB    "Time ",#B3,13
        DEFB    #C3,#C4,#C4
        DEFB    #C5,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C5,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C5,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C5,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C5,#C4,#C4,#C4,#C4,#C4
        DEFB    #B4,13,0
;       INC     (HL)
;       CALL    KOOR_Y
        XOR     A
        LD      (NUM0),A
        LD      IX,#C020
        LD      B,12
LOOPSHOW
        LD      A,(IX)
        CP      #FF
        JP      Z,ENDSHOW
        PUSH    BC
;
        LD      A,0
NUM0    EQU     $-1
        INC     A
        LD      (NUM0),A
        CALL    PRILIN
;
        INC     (HL)
        DEC     HL
        LD      (HL),0
        CALL    KOOR_Y
        LD      BC,#20
        ADD     IX,BC
        POP     BC
        DJNZ    LOOPSHOW
ENDSHOW
        CALL    PRI_T
        DEFB    #C0,#C4,#C4
        DEFB    #C1,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C1,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C1,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C1,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4,#C4
        DEFB    #C1,#C4,#C4,#C4,#C4,#C4
        DEFB    #D9,0
        EI
        RET
PRILIN
        PUSH    AF              ;Num Prog
        LD      A,#B3
        CALL    PRIA
        POP     AF
        LD      HL,TMPX
        LD      (HL),1
        CALL    DEC9999
        LD      HL,TMPX
        LD      (HL),3
        LD      A,#B3
        CALL    PRIA
;
        DEC     HL              ;Name Prog
        LD      (HL),4
        PUSH    IX
        POP     HL
        LD      BC,#0C
        ADD     HL,BC
        LD      B,8
        CALL    PRI_B
        LD      HL,TMPX
        LD      (HL),12
        LD      A,#B3
        CALL    PRIA
;
        DEC     HL              ;Len Prog
        LD      (HL),13
        LD      D,(IX+#17)
        LD      E,(IX+#16)
        LD      H,(IX+#15)
        LD      L,(IX+#14)
        CALL    DECDB
        DEC     HL
        LD      (HL),20
        LD      A,#B3
        CALL    PRIA
;
        DEC     HL              ;Size Prog
        LD      (HL),21
        LD      H,(IX+5)
        LD      L,(IX+4)
        LD      D,(IX+7)
        LD      E,(IX+6)
        CALL    DECDB
        DEC     HL
        LD      (HL),28
        LD      A,#B3
        CALL    PRIA
;
        DEC     HL              ;Date
        LD      (HL),29
        LD      L,(IX+#0A)
        LD      H,(IX+#0B)
        CALL    DATE            ;HL-Year D-Day E-Month
        LD      HL,TMPX
        LD      (HL),39
        LD      A,#B3
        CALL    PRIA
;
        DEC     HL              ;Time
        LD      (HL),40
        LD      L,(IX+8)
        LD      H,(IX+9)
        CALL    TIME            ;H-Hour L-Minute
        LD      HL,TMPX
        LD      (HL),45
        LD      A,#B3
        JP      PRIA
PROGS   LD      IX,#C020
        LD      HL,NUMPROG
        LD      (HL),0
        LD      BC,#20
PROGS0
        LD      A,(IX)
        CP      #FF
        JR      Z,PROGS1
        INC     (HL)
        ADD     IX,BC
        JR      PROGS0
PROGS1  LD      A,(HL)
        RET
LENPS   LD      IX,#C020
        LD      HL,0
        LD      (LENHL0),HL
        LD      (LENDE0),HL
        LD      (SIZHL0),HL
        LD      (SIZDE0),HL
LENPS0
        LD      A,(IX)
        CP      #FF
        RET     Z
        LD      D,(IX+#17)
        LD      E,(IX+#16)
        LD      H,(IX+#15)
        LD      L,(IX+#14)
        CALL    LENADD
        LD      H,(IX+5)
        LD      L,(IX+4)
        LD      D,(IX+7)
        LD      E,(IX+6)
        CALL    SIZADD
        LD      BC,#20
        ADD     IX,BC
        JR      LENPS0
LENADD
        LD      BC,(LENHL0)
        AND     A
        ADD     HL,BC
        LD      (LENHL0),HL
        LD      HL,(LENDE0)
        ADC     HL,DE
        LD      (LENDE0),HL
        RET
SIZADD
        LD      BC,(SIZHL0)
        AND     A
        ADD     HL,BC
        LD      (SIZHL0),HL
        LD      HL,(SIZDE0)
        ADC     HL,DE
        LD      (SIZDE0),HL
        RET
FREE
        LD      DE,4
        LD      HL,0
        LD      BC,0
FREE0   EQU     $-2
        AND     A
        SBC     HL,BC
        EX      DE,HL
        LD      BC,0
FREE1   EQU     $-2
        SBC     HL,BC
        EX      DE,HL
        RET
        DISPLAY $
DATE
        LD      A,#1F
        AND     L
        LD      D,A
        LD      B,5
        CALL    ROTA
        LD      A,#0F
        AND     L
        LD      E,A
        LD      B,4
        CALL    ROTA
        LD      A,#7F
        AND     L
        LD      B,0
        LD      C,A
        LD      HL,1980
        ADD     HL,BC
        PUSH    HL
        PUSH    DE
        LD      A,D
        CALL    DEC00
        LD      A,"/"
        CALL    PRIA
        POP     DE
        LD      A,E
        CALL    DEC00
        LD      A,"/"
        CALL    PRIA
        POP     HL
        JP      DEC1999
TIME
        RET
ROTA    SRL     H
        RR      L
        DJNZ    ROTA
        RET
DEC00   LD      H,0
        LD      L,A
        JR      DEC000
DEC1999 LD      DE,1000
        CALL    DEC001
        LD      DE,100
        CALL    DEC001
DEC000  LD      DE,10
        CALL    DEC001
        LD      A,L
        ADD     A,#30
        JP      PRIA
DEC001  XOR     A
DEC002  SBC     HL,DE
        JR      C,DEC003
        INC     A
        JR      DEC002
DEC003  ADD     HL,DE
        AND     A
        ADD     A,#30
        PUSH    HL
        CALL    PRIA
        POP     HL
        RET
;-------------------------
EXIT    CALL    PRI_T
        DEFB    "Not Found!",13,0
EXIT0   CALL    PRI_T
        DEFB    "Test Your Hardware.",0
        EI
        RET
TESTP
        LD      (TESTPS),A
        PUSH    BC
        CALL    PRI_T
        DEFB    "Test Port A: ",0
TESTPS  EQU     $-4
        POP     BC
        LD      B,0
TESTP0  OUT     (C),B
        IN      A,(C)
        CP      B
        JR      NZ,TESTP1
        DJNZ    TESTP0
        CALL    PRI_T
        DEFB    "Passed OK.",13,0
        RET
TESTP1  CALL    PRI_T
        DEFB    "Damaged!",13,0
        LD      HL,TSTBYTE
        INC     (HL)
        RET
;
;--- READ
READ_PAGE
        LD      A,MASK          ;HL - Addr Flash
        ADD     A,C             ;C - Bank
        LD      (MASKB),A
        LD      DE,#C000
        LD      B,#40
L_RD_FL
        PUSH    BC
        CALL    RD_FL256
        INC     D
        INC     H
        POP     BC
        DJNZ    L_RD_FL
        LD      A,MASK
        LD      (MASKB),A
        OUT     (PORTC),A
        RET
WRITE_FL
        LD      HL,MASK
        LD      A,3             ;BANK WRITE
        ADD     A,(HL)
        LD      (HL),A
        LD      HL,#C000        ;ADR WRITE
        LD      DE,#C000
L_WR_FL
        LD      A,(DE)
        CALL    WR_FLASH
        INC     DE
        INC     HL
        LD      A,E
        OR      D
        JR      NZ,L_WR_FL
        LD      A,MASK
        LD      (MASKB),A
        OUT     (PORTC),A
        RET
RD_FL256
        LD      B,4
        LD      C,PORTB
        OUT     (C),H
        LD      A,(MASKB)
        XOR     B
        OUT     (PORTC),A       ;Latch High Byte
        XOR     B
        OUT     (PORTC),A
;
        LD      B,0             ;Read Byte
        LD      C,PORTC
LOOP_256
        LD      A,E
        OUT     (PORTB),A       ;Set Low Addr
        LD      A,(MASKB)
        XOR     #10
        OUT     (C),A
        IN      A,(PORTA)
        LD      (DE),A
        INC     E
        LD      A,(MASKB)
        OUT     (C),A
        DJNZ    LOOP_256
        RET
RD_FL0  LD      A,MASK
        ADD     A,C             ;C - Bank
        LD      (MASKB),A
        CALL    RD_FL1
        EX      AF,AF'
        LD      A,MASK
        LD      (MASKB),A
        OUT     (PORTC),A
        EX      AF,AF'
        RET
RD_FL1
        LD      C,PORTB         ;Latch Addr
        LD      B,4
        OUT     (C),H
        LD      A,(MASKB)
        XOR     B
        OUT     (PORTC),A
        XOR     B
        OUT     (PORTC),A
        OUT     (C),L
;
        LD      C,PORTC         ;Read Byte
        LD      B,A
        XOR     #10
        OUT     (C),A
        IN      A,(PORTA)
        OUT     (C),B
        RET
WR_FLASH
        OUT     (PORTA),A
        CALL    ADR_LATCH
        LD      A,(MASKB)
        XOR     #18
        OUT     (PORTC),A
        LD      B,200           ;Delay Write
WR_LB   DJNZ    WR_LB
        XOR     #18
        OUT     (PORTC),A
        RET
ADR_LATCH
        LD      A,H
        OUT     (PORTB),A
        LD      A,(MASKB)
        XOR     4
        OUT     (PORTC),A
        XOR     4
        OUT     (PORTC),A
        LD      A,L
        OUT     (PORTB),A
        RET
COPY
        LD      HL,0
        LD      DE,#C000
        LD      BC,#3FFF
        LDIR
        RET
CLS
        LD      HL,#C000
        LD      E,L
        LD      D,H
        INC     DE
        LD      (HL),L
        LD      BC,#3FFF
        LDIR
        RET
CLSCR
        LD      HL,#4000
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
;--------------------------
MASKB   DEFB    #FC
;--------------------------
PRI_S   LD      A,C     ;C - Symbol
PRI_S0  PUSH    BC      ;B - How Many
        PUSH    AF
        CALL    PRIA
        POP     AF
        POP     BC
        DJNZ    PRI_S0
        RET
PRI_TDE POP     HL
        CALL    PRI_BBDE
        JP      (HL)
PRI_T   POP     HL
        CALL    PRI_BB
        JP      (HL)
PRI_BDE LD      (TMPX),DE       ;DE - Koord
        EX      DE,HL           ;HL - Text
        CALL    KOOR_Y          ;B - How Many
PRI_B   PUSH    BC
        LD      A,(HL)
        AND     A
        JR      Z,LPRI_C
        PUSH    HL
        CALL    PRIA
        POP     HL
        INC     HL
LPRI_C  POP     BC
        DJNZ    PRI_B
        RET
;
PRI_BBDE LD      (TMPX),DE       ;DE - Koord
        EX      DE,HL           ;HL - Text
        CALL    KOOR_Y
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
PRI_BB0 CP      #20
        JR      C,PRI_BB        ;<#20 - No Print
        PUSH    HL
        CALL    PRIA
        POP     HL
        JR      PRI_BB
;
DEC99   LD      (TMPX),DE
        CALL    KOOR_Y
DEC9999 LD      C,A             ;Decimal 0-99
        LD      B,0             ;A - Byte
        LD      HL,FPRIA        ;DE - Koord
        LD      (#5C51),HL
        JP      #1A1B
FPRIA   DEFW    PRIA
;
DECIMA2 PUSH    AF              ;Decimal 0-255
        LD      (TMPX),DE       ;A - Byte
        CALL    KOOR_Y          ;DE - Koord
        LD      A,#20
        LD      (HDJR),A
        POP     AF
        LD      L,A
        LD      H,0
        JR      DECIMA3
;
DECIMAL LD      (TMPX),DE       ;Decimal 0-65535
        EX      DE,HL           ;HL - Word
        CALL    KOOR_Y          ;DE - Koord
        LD      A,#20
        LD      (HDJR),A
        LD      DE,#2710
        CALL    PRIDCM
DECIMA4 LD      DE,#3E8
        CALL    PRIDCM          ;7
DECIMA3 LD      DE,#64
        CALL    PRIDCM          ;8
        LD      DE,10
        CALL    PRIDCM          ;9
        LD      A,L
        ADD     A,#30           ;10
        JP      PRIA
PRIDCM  XOR     A
PRIDCM5 SBC     HL,DE
        JR      C,PRIDCM2
        INC     A
        JR      PRIDCM5
PRIDCM2 ADD     HL,DE
        AND     A
HDJR    JR      NZ,PRIDCMS
        LD      A," "
        PUSH    HL
        CALL    PRIA
        POP     HL
        RET
PRIDCMS ADD     A,#30
        PUSH    HL
        CALL    PRIA
        POP     HL
        LD      A,#18
        LD      (HDJR),A
        RET
;
DECDB                   ;DEHL - HEX
        LD      A,#20
        LD      (HEXD15),A
;       PUSH HL
;       LD HL,59*256+154
;       LD (HEXD11+1),HL
;       LD HL,202*256+0
;       LD (HEXD12+1),HL
;       POP HL
;       CALL HEXD10             ;1
;       PUSH HL
;       LD HL,5*256+245
;       LD (HEXD11+1),HL
;       LD HL,225*256+0
;       LD (HEXD12+1),HL
;       POP HL
;       CALL HEXD10             ;2
;       PUSH HL
;       LD HL,152
;       LD (HEXD11+1),HL
;       LD HL,150*256+128
;       LD (HEXD12+1),HL
;       POP HL
;       CALL HEXD10             ;3
        PUSH HL
        LD HL,15
        LD (HEXD11+1),HL
        LD HL,66*256+64
        LD (HEXD12+1),HL
        POP HL
        CALL HEXD10             ;4
        PUSH HL
        LD HL,1
        LD (HEXD11+1),HL
        LD HL,134*256+160
        LD (HEXD12+1),HL
        POP HL
        CALL HEXD10             ;5
        PUSH HL
        LD HL,0
        LD (HEXD11+1),HL
        LD HL,10000
        LD (HEXD12+1),HL
        POP HL
        CALL HEXD10             ;6
;
        LD A,(HEXD15)
        LD (HDJR),A
        JP DECIMA4

HEXD10  XOR A
HEXD12  LD BC,0
        OR A
        SBC HL,BC
        EX DE,HL
HEXD11  LD BC,0
        SBC HL,BC
        JR C,HEXD13
        EX DE,HL
        INC A
        JR HEXD12
HEXD13
        EX DE,HL
        LD BC,(HEXD12+1)
        ADD HL,BC
        EX DE,HL
        LD BC,(HEXD11+1)
        ADC HL,BC
        EX DE,HL
        OR A
HEXD15  JR      NZ,PRIDCMY
        LD      A," "
        PUSH    HL
        PUSH    DE
        CALL    PRIA
        POP     DE
        POP     HL
        RET
PRIDCMY ADD     A,#30
        PUSH    HL
        PUSH    DE
        CALL    PRIA
        POP     DE
        POP     HL
        LD      A,#18
        LD      (HEXD15),A
        RET
PRI_HEX1 PUSH AF                        ;HEX Byte
        LD      (TMPX),DE               ;DE - Koord
        CALL    KOOR_Y                  ;A - Byte
        POP     AF
        JR      PRIHB
PRI_HEX2 LD     (TMPX),DE               ;HEX Word
        EX      DE,HL                   ;DE - Koord
        CALL    KOOR_Y                  ;HL - Word
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
        LD      HL,(FOADRS)
        ADD     A,L
        LD      L,A
        LD      A,C
        RRA
        LD      D,FONT/256
        LD      B,#0F
        JR      C,NOCHET
        LD      B,#F0
NOCHET  DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0,#2477
        DEFB    #14
        DEFW    #AE1A,#AEA0
        DEFB    #77
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
;---------------------
NUMPROG DEFB    0
TMPX    DEFB    0
TMPY    DEFB    0
FOADRS  DEFW    0
LENDE0  DEFW    0
LENHL0  DEFW    0
SIZDE0  DEFW    0
SIZHL0  DEFW    0
;
EOF     DISPLAY EOF
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

