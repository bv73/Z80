        ORG     #8000
;====================
FONT    EQU     #B800
BUFDOS  EQU     #A800
BUFDOS2 EQU     BUFDOS+#800
;===================
        DISPLAY 10000
        CALL    CATFILE
        RET
        LD      HL,NAME
        LD      DE,0
        LD      BC,16384
        CALL    SVFILE
        LD      HL,NAME
        LD      DE,#4000
        LD      BC,2048
        LD      A,3
        CALL    LDFILE
        RET
NAME    DEFB    "FILE0001C"
DRIVE   DEFB    "A"
CATFILE CALL    CATBIN
        LD      DE,#510
        CALL    PFILES
        LD      DE,#51C
        CALL    PFILES
        LD      DE,#528
        CALL    PFILES
        CALL    PAK_EN
        JP      CLOSEWIN
SELFILE CALL    CATBIN
        LD      A,0
FILES   EQU     $-1
        AND     A
        RET     Z
;       LD      (MUK1),A
;       CALL    PLENS



SHOW_PD LD      HL,#B0B
        LD      (#59E6),HL
        LD      (#59EF),HL
        LD      (#59F4),HL
        LD      (#59F6),HL
        LD      DE,#F1F
        LD      A,(BUFDOS2+244)
        PUSH    AF
        CALL    DEC99
        POP     BC
        LD      A,(BUFDOS2+228)
        SUB     B
        LD      DE,#F0D
        CALL    DEC99
        LD      BC,(BUFDOS2+229)
        LD      DE,#F29
        CALL    DEC9999
        CALL    AFILES
        LD      A,E
        PUSH    AF
        LD      DE,#F12
        CALL    DEC99
        POP     AF
        AND     A
        RET     NZ
        LD      IX,WIDOSNF2
        CALL    OPENWIN
        CALL    PAK_EN
        CALL    CLOSEWIN
        XOR     A
        RET
CATBIN  LD      BC,#905
        LD      HL,BUFDOS
        LD      DE,0
        CALL    DOS
        RET     C
        LD      HL,BUFDOS2+245
        LD      DE,F_DNAME
        LD      BC,8
        LDIR
        LD      IX,WIDOSCT
        CALL    OPENWIN
        CALL    SHOW_PD
        LD      (FILES),A
        LD      IX,BUFDOS
        LD      DE,#504
PFILES  LD      (F_PFI2),DE
        XOR     A
        LD      (F_PFI1),A
PFILESL LD      A,(IX)
        AND     A
        RET     Z
        CP      1
        JR      Z,PFIL1
        LD      DE,0
F_PFI2  EQU     $-2
        LD      A,0
F_PFI1  EQU     $-1
        ADD     A,D
        LD      D,A
        PUSH    IX
        POP     HL
        LD      B,8
        CALL    PRI_B
        LD      A,"."
        CALL    _RIA
        LD      A,(IX+8)
        CALL    _RIA
        LD      HL,F_PFI1
        INC     (HL)
PFIL1   LD      BC,16
        ADD     IX,BC
        LD      A,(F_PFI1)
        CP      10
        JR      NZ,PFILESL
        RET
AFILES  LD      IX,BUFDOS
        LD      E,0
        LD      BC,16
AFIL1   LD      A,(IX)
        ADD     IX,BC
        AND     A
        RET     Z
        CP      1
        JR      Z,AFIL1
        INC     E
        JR      AFIL1
SVFILE  LD      (F_LDD2),DE
        LD      (F_LDB2),BC
        LD      DE,23773
        LD      BC,9
        LDIR
        CALL    INIDOS
        RET     C
        LD      C,10
        CALL    DOS
        RET     C
        BIT     7,C
        JR      NZ,SVEXIS
        LD      IX,WIDOSEX
        CALL    OPENWIN
        LD      A,16
        LD      (#5905),A
        LD      (#590A),A
SVEX1   LD      A,#FD
        IN      A,(#FE)
        RRA
        JR      NC,DOS03
        LD      A,#DF
        IN      A,(#FE)
        BIT     1,A
        JR      NZ,SVEX1
        CALL    CLOSEWIN
        LD      C,18
        CALL    DOS
        RET     C
SVEXIS  LD      C,11
        LD      HL,0
F_LDD2  EQU     $-2
        LD      DE,0
F_LDB2  EQU     $-2
        JP      DOS
LDFILE  LD      (F_LDD),DE
        LD      (F_LDB),BC
        LD      (F_LDA),A
        LD      DE,23773;HL=ADR HEAD
        LD      BC,9    ;DE=START
        LDIR            ;BC=LEN
        CALL    INIDOS
        RET     C
        LD      C,14
        LD      HL,0
F_LDD   EQU     $-2
        LD      DE,0
F_LDB   EQU     $-2
        LD      A,0
F_LDA   EQU     $-1
        CALL    DOS
        RET     C
        JP      ER_DOS
INIDOS  LD      C,1
        LD      A,(DRIVE)
        SUB     A
        AND     3
        CALL    DOS
        RET     C
        LD      C,#18
DOS     CALL    DOS1
        LD      A,(#5C3A)
        CP      #FF
        JR      Z,DOS02
        CP      #14
        JR      NZ,DOS00
        LD      IX,WIDOSBR
        CALL    OPENWIN
        CALL    PAK_EN
DOS03   CALL    CLOSEWIN
        SCF
        RET
DOS00   CP      #1A
        JR      NZ,DOS04
        LD      A,(#5D0F)
        CP      7
        JR      Z,DOS04
        LD      IX,WIDOSND
        CALL    OPENWIN
        CALL    ABORET
        CALL    CLOSEWIN
        AND     A
        JR      Z,DOS
DOS04   SCF
        RET
DOS02   AND     A
        RET
;-----------
ER_DOS  LD      A,(#5D0F)
        CP      1
        JR      Z,E_DOS1
        CP      #FF
        JR      NZ,DOS02
E_DOS1  LD      IX,WIDOSNF
        CALL    OPENWIN
        CALL    PAK_SP
        CALL    CLOSEWIN
        SCF
        RET
DOS1    DI
        PUSH    HL
        LD      HL,#5C3A
        LD      (HL),#FF
        LD      L,#C2
        LD      (HL),#C3
        LD      HL,C9PROG
        LD      (#5CC3),HL
        LD      HL,0
        LD      (#5D0F),HL
        POP     HL
        CALL    IN3D13
        DI
        LD      HL,#5CC2
        LD      (HL),#C9
        LD      HL,(#5CB2)
        DEC     HL
        DEC     HL
        LD      (HL),#13
        DEC     HL
        LD      (HL),3
        LD      (#5C3D),HL
        RET
IN3D13  LD      (#5C3D),SP
        CALL    #3D13
        RET
;--------------------
C9PROG  EX      (SP),HL
        PUSH    HL
        PUSH    AF
        PUSH    DE
        EX      DE,HL
        OR      A
        LD      HL,#28E
        SBC     HL,DE
        JR      Z,C9PROG9
        OR      A
        LD      HL,#31E
        SBC     HL,DE
        JR      Z,C9PROG8
        OR      A
        LD      HL,#333
        SBC     HL,DE
        JR      Z,KEYDOS
        OR      A
        LD      HL,#D6B
        SBC     HL,DE
        JR      Z,C9PROG1
        OR      A
        LD      HL,#10
        SBC     HL,DE
        JR      Z,C9PROGA
        OR      A
        LD      HL,#1A1B
        SBC     HL,DE
        JR      Z,C9PROG1
        POP     DE
        POP     AF
        POP     HL
        EX      (SP),HL
        RET
C9PROG8 SCF
C9PROG9 POP     DE
        INC     SP
        INC     SP
        POP     HL
        POP     HL
        RET
C9PROG1 POP     DE
C9PROG0 POP     AF
C9PROG2 POP     HL
        POP     HL
        RET
;-------------------
C9PROGA POP     DE
        POP     AF
        PUSH    AF
        CP      #3F
        JR      Z,C9PROG0
        LD      HL,TRIGGER
        CP      #64
        JR      NZ,C9PROGB
        LD      (HL),0
        JR      C9PROG0
C9PROGB CP      #69
        JR      NZ,C9PROG0
        LD      (HL),1
        JR      C9PROG0
;-----------------------
KEYDOS  LD      IX,WIDOSPR
        LD      A,0
TRIGGER EQU     $-1
        AND     A
        JR      Z,PRIWND2
        LD      IX,WIDOSDM
PRIWND2 CALL    OPENWIN
        CALL    ABORET
        AND     A
        LD      A,"R"
        JP      Z,PRIWND3
        LD      A,"A"
PRIWND3 CALL    CLOSEWIN
        JP      C9PROG9
;------------------
ABORET  LD      IX,WIDOSRA      ;ABORT=1
        CALL    OPENWIN         ;RETRY=0
        LD      A,16
        LD      (#5927),A
        LD      (#592A),A
ABORET2 LD      A,#7B
        IN      A,(#FE)
        BIT     3,A
        LD      A,0
        JP      Z,CLOSEWIN
        LD      A,#FD
        IN      A,(#FE)
        RRA
        JR      C,ABORET2
        LD      A,1
        JP      CLOSEWIN
;///////////////////////////////
WIDOSPR DEFW    #0408,#0312
        DEFB    (8*1)+7
        DEFW    DEHEAD
        DEFB    13,2,"Write protect!",0
DEHEAD  DEFB    " ERROR ",0
WIDOSDM DEFW    #0408,#0310
        DEFB    (8*1)+7
        DEFW    DEHEAD
        DEFB    13,2,"Disk Damaged",0
WIDOSRA DEFW    #080C,#0110
        DEFB    (8*2)+6
        DEFW    0
        DEFB    2,"Retry Abort",0
WIDOSND DEFW    #0408,#0310
        DEFB    (8*1)+7
        DEFW    DEHEAD
        DEFB    13,4,"No Disk",0
WIDOSBR DEFW    #0408,#0410
        DEFB    (8*2)+6
        DEFW    DEHEAD
        DEFB    13,5,"Break!",13
        DEFB    2,"Press ENTER",13,0
WIDOSNF DEFW    #0408,#0410
        DEFB    (8*1)+7
        DEFW    DEHEAD
        DEFB    13,4,"No file",13
        DEFB    2,"Press SPACE",13,0
WIDOSEX DEFW    #0408,#0512
        DEFB    (8*2)+6
        DEFW    DEHEAD2
        DEFB    13,3,"File Exists",13,13
        DEFB    2,"Overwrite Abort",13,0
DEHEAD2 DEFB    " WARNING! ",0
WIDOSCT DEFW    #0402,#0B30
        DEFB    (8*1)+7
        DEFW    DEHEAD3
        DEFB    13,13,13,13,13,13,13,13,13,13
        DEFB    " File(s):",5,"(",3,") Delete:",5,"Free:",0
DEHEAD3 DEFB    " Disk Name: "
F_DNAME DEFB    "         ",0
WIDOSNF2 DEFW    #080C,#0310
        DEFB    (8*0)+6
        DEFW    0
        DEFB    13,4,"No files",13,0
EOF
        DISPLAY EOF-#8000
;///////////////////////////////////////////
        ORG     #A000
PRIAALL DEFW    #AE1A,#AEA0,#2477
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
        DEFW    #AE1A,#AEA0,#C977
        ORG     #A200
TABSCR  DEFW    #4000,#4020,#4040,#4060,#4080,#40A0
        DEFW    #40C0,#40E0,#4800,#4820,#4840,#4860
        DEFW    #4880,#48A0,#48C0,#48E0,#5000,#5020
        DEFW    #5040,#5060,#5080,#50A0,#50C0,#50E0
        .INCLUDE TERWIN2
;OPENWIN EQU    #C37F
;CLOSEWIN EQU   #C311
;_RIA   EQU     #C4CA
;_OOR_Y EQU     #C4EC
;_MPX   EQU     #C63C
;PRI_B  EQU     #C5C5
;PAK_SP EQU     #C63E
;PAK_EN EQU     #C646
;DEC99  EQU     #C64E
;DEC9999 EQU    #C651
;------------------
 CURSOR2 EQU     0
 KEYPROC EQU     0
 CURMODE EQU     0
        ORG     #B800
        .INCBIN FONT
        .RUN    #8000

