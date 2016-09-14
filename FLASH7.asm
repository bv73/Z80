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
FILWIN  EQU     17              ;Files in Window
XT      EQU     46              ;Firmware Tab
ZT      EQU     46
CT      EQU     ZT+12
;-------------------
;1C CLS
;1D Set X
;1E Set X,Y
;1F Fill Sym,Num
;FF Inverse
;------------------
START   DI
        XOR     A
        LD      (FIRSTN),A
        OUT     (#FE),A
        CALL    PRI_T
        DEFB    #1C
        DEFB    #DA
        DEFB    #1F,#C4,#1E
        DEFB    #BF,13,#B3,#20,#FF
        DEFB    " Flash Drive for Speccy 1.0 ",#FF,#20,#B3,13
        DEFB    #B3,#20,#FF,"     (C) By (R)soft 1999    "
        DEFB    #FF,#20
        DEFB    #B3,13,#C0
        DEFB    #1F,#C4,#1E
        DEFB    #D9,0
        CALL    FIRMWAR
        CALL    PRI_T
        DEFB    13,"Flash Drive ",0
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
TXTDET  DEFB    "Detected.",13,13,0
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
        LD      HL,#000C        ;Addr
        CALL    RD_FL0          ;Read 1 Byte
        CP      #FF
        JR      Z,WARNING
        LD      HL,TXTDET
        CALL    PRI_BB
        JP      NOWARN
WARNING CALL    PRI_T
        DEFB    "Not Present.",13
        DEFB    "Insert Flash Card into Drive "
        DEFB    "and Press <ENTER> to Continue.",13,13,0
        CALL    PRESENTER
NOWARN  CALL    PRI_T
        DEFB    "Reading Catalogue. ",0
        LD      C,0     ;Page
        LD      HL,0    ;Addr
        CALL    READ_PAGE
        LD      A,(#C00C)
        CP      #FF
        JR      NZ,CATSH0
        CALL    PRI_T
        DEFB    "Flash Card Clean or Not Inserted.",13,0
        JP      EXIT0
CATSH0  CALL    CATSHOW
        CALL    SHOW2
        CALL    FIRMWAR
;
        CALL    HEAD
        LD      B,FILWIN        ;Lines
        CALL    SHOWMAI
        CALL    HEADEND
        CALL    PRI_T
        DEFB    #1E,0,23
        DEFB    #FF,"F3",#FF,"-View  "
        DEFB    #FF,"F4",#FF,"-Add  "
        DEFB    #FF,"F5",#FF,"-Extr  "
        DEFB    #FF,"F6",#FF,"-RenMove  "
        DEFB    #FF,"F8",#FF,"-Del  "
        DEFB    #FF,"F9",#FF,"-Print  "
        DEFB    #FF,"F10",#FF,"-Exit",0
        EI
        CALL    SELECT
        CP      "0"
        RET     Z
        CP      "t"
        JR      NZ,ST1
        CALL    TABHAFM
        JR      CATSH0
ST1     CP      "r"
        JP      NZ,START
        JP      START
TABHAFM
        XOR     A
        LD      (PREF1),A
        LD      A,"1"
        LD      (THAF),A
        LD      IX,#CC80
HAFMP00
        CALL    PRI_T
        DEFB    #1C,"Table [1] "
THAF    EQU     $-3
        DEFB    "of Haffman Codes: "
        DEFB    "Addr #0C80, MaxLen #200",0
        LD      HL,#0100
HAFMP0
        LD      B,22
HAFMP1
        PUSH    BC
        PUSH    HL
        LD      (TMPX),HL
        LD      A,L
        CP      60
        JR      Z,HAFMPL
        CALL    KOOR_Y
        LD      L,(IX)
        LD      H,(IX+1)
        LD      A,L
        OR      H
        JR      NZ,HAFMP2
        LD      A,0
PREF1   EQU     $-1
        AND     A
        JR      NZ,HAFMPE
        LD      A,#FF
        LD      (INVERSE),A
        LD      (PREF1),A
        CALL    BINHL
        XOR     A
        LD      (INVERSE),A
        JR      HAFMP3
HAFMP2  CALL    BINHL
        XOR     A
        LD      (INVERSE),A
        LD      (PREF1),A
HAFMP3  INC     IX
        INC     IX
        POP     HL
        POP     BC
        INC     H
        DJNZ    HAFMP1
        LD      H,1
        LD      A,10
        ADD     A,L
        LD      L,A
        JR      HAFMP0
HAFMPL
        POP     HL
        POP     BC
        LD      HL,THAF
        INC     (HL)
        CALL    PRI_T
        DEFB    #1E,0,23,"Press ENTER to Continue.",0
        CALL    PRESENTER
        JP      HAFMP00
HAFMPE
        POP     HL
        POP     BC
        CALL    PRI_T
        DEFB    #1E,0,23,"Press ENTER to Exit.",0
        CALL    PRESENTER
        RET
BINHL
        LD      A,H
        PUSH    HL
        RRA
        LD      A,"1"
        JR      C,BINHL0
        DEC     A
BINHL0  CALL    PRIA
        POP     HL
        LD      A,L
        LD      B,8
BINAL
        RLA
        PUSH    AF
        PUSH    BC
        LD      A,"1"
        JR      C,BINA0
        DEC     A
BINA0   CALL    PRIA
        POP     BC
        POP     AF
        DJNZ    BINAL
        RET
PRESENTER LD      A,#BF
        IN      A,(#FE)
        RRA
        JR      C,PRESENTER
        RET
PRILIN  PUSH    AF              ;A - Num Prog
        LD      A,#B3           ;IX - Addr
        CALL    PRIA
        POP     AF
        LD      HL,TMPX
        LD      (HL),1
        CALL    DEC00
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
        CALL    PRI_B_
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
PROGS0  LD      A,(IX)
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
LENPS0  LD      A,(IX)
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
LENADD  LD      BC,(LENHL0)
        AND     A
        ADD     HL,BC
        LD      (LENHL0),HL
        LD      HL,(LENDE0)
        ADC     HL,DE
        LD      (LENDE0),HL
        RET
SIZADD  LD      BC,(SIZHL0)
        AND     A
        ADD     HL,BC
        LD      (SIZHL0),HL
        LD      HL,(SIZDE0)
        ADC     HL,DE
        LD      (SIZDE0),HL
        RET
FREE    LD      DE,4
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
DATE    LD      A,#1F
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
TIME    LD      B,5
        CALL    ROTA
        LD      A,#3F
        AND     L
        PUSH    HL
        CALL    DEC00
        LD      A,":"
        CALL    PRIA
        POP     HL
        LD      B,6
        CALL    ROTA
        LD      A,#1F
        AND     L
        JP      DEC00
ROTA    SRL     H
        RR      L
        DJNZ    ROTA
        RET
SELECT  XOR     A
        LD      (TABSF),A
        LD      (TABSF+5),A
        LD      A,(TABSF+4)
        LD      HL,FILES
        CP      (HL)
        JR      C,SELECT0
        LD      A,(HL)
SELECT0 LD      (F_SELF0),A
SELFILF XOR     A
        LD      IX,TABSF
        LD      (23560),A
        CALL    INVER_S
        CALL    DOWNFIL
SELFI_  LD      IX,TABSF
        LD      HL,23560
        LD      A,(HL)
        AND     A
        JR      Z,SELFI_
        LD      (HL),0
        CP      10              ;Down Key
        JR      NZ,CSELF1
SELFID0 LD      A,0
F_SELF0 EQU     $-1
        DEC     A
        CP      (IX)
        JR      Z,SELFID
        CALL    INVER_S
        INC     (IX)
        INC     (IX+5)
        JR      SELFILF
SELFID  LD      A,(FIRSTN)
        ADD     A,FILWIN
        CP      0                       ;All Files
FILES   EQU     $-1
        JR      NC,SELFI_
        INC     (IX+5)
        SUB     FILWIN-1
        LD      (FIRSTN),A
CSELF11 CALL    SEARCH
        LD      DE,#0300
        PUSH    IX
        CALL    PFILES
        LD      A,(FIRSTN)
        CALL    PUDCODE
        POP     IX
        CALL    DOWNFIL
        JR      SELFI_
CSELF1  CP      11              ;Up Key
        JR      NZ,CSELF2
        LD      A,(IX)
        AND     A
        JR      Z,SELFIU
        CALL    INVER_S
        DEC     (IX)
        DEC     (IX+5)
        JR      SELFILF
SELFIU  LD      A,(FIRSTN)
        AND     A
        JR      Z,SELFI_
        DEC     (IX+5)
        DEC     A
        LD      (FIRSTN),A
        JP      CSELF11
CSELF2  CP      "0"             ;F10 - Exit
        JR      NZ,CSELF3
        JP      INVER_S
CSELF3  CP      "9"             ;F9 - Lprint
        JR      NZ,CSELF32
        CALL    INVER_S
        CALL    SHOWLPT
        JP      SELFILF
CSELF32 CP      "2"             ;Save
        JR      NZ,CSELF33
        CALL    INVER_S
        CALL    SAVEFIL
        JP      SELFILF
CSELF33 CP      "t"             ;Table
        JR      NZ,CSELF34
        RET
CSELF34 CP      "r"
        JR      NZ,CSELF39
        RET
CSELF39 CP      13              ;Select File
        JP      NZ,SELFI_
        LD      C,(IX+5)
        LD      B,0
        LD      HL,TABUD
        ADD     HL,BC
        LD      A,(HL)
        AND     A
        LD      A,#FF
        JR      Z,CSELF4
        XOR     A
CSELF4  LD      (HL),A
        LD      A,(FIRSTN)
        CALL    PUDCODE
        JP      SELFID0
DOWNFIL LD      A,(TABSF+5)
        CALL    SEARCH
        PUSH    IX
        POP     HL
        LD      BC,#0C
        ADD     HL,BC
        LD      A,(F_SELF0)
        LD      D,4
        ADD     A,D
        LD      D,A
        LD      E,1
        LD      (TMPX),DE
        EX      DE,HL
        CALL    KOOR_Y
        PUSH    HL
        CALL    PRI_T
        DEFB    ">> ",0
        POP     HL
        LD      B,8
        PUSH    HL
        CALL    PRI_B_
;
        CALL    PRI_T
        DEFB    #1E,CT-2,14,0
        POP     HL
        LD      B,8
        CALL    PRI_B_
        CALL    PRI_T
        DEFB    13,#1D,CT,0
;
        LD      A,(IX+2)        ;!!!
        CALL    PRIHB
        LD      L,(IX)
        LD      H,(IX+1)
        CALL    PRIHEX
        CALL    PRI_T
        DEFB    13,#1D,CT,0
;
        LD      A,(IX+6)
        CALL    PRIHB
        LD      L,(IX+4)
        LD      H,(IX+5)
        CALL    PRIHEX
        CALL    PRI_T
        DEFB    13,#1D,CT,0
;
        LD      E,(IX)
        LD      D,(IX+1)
        LD      L,(IX+4)
        LD      H,(IX+5)
        AND     A
        ADD     HL,DE
        LD      A,(IX+6)
        LD      C,(IX+2)
        ADC     A,C
        PUSH    HL
        CALL    PRIHB
        POP     HL
        CALL    PRIHEX
        CALL    PRI_T
        DEFB    13,#1D,CT,0
;
        LD      A,(IX+#16)
        CALL    PRIHB
        LD      L,(IX+#14)
        LD      H,(IX+#15)
        JP      PRIHEX
;
INVER_S PUSH    AF
        LD      A,(IX+2)        ;Print Cursor
        ADD     A,(IX)
        LD      L,A
        LD      H,0
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        LD      A,(IX+1)
        ADD     A,L
        LD      L,A
        LD      BC,#5800
        ADD     HL,BC
        LD      A,(HL)
        XOR     #3F
        LD      (HL),A
        LD      D,H
        LD      E,L
        INC     DE
        LD      C,(IX+3)
        DEC     C
        LD      B,0
        LDIR
        POP     AF
        RET
SEARCH  LD      IX,#C020        ;A - Num File
        AND     A               ;Exit: IX-Addr
        RET     Z
        LD      E,A
        LD      BC,#20
SEARCH1 LD      A,(IX)
        ADD     IX,BC
        CP      #FF
        RET     Z
        DEC     E
        JR      NZ,SEARCH1
        RET
PFILES  LD      (TMPX),DE       ;DE-Koor
        CALL    KOOR_Y          ;IX-Addr
        LD      A,(FIRSTN)
        INC     A
        LD      C,A
        LD      B,FILWIN
PFILE0  LD      A,(IX)
        CP      #FF
        RET     Z
        PUSH    BC
        LD      A,C
        CALL    PRILIN
        INC     (HL)
        DEC     HL
        LD      (HL),0
        CALL    KOOR_Y
        LD      BC,#20
        ADD     IX,BC
        POP     BC
        INC     C
        DJNZ    PFILE0
        RET
PUDCODE LD      C,A             ;A - Num File
        LD      B,0
        LD      HL,TABUD
        ADD     HL,BC
        LD      A,(F_SELF0)
        LD      B,A
        LD      DE,#0301
        INC     C
PUDCL   PUSH    BC
        PUSH    HL
        PUSH    DE
        LD      (TMPX),DE
        EX      DE,HL
        CALL    KOOR_Y
        LD      A,(HL)
        LD      (INVERSE),A
        LD      A,C
        CALL    DEC00
        XOR     A
        LD      (INVERSE),A
        POP     DE
        POP     HL
        INC     D
        INC     HL
        POP     BC
        INC     C
        DJNZ    PUDCL
        RET
;-------------------------
EXIT    CALL    PRI_T
        DEFB    "Not Found!",13,0
EXIT0   CALL    PRI_T
        DEFB    "Test Your Hardware.",0
        EI
        RET
TESTP   LD      (TESTPS),A
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
;____READ FLASH______
READ_PAGE
        LD      A,MASK          ;HL - Addr Flash
        ADD     A,C             ;C - Bank
        LD      (MASKB),A
        LD      DE,#C000
        LD      B,#40
L_RD_FL PUSH    BC
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
L_WR_FL LD      A,(DE)
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
RD_FL1  LD      C,PORTB         ;Latch Addr
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
CLSPAGE LD      HL,#C000
        LD      E,L
        LD      D,H
        INC     DE
        LD      (HL),L
        LD      BC,#3FFF
        LDIR
        RET
CLSCR   LD      HL,#4000
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
SHOWMAI LD      IX,#C020
        LD      C,1
LOOPSH0 LD      A,(IX)
        CP      #FF
        RET     Z
        PUSH    BC
        LD      A,C
        CALL    PRILIN
        CALL    PRI_T
        DEFB    13,0
        LD      BC,#20
        ADD     IX,BC
        POP     BC
        INC     C
        DJNZ    LOOPSH0
        RET
CATSHOW CALL    PRI_T
        DEFB    #1C,#1E,ZT,6,"Name Arc  ",0
        LD      HL,#C004
        LD      B,8
        CALL    PRI_B
;
        CALL    PRI_T
        DEFB    13,#1D,ZT,"Software  ",0
        LD      HL,#C00C
        LD      B,8
        CALL    PRI_B
;
        CALL    PRI_T
        DEFB    13,#1D,ZT,"Programs",#1F,#20,8,0
        CALL    PROGS
        LD      (FILES),A
        CALL    DEC00
;
        CALL    PRI_T
        DEFB    13,#1D,ZT,"Len All    ",0
        CALL    LENPS
        LD      HL,(LENHL0)
        LD      DE,(LENDE0)
        CALL    DECDB
;
        CALL    PRI_T
        DEFB    13,#1D,ZT,"Size All   ",0
        LD      HL,(SIZHL0)
        LD      DE,(SIZDE0)
        CALL    DECDB
;
        CALL    PRI_T
        DEFB    13,#1D,ZT,"Size Arc   ",0
        LD      DE,0
        LD      HL,#1080
        CALL    SIZADD
        LD      HL,(SIZHL0)
        LD      DE,(SIZDE0)
        CALL    DECDB
;
        CALL    PRI_T
        DEFB    13,#1D,ZT,"Free",#1F,#20,7,0
        LD      HL,(SIZHL0)
        LD      (FREE0),HL
        LD      DE,(SIZDE0)
        LD      (FREE1),DE
        CALL    FREE
        JP      DECDB
SHOW2   CALL    PRI_T
        DEFB    #1E,ZT,13               ;!!!
        DEFB    #C4,#C4,#1F,#CD,14,#C4,#C4,13
        DEFB    #1D,ZT,"File",13
        DEFB    #1D,ZT,"Address    #",13
        DEFB    #1D,ZT,"Size       #",13
        DEFB    #1D,ZT,"Next Addr  #",13
        DEFB    #1D,ZT,"Length     #",0
        RET
HEAD    CALL    PRI_T
        DEFB    #1E,0,0,#DA,#C4,#C4
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
        DEFB    #C5,#1F,#C4,8
        DEFB    #C5,#1F,#C4,7
        DEFB    #C5,#1F,#C4,7
        DEFB    #C5,#1F,#C4,10
        DEFB    #C5,#1F,#C4,5
        DEFB    #B4,13,0
        RET
HEADEND CALL    PRI_T
        DEFB    #C3,#C4,#C4
        DEFB    #C1,#1F,#C4,8
        DEFB    #C1,#1F,#C4,7
        DEFB    #C1,#1F,#C4,7
        DEFB    #C1,#1F,#C4,10
        DEFB    #C1,#1F,#C4,5
        DEFB    #B4,13,#B3,#1F,#20,#2C,#B3,13
        DEFB    #C0,#1F,#C4,#2C
        DEFB    #D9,0
        RET
FIRMWAR CALL    PRI_T
        DEFB    #1E,XT,0,#C9,#1F,#CD,15,#BB,13
        DEFB    #1D,XT,#BA," ZX Flash Card ",#BA,13
        DEFB    #1D,XT,#BA,"  Manager 1.0  ",#BA,13
        DEFB    #1D,XT,#BA,"   Copyright   ",#BA,13
        DEFB    #1D,XT,#BA," (R)soft  1999 ",#BA,13
        DEFB    #1D,XT,#C8,#1F,#CD,15,#BC,0
        RET
;--------------------------
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
PRI_B_  PUSH    BC
        LD      A,(HL)
        INC     HL
        AND     A
        JR      NZ,PRI_B_1
        DEC     HL
        LD      A," "
PRI_B_1 PUSH    HL
        CALL    PRIA
        POP     HL
        POP     BC
        DJNZ    PRI_B_
        RET
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
PRI_BB0 CP      #FF             ;Inverse
        JR      NZ,PRI_BB1
        LD      A,(INVERSE)
        XOR     #FF
        LD      (INVERSE),A
        JR      PRI_BB
PRI_BB1 CP      #20
        JR      C,PRI_BB2       ;<#20 - Attr Code
        PUSH    HL
        CALL    PRIA
        POP     HL
        JR      PRI_BB
PRI_BB2 CP      #1F             ;Fill
        JR      NZ,PRI_BB3
        LD      A,(HL)          ;Symbol Fill
        INC     HL
        LD      B,(HL)          ;Num Fill
        INC     HL
        PUSH    HL
PRI_BB4 PUSH    BC
        PUSH    AF
        CALL    PRIA
        POP     AF
        POP     BC
        DJNZ    PRI_BB4
        POP     HL
        JR      PRI_BB
PRI_BB3 CP      #1E             ;Set Koord
        JR      NZ,PRI_BB5
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        LD      (TMPX),DE
        EX      DE,HL
        CALL    KOOR_Y
        JR      PRI_BB
PRI_BB5 CP      #1D             ;Set X Koor
        JR      NZ,PRI_BB6
        LD      A,(HL)
        INC     HL
        LD      (TMPX),A
        JR      PRI_BB
PRI_BB6 CP      #1C             ;Clear Screen
        JR      Z,PRI_BB7
        LD      C,A             ;1-#1B Add X Koor
        LD      A,(TMPX)        ;(Without #0D)
        ADD     A,C
        LD      (TMPX),A
        JR      PRI_BB
PRI_BB7 PUSH    HL
        CALL    CLSCR
        LD      HL,0
        LD      (TMPX),HL
        CALL    KOOR_Y
        POP     HL
        JR      PRI_BB
;
DEC00   LD      H,0                     ;Print Dec 00-99
        LD      L,A
        JR      DEC000
DEC1999 LD      DE,1000                 ;Print Dec 0000-9999
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
        CALL    PRIDCM
DECIMA3 LD      DE,#64
        CALL    PRIDCM
        LD      DE,10
        CALL    PRIDCM
        LD      A,L
        ADD     A,#30
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
DECDB   LD      A,#20           ;DEHL - Dec Print
        LD      (HEXD15),A
        PUSH    HL
        LD      HL,15
        LD      (HEXD11+1),HL
        LD      HL,66*256+64
        LD      (HEXD12+1),HL
        POP     HL
        CALL    HEXD10
        PUSH    HL
        LD      HL,1
        LD      (HEXD11+1),HL
        LD      HL,134*256+160
        LD      (HEXD12+1),HL
        POP     HL
        CALL    HEXD10
        PUSH    HL
        LD      HL,0
        LD      (HEXD11+1),HL
        LD      HL,10000
        LD      (HEXD12+1),HL
        POP     HL
        CALL    HEXD10
        LD      A,(HEXD15)
        LD      (HDJR),A
        JP      DECIMA4
HEXD10  XOR     A
HEXD12  LD      BC,0
        OR      A
        SBC     HL,BC
        EX      DE,HL
HEXD11  LD      BC,0
        SBC     HL,BC
        JR      C,HEXD13
        EX      DE,HL
        INC     A
        JR      HEXD12
HEXD13  EX      DE,HL
        LD      BC,(HEXD12+1)
        ADD     HL,BC
        EX      DE,HL
        LD      BC,(HEXD11+1)
        ADC     HL,BC
        EX      DE,HL
        OR      A
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
        LD      HL,0
FOADRS  EQU     $-2
        ADD     A,L
        LD      L,A
        LD      A,C
        RRA
        LD      D,FONT/256
        LD      C,0
INVERSE EQU     $-1
        LD      B,#0F
        JR      C,NOCHET
        LD      B,#F0
NOCHET  LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
        INC     H
        INC     D
        LD      A,(DE)
        XOR     C
        XOR     (HL)
        AND     B
        XOR     (HL)
        LD      (HL),A
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
SHOWLPT LD      (TMPB4),SP
        LD      A,(PRIA)
        LD      HL,(PRIA+1)
        LD      (TMPB0),A
        LD      (TMPB1),HL
        LD      A,(PRI_BB)
        LD      HL,(PRI_BB+1)
        LD      (TMPB2),A
        LD      (TMPB3),HL
        LD      A,#C3
        LD      (PRIA),A
        LD      (PRI_BB),A
        LD      HL,LPT_A
        LD      (PRIA+1),HL
        LD      HL,LPT_BB
        LD      (PRI_BB+1),HL
        CALL    LPTINIT
        CALL    CATSHOW
        CALL    HEAD
        LD      A,(FILES)
        LD      B,A
        CALL óÿÿ> Óþ>? Ã‚=íGÃ Ã'   Ãr/ÉbkÃ##6+¼ úÿÿÿÿÿûÉ·íR#05(5(ó+"´\¯>¨ {ë1 `" _!y å!/=å!í¸ÃV*"_õ>É2_ñ* _Ã_ë#"{\+@íC8\"²\! <"6\*²\6>+ù++"=\ÕíVý!:\!¶\"O\¯ ëÍë+"W\#"S\"K\6€#"Y\6#6€#"a\"c\"e\>82\2\2H\!#"	\ý5Æý5Ê!Æ\ ÍýËÎ!Â\6Éçß!k\6!‹å>ª2 [ûÃ1=" _!/=å!í°"_* _Ã_Íå Í—*Y\#^#Vz³ë(¯2]åÍ2á"B\¯2D\ç°*S\+"W\í{=\:]·!v(ç°å!Â\åÉÍñ ÍJ)>ÿ2]¯2÷\>ª2]!"]!  9"]++ùÍ*²\í[]\íRë0·íR"]\ÍÇÊÓþê# õÍÇ(óþ:ÂÓ#ÍH0*]Ã
~þÈþ€È·ÉÍC!  "ø\Íå Íc!]6ª!]~·6  ÍÍí{]*]íK] éÍ2ýË ~ÀÂ\í{=\ÕÉÍŒþÈÍ*õÍ"]*]++"=\=s#rÉ*]Í É!  "÷\9"]++ùÍ!]~þª> 2]ÊË6ªÍ—Íˆ!`ß   :¶\þô(! ß: [þª SÍñ *Y\>þ2]6÷#6"#6b#6o#6o#6t#6"#"[\6#6€#"a\"c\"e\ýËÞ?~#úÉ ÅîÓÿõ>Íÿ=ñÁñÉ*]++ùÍÍƒ:]öÍ¹:]Í¹¯2]Í5!Í20ÍŸ!Ë"]¯2]*Y\å ]Í°á"]~Gæ€x(	þþ(õÍÈ=ñ!ó/+ W>¹ÚÓz#¾ óþþÄJ)>	2]¯2]2Ö\2]!;\Ë¾ !0Ë!	^#VëåYÕé!;\ËþáéTRDOS version 5.06(Turbo)Copyright (C) 1993 by Rst7   (U.K.)BETA 128 ÍýÍ€=Í€=íK
^Í©!Ò)ßÃÓõ:]þþ ñÉñ2]:]·Ì'É!(*>ÃJ!f'¯ÃJ¯2Ì\í[Ì\ ÍJ)!%]Ã=ÍJ) íÍý:^þ(!â)ß«Í>Ë†ËŽ:^ËG ËÆË_ÀËÎÉ*]#~þÉÍ+ íCÛ\(+þ# "]\ÍÍŒþ(þ,ÂÍ*Í½ÍßÍuÍµëÍÍu:ö\2ù\Í:Û\þõÌ—ñþÒÍ„>ÿ2ø\!÷)ß!^ßÍ€=:	^!^–åÍ£!+*ßáNÍ¤!*ßÍè!%]ÍöÍ€=:ö\ÆA×ÍöÅ>:×åÍ8) áå	NÅyþ
8þd0> ×ûÁÍ©áÁ ÐÀåÅ:ù\!ö\¾ÄË=ÁáÃÆ/ ÉåÅÛ¡	8ÁáÉ!Ì\4ÍìÁá!%]ÉæßÞAÚþÒÉÍµy¸ÊÉÍÍÍuÍ.Í°:ö\2ø\ÂÙÅÍ]Í°õ:ø\!ö\¾ÂÍñÊPÁÍkÍCÃá:]·É:]·ÊÙÃáÅÍ—:ö\ÆAÍ‚=>:Í‚=!Ý\Í8)! (Í'ÍRþYõÍ—ñÁÀÅÍ—ÁÍ¯É:å\þ#(¯É>
2]Í³>	2]É:Ý\þ*ÂÙÍµëÍ~þ*Â:ö\2ù\:ù\ÍË=Í>ÿ2]:ø\ÍË=Í:]<2]OÍ]:Ý\þ Êáþ(à!æ\í\ í°:ù\ÍË=Í³ 
Í´ Í ÀÍ<ÍC¸Íý:	^þ€ÊE!í\æ\ í°í[ê\ ·*
^íRÚE"
^*^"ë\åÍ/á"ë\*ô\"^!	^4N Å	 íSô\ÍCÁÍkÉ*]#~æßþSÊ`þBÊ,ÍÍÍuÍoÍ.Í°:ö\2ø\ÂËÍ]!æ\í\ í°Í°õÅ:ö\2ù\:ø\ÍË=Í:ù\ÍË=ÍÁñ Í´ ÍÂáÍ<ÍC:å\þ#Âá>
2]!æ\4:ø\ÍË=Í´ÂáÍ]!æ\í\ í°:ù\ÍË=ÍÄ:ñ\·Èå!#]–á09:ñ\G¯2ñ\Å:ø\ÍË=ÁÅ*Ï\åí[ò\Í=*ô\"ò\:ù\ÍË=áÁí[ë\ÍM*ô\"ë\º2ñ\å!#]Fá¯Ã¯2]ÍßÍuÍ.¯2]Í/)Í ÂwÃá:Ý\2]À!]4ÅÍý:	^Á¹ =2	^¯õ(!^4ÅÍCÁÍ]ñÊÒ>2Ý\õÍ@:]2Ý\ñ(Í³¹Íý*ë\"^í[ê\*
^ "
^ÃCæüÃš=Í#Ãñ ÿÿÿÿÿÙ   Ù*=\ÉÿÿÿÿÿÿÿÙ!X'Ù"=\Éÿÿÿÿÿÿÿ><Óÿ       >ÐÓÉÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ