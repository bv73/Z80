        XOR A
        LD (PRPLAY+1),A
        LD (MFIRE),A
        LD (LMENU3+1),A
        LD (LMENU2+1),A
        CPL
        LD (LRMEN+1),A
        CALL SPRINT
        CALL MMENU1
        POP IY
        POP HL
        EXX
        EI
        RET

MMENU1
        LD A,(MFIRE)
        OR A
        JP NZ,LMENU
        CALL Z,LMENU2
LMENR   CALL MOUSPRN
LMENR2  EI
        HALT
        DI
        LD HL,(MOUSK+1)
        PUSH HL
        CALL MOUSDV
        POP HL
        LD A,(MFIRE)
        CP #FF
        JP Z,LMENR1
        LD A,(MOUSK+1)
        CP L
        JP NZ,LMENR1
        LD A,(MOUSK+2)
        CP H
        JP Z,LMENR2
LMENR1
        CALL MOUSCLS
        LD A,#F7
        IN A,(#FE)
        AND 1
        JP NZ,MMENU1
        LD A,#FE
        IN A,(#FE)
        AND 1
        RET Z
        JP MMENU1
LMENU2  LD A,0
        OR A
        RET Z
        LD E,A
        LD D,0
        LD BC,#0A08
        LD (LMENU3+1),BC
        LD BC,#1173
        LD (LMENU4+1),BC
LMENU3  LD BC,0
        LD A,(MOUSK+2)
        CP B
        JP C,LMENU5
        LD A,(MOUSK+1)
        CP C
        JP C,LMENU5
LMENU4  LD BC,0
        LD A,(MOUSK+2)
        CP B
        JP NC,LMENU5
        LD A,(MOUSK+1)
        CP C
        JP NC,LMENU5
        LD A,(LRMEN+1)
        CP D
        RET Z
        PUSH DE
        CALL LRMEN
        LD HL,(LMENU3+1)
        LD (LRMEN1+1),HL
        LD HL,(LMENU4+1)
        LD (LRMEN2+1),HL
        CALL LRMEN1
        POP DE
        LD A,D
        LD (LRMEN+1),A
        RET
LMENU5
        LD A,(LMENU3+2)
        ADD A,8
        LD (LMENU3+2),A
        LD A,(LMENU4+2)
        ADD A,8
        LD (LMENU4+2),A
        INC D
        LD A,D
        CP E
        JP NZ,LMENU3
        CALL LRMEN
        LD A,#FF
        LD (LRMEN+1),A
        RET
LRMEN   LD A,#FF
        CP #FF
        RET Z
LRMEN1  LD HL,0
LRMEN2  LD DE,0
BOX
        LD BC,TABLD2
        LD A,L
        AND 7
        ADD A,C
        LD C,A
        ADC A,B
        SUB C
        LD B,A
        LD A,(BC)
        LD (BOX1+1),A
        LD BC,TABLD3
        LD A,E
        AND 7
        ADD A,C
        LD C,A
        ADC A,B
        SUB C
        LD B,A
        LD A,(BC)
        LD (BOX2+1),A
        LD A,D
        SUB H
        LD B,A
        LD A,L
        AND #F8
        LD C,A
        LD A,E
        SUB C
        AND #F8
        RRCA
        RRCA
        RRCA
        LD C,A
        OR A
        JP Z,BOX4
        DEC C
BOX4
        EX DE,HL
        PUSH BC
        CALL COORD
        POP BC
BOX1
        LD A,0
        PUSH BC
        PUSH HL
        XOR (HL)
        LD (HL),A
        INC HL
        LD A,C
        OR A
        JP Z,BOX2
BOX3
        LD A,#FF
        XOR (HL)
        LD (HL),A
        INC HL
        DEC C
        JP NZ,BOX3
BOX2
        LD A,0
        XOR (HL)
        LD (HL),A
        POP HL
        POP BC
        CALL NEXTLNH
        DJNZ BOX1
        RET


LMENU   LD A,(LRMEN+1)
        CP #FF
        JR Z,LMENU11
        CALL MOUSPRN
        CALL PEREG
        LD A,#FF
        LD (LRMEN+1),A
        XOR A
        LD (LMENU2+1),A
        JP LMENR
LMENU11
        CALL  MENU
        JP LMENR
MENU
        LD HL,TCOORD
        DEFB #DD
        LD L,0
MENU2
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD A,B
        CP #FF
        RET Z
        LD A,(MOUSK+2)
        CP B
        JP C,MENU1
        LD A,(MOUSK+1)
        CP C
        JP C,MENU1
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD A,(MOUSK+2)
        CP B
        JP NC,MENU5
        LD A,(MOUSK+1)
        CP C
        JP NC,MENU5
        LD E,(HL)
        INC HL
        LD D,(HL)
        EX DE,HL
        JP (HL)
MENU1
        INC HL
        INC HL
MENU5
        INC HL
        INC HL
        DEFB #DD
        INC L
        JP MENU2
MOUSCLS
        LD DE,0
MOSCLS3
        LD HL,MOBUF1
        LD BC,#200
        DEFB #DD
MOSCLS2
        LD L,16
MOSCLS1
        LDI
        LDI
        LDI
        DEC DE
        DEC DE
        DEC DE
        CALL NEXTLND
        DEFB #DD
        DEC L
        JP NZ,MOSCLS1
        RET
MOUSEO
        LD A,#C9
        LD (MOUSEO),A
        LD A,#90
        OUT (#7F),A
        OUT (#5F),A
        LD BC,#FADF
        IN A,(C)
        LD B,#FB
        IN L,(C)
        LD B,#FF
        IN H,(C)
        CP H
        JP Z,MOUSKNO
        CP L
        JP NZ,MOUSKNL
MOUSKNO
        LD A,#C9
        LD (MOUSKEM),A
        JP MOUSKKK
MOUSKNL
        LD A,#C9
        LD (MOUSAY),A
MOUSKKK
        LD BC,#FBDF
        IN A,(C)
        LD (MOUSDV7+1),A
        LD B,#FF
        IN A,(C)
        LD (MOUSDV7+2),A
        LD BC,#1F
        IN A,(C)
        CP #FF
        JP NZ,MOUSKNK
        LD A,#C9
        LD (JOYSKEM),A
MOUSKNK
        LD BC,65533
        LD A,7
        OUT (C),A
        EXX
        LD BC,49149
        LD A,#FF
        OUT (C),A
        EXX
        LD A,#0E
        OUT (C),A
        EXX
        LD A,#7F
        OUT (C),A
        LD A,#3F
        OUT (C),A
        LD A,#7F
        OUT (C),A
        LD A,#3F
        OUT (C),A
        EXX
        IN A,(C)
        AND #0F
        CP 8
        RET Z
        LD A,#C9
        LD (MOUSAY),A
        RET
MOUSAY
        LD A,#07
        LD BC,#FFFD
        OUT (C),A
        EXX
        LD BC,49149
        LD A,#FF
        OUT (C),A
        EXX
        LD A,#0E
        OUT (C),A
        EXX
        LD A,#3F
        OUT (C),A
        EXX
        LD HL,MOUSK+1
        IN A,(C)
        AND #0F
        SUB 8
        JP P,MOUSE3
        NEG
        ADD A,A
        LD D,A
        LD A,(HL)
        SUB D
        JR NC,MOUSE4
        XOR A
        JR MOUSE4
MOUSE3  ADD A,A
        ADD A,(HL)
        JR NC,MOUSE4
        LD A,#FE
MOUSE4  LD (HL),A
        EXX
        LD A,#7F
        OUT (C),A
        EXX
        IN A,(C)
        AND #0F
        LD HL,MOUSK+2
        SUB 8
        JP M,MOUSE6
        ADD A,A
        LD D,A
        LD A,(HL)
        SUB D
        JR NC,MOUSE7
        XOR A
        JR MOUSE7
MOUSE6  NEG
        ADD A,A
        ADD A,(HL)
        CP MAXY
        JR C,MOUSE7
        LD A,MAXY
MOUSE7  LD (HL),A
        EXX
        LD A,#3F
        OUT (C),A
        EXX
        LD HL,MFIRE
        IN A,(C)
        BIT 4,A
        JR Z,MOUSE8
        BIT 5,A
        RET NZ
MOUSE8  LD (HL),#FF
        RET
MOUSKEM
        LD HL,(MOUSK+1)
        LD BC,#FBDF
MOUSDV7 LD DE,0
        IN A,(C)
        LD (MOUSDV7+1),A
        SUB E
        JP P,MOUSDV9
        ADD A,A
        ADD A,L
        JR NC,MOUSDV8
        LD L,A
        JR MOUSDV8
MOUSDV9 ADD A,A
        ADD A,L
        JR C,MOUSDV8
        LD L,A
MOUSDV8
        LD B,#FF
        IN A,(C)
        LD (MOUSDV7+2),A
        SUB D
        NEG
        JP P,MOUSDVA
        ADD A,A
        ADD A,H
        JR NC,MOUSDVB
        LD H,A
        JR MOUSDVB
MOUSDVA ADD A,A
        ADD A,H
        JR C,MOUSDVB
        CP MAXY
        JP NC,MOUSDVB
        LD H,A
MOUSDVB
        LD (MOUSK+1),HL
        LD B,#FA
        IN A,(C)
        CPL
        AND 3
        RET Z
        LD A,#FF
        LD (MFIRE),A
        RET
MOUSDV
        XOR A
        LD (MFIRE),A
        CALL MOUSEO
        CALL MOUSAY
        CALL MOUSKEM
        CALL JOYSKEM
        CALL JOYSSIN
        LD A,#7F
        IN A,(#FE)
        BIT 2,A
        JR NZ,MOKSDV1
        LD A,#FF
        LD (MFIRE),A
MOKSDV1
        LD A,#DF
        IN A,(#FE)
        LD E,A
        LD HL,MOUSK+1
        LD A,(HL)
        BIT 1,E
        JR NZ,MOKSDV2
        SUB 2
        JR NZ,MOKSDV2
        ADD A,2
MOKSDV2
        BIT 0,E
        JR NZ,MOKSDV3
        ADD A,2
        JR NZ,MOKSDV3
        SUB 2
MOKSDV3
        LD (HL),A
        INC HL
        LD A,#FB
        IN A,(#FE)
        BIT 0,A
        LD A,(HL)
        JR NZ,MOKSDV4
        SUB 2
        JR NZ,MOKSDV4
        ADD A,2
MOKSDV4
        PUSH AF
        LD A,#FD
        IN A,(#FE)
        LD E,A
        POP AF
        BIT 0,E
        JR NZ,MOKSDV5
        ADD A,2
        CP MAXY
        JR C,MOKSDV5
        SUB 2
MOKSDV5 LD (HL),A
        RET

JOYSSIN
        LD A,#EF
        IN A,(#FE)
        LD E,A
        BIT 0,E
        JR NZ,MOUSDV1
        LD A,#FF
        LD (MFIRE),A
MOUSDV1
        LD HL,MOUSK+1
        LD A,(HL)
        BIT 4,E
        JR NZ,MOUSDV2
        SUB 2
        JR NZ,MOUSDV2
        ADD A,2
MOUSDV2
        BIT 3,E
        JR NZ,MOUSDV3
        ADD A,2
        JR NZ,MOUSDV3
        SUB 2
MOUSDV3
        LD (HL),A
        INC HL
        LD A,(HL)
        BIT 1,E
        JR NZ,MOUSDV4
        SUB 2
        JR NZ,MOUSDV4
        ADD A,2
MOUSDV4
        BIT 2,E
        JR NZ,MOUSDV5
        ADD A,2
        CP MAXY
        JR C,MOUSDV5
        SUB 2
MOUSDV5 LD (HL),A
        RET
JOYSKEM
        XOR A
        IN A,(#1F)
        LD E,A
        BIT 4,E
        JR Z,MKUSDV1
        LD A,#FF
        LD (MFIRE),A
MKUSDV1
        LD HL,MOUSK+1
        LD A,(HL)
        BIT 3,E
        JR Z,MKUSDV2
        SUB 2
        JR NZ,MKUSDV2
        ADD A,2
MKUSDV2
        BIT 2,E
        JR Z,MKUSDV3
        ADD A,2
        JR NZ,MKUSDV3
        SUB 2
MKUSDV3
        LD (HL),A
        INC HL
        LD A,(HL)
        BIT 1,E
        JR Z,MKUSDV4
        SUB 2
        JR NZ,MKUSDV4
        ADD A,2
MKUSDV4
        BIT 0,E
        JR Z,MKUSDV5
        ADD A,2
        CP MAXY
        JR C,MKUSDV5
        SUB 2
MKUSDV5 LD (HL),A
        RET
MFIRE   DEFB 0
MAXY    EQU 190
MOUSPRN
        PUSH IY
        EXX
ADRBUF1
        LD DE,MOBUF1
        LD BC,#2000
        EXX
MOUSK   LD DE,#9686
        LD A,192
        SUB D
        CP #10
        JP NC,MOUSKN
        LD (MOUSPR7+1),A
MOUSKN
        LD H,#6F
        LD L,D
        LD A,E
        LD E,(HL)
        INC H
        LD D,(HL)
        LD C,A
        AND #FF-7
        RRCA
        RRCA
        RRCA
        OR E
        LD E,A
        LD A,C
        AND 7
        LD B,A
        LD (MOUSCLS+1),DE
        PUSH DE
        POP IX
        LD A,E
        AND #1F
        CP #1F
        CALL Z,MOUSE91
        CP #1E
        CALL Z,MOUSE9
ADRMOUS
        LD IY,MOUSE
MOUSPR7
        LD A,16
        LD (MOSCLS2+1),A
        LD C,A
MOUSPR2
        PUSH BC
        EXX
        PUSH IX
        POP HL
        LDI
        LDI
        LDI
        EXX
        LD E,(IY+0)
        LD D,(IY+1)
        LD A,(IY+2)
        LD L,(IY+3)
        LD H,#FF
        LD C,0
        INC B
        JP MOUSP18
MOUSPR1
        OR A
        RR E
        RR D
        RR C
        RRA
        RR L
        RR H
        OR #80
MOUSP18
        DJNZ MOUSPR1
MOUSPR8
        AND (IX)
        OR E
        LD (IX),A
        JR MOUSPR5
MOUSPR5
        LD A,L
        AND (IX+1)
        OR D
        LD (IX+1),A
        JR MOUSPR4
MOUSPR4
        LD A,H
        AND (IX+2)
        OR C
        LD (IX+2),A
MOUSPR6
        LD BC,4
        ADD IY,BC
        DEFB #DD
        INC H
        DEFB #DD
        LD A,H
        AND 7
        JP NZ,MOUSPR3
        DEFB #DD
        LD A,L
        ADD A,#20
        DEFB #DD
        LD L,A
        JP C,MOUSPR3
        DEFB #DD
        LD A,H
        SUB 8
        DEFB #DD
        LD H,A
MOUSPR3
        POP BC
        DEC C
        JP NZ,MOUSPR2
        XOR A
        LD (MOUSPR4-1),A
        LD (MOUSPR5-1),A
        LD A,#10
        LD (MOUSPR7+1),A
        POP IY
        RET
MOUSE9
        LD A,MOUSPR6-MOUSPR4
        LD (MOUSPR4-1),A
        XOR A
        RET
MOUSE91
        LD A,MOUSPR6-MOUSPR5
        LD (MOUSPR5-1),A
        XOR A
        RET
PRVOL   DEFB 0
PRMIN   LD A,(PRVOL)
        OR A
        RET Z
        DEC A
        LD (PRVOL),A
        LD HL,(DELTAC+1)
        LD DE,10
        OR A
        SBC HL,DE
        LD (DELTAC+1),HL
PRNVOL  LD A,#FF
        LD (CALCTAB+1),A
        LD A,#80
        LD (METKA8),A
        LD HL,SVOLUM
        LD DE,#471D
        LD A,35
        ADD A,D
        LD D,A
        PUSH DE
        CALL PRINMES
        LD A,(PRVOL)
        LD C,A
        LD B,0
        LD HL,100
        ADD HL,BC
        LD C,L
        LD B,H
        LD HL,SVOLUM+1
        CALL PRCHIS
        POP DE
        LD HL,SVOLUM
        CALL PRINMES
        XOR A
        LD (METKA8),A
        RET

PRPL    LD A,(PRVOL)
        CP 200
        RET Z
        INC A
        LD (PRVOL),A
        LD HL,(DELTAC+1)
        LD DE,10
        ADD HL,DE
        LD (DELTAC+1),HL
        JP PRNVOL
PRFF
        LD A,(PRPLAY+1)
        OR A
        RET Z
        LD A,(NEWPAT5+1)
        LD C,A
        LD A,(NEWPAT4+1)
        CP C
        RET Z
        JP PRRW1
PRRW
        LD A,(PRPLAY+1)
        OR A
        RET Z
        LD A,(TLINE)
        CP 64
        JP NZ,PRRW2
        LD A,(NEWPAT4+1)
        CP 1
        RET Z
        DEC A
        DEC A
        LD (NEWPAT4+1),A
        JP PRRW1
PRRW2
        LD A,(NEWPAT4+1)
        DEC A
        LD (NEWPAT4+1),A

PRRW1
        CALL MOUSPRN
        CALL NEWPAT
        LD (TLINE),A
        INC A
        LD (TEKPAT+1),A
        LD A,#80
        LD (METKA8),A
        CALL SVOSPR
        EI
        HALT
        DI
        LD HL,#4E16
        LD C,21
        CALL SCLEAR4
        LD HL,SPOSIT
        LD DE,#471D
        CALL PRINMES
        LD HL,SPATERN
        LD DE,#4E1D
        CALL PRINMES
        LD HL,SLINE
        LD DE,#551D
        CALL PRINMES
        EI
        HALT
        DI
        CALL MOUSCLS
        XOR A
        LD (METKA8),A
        RET
PRPLAY  LD A,0
        OR A
        RET Z
        CALL CALCTAB
        CALL CONTPLA
        CALL SVOSPR
        CALL SPRINT
        RET
TCOORD
        DEFW #8486,#9296,PRMIN   ;-
        DEFW #84EA,#92F8,PRPL   ;+
        DEFW #9A86,#BA9A,PRLOAD ;LOAD
        DEFW #9A9E,#BAAA,PRFF   ;FF
        DEFW #AAA6,#BABA,PRFF   ;FF
        DEFW #9AB2,#ACE2,PRPLAY ;PLAY
        DEFW #A2BE,#B8D6,PRPLAY ;PLAY
        DEFW #A0E8,#BAFA,PRRW   ;RW
        DEFW #AADE,#BAF8,PRRW   ;RW
        DEFW #FFFF,#FFFF,#FFFF

PEREG
        CALL CHSTR10
        LD A,(BUFCAT+#18)
        LD (PEREG10+1),A
        LD (PEREG11+1),A
        LD A,(BUFCAT+#D)
        LD (PEREG12+1),A
        LD (PEREG14+1),A
        LD A,(LRMEN+1)
        LD HL,BUFCAT2
        ADD A,A
        LD E,A
        LD D,0
        ADD HL,DE
        LD A,(HL)
        INC HL
        LD H,(HL)
        LD L,A
        LD A,H
        OR A
        RET Z
        PUSH HL
        LD BC,#12+11
        ADD HL,BC
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD A,(HL)
        RRA
        RR B
        RR C
        RRA
        RR B
        RR C
        LD (LENFIL+1),BC
        POP HL
        PUSH HL
        LD DE,11
        ADD HL,DE
        LD A,(HL)
        AND #10
        LD (PODK+1),A
        POP HL
        LD DE,26
        ADD HL,DE
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD A,B
        OR C
        JP Z,PRLOAD
        LD IX,TABLS
PEREG3  PUSH BC
        DEC BC
        DEC BC
PEREG12 LD A,0
        CP 1
        JR Z,PEREG13
        OR A
        RL C
        RL B
PEREG13 LD A,(SIZECAT)
        ADD A,C
        LD C,A
        ADC A,B
        SUB C
        LD B,A
        CALL PEREG6
        LD (IX),C
        INC IX
        LD (IX),B
        INC IX
PEREG14 LD A,0
        CP 1
        JR Z,PEREG15
        INC C
        LD A,C
PEREG10 CP #9
        JR NZ,PEREG9
        LD C,0
        INC B
PEREG9
        LD (IX),C
        INC IX
        LD (IX),B
        INC IX
PEREG15 POP BC
        LD H,B
        LD L,C
        OR A
        RR H
        RR L
        ADD HL,BC
        LD DE,BUFCAT+#200
        ADD HL,DE
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD A,C
        AND 1
        JR  Z,PEREG1
        LD B,4
PEREG2  OR A
        RR D
        RR E
        DJNZ PEREG2
PEREG1  LD A,D
        AND #0F
        LD D,A
        LD B,D
        LD C,E
        LD A,D
        CP #0F
        JR NZ,PEREG3
        LD (IX),#FF
        INC IX
        LD (IX),#FF
PODK    LD A,0
        OR A
        JP NZ,RPODK
        LD HL,#C000
        LD A,2
        CALL LOAD
        CALL CHSTR10
        CALL PLMUSIC
        CALL CHSTR10
        CALL SCLEAR
        LD A,#FF
        LD (METKA8),A
        LD DE,#0000
        LD HL,#C000
        LD B,20
        CALL PRINMES
        LD HL,#C014
        LD DE,#0100
PRTMES1
        PUSH HL
        PUSH DE
        LD B,21
        CALL PRINMES
        POP DE
        POP HL
        LD BC,30
        ADD HL,BC
        INC D
        LD A,D
        CP 32
        JP NZ,PRTMES1
        LD HL,SLENGHT
        LD DE,SLENGHT+1
        LD (HL),#20
        LD BC,#4
        LDIR
        LD HL,SLENGHT+1
LENFIL  LD BC,0
        CALL PRCHIS
        LD A,"K"
        LD (HL),A
        CALL SVOSPR
        CALL SPRINT
        LD A,#FF
        LD (PRPLAY+1),A
        RET
SVOSPR
        LD HL,SBEGIN2
        LD BC,SBEGIN3-SBEGIN2
        LD DE,SPOSIT
        LDIR
        LD HL,SPOSIT+1
        LD A,(NEWPAT4+1)
        DEC A
        LD C,A
        LD B,0
        CALL PRCHIS
        LD (HL),"("
        INC HL
        LD A,(NEWPAT5+1)
        DEC A
        LD C,A
        LD B,0
        CALL PRCHIS
        LD (HL),")"
        LD HL,SPATERN+1
        LD A,(STEKPAT)
        LD C,A
        LD B,0
        CALL PRCHIS
        LD (HL),"("
        INC HL
        LD A,(SMAXPAT)
        DEC A
        LD C,A
        LD B,0
        CALL PRCHIS
        LD (HL),")"
        LD HL,SLINE+1
        LD A,(TLINE)
        LD C,A
        LD A,64
        SUB C
        LD C,A
        LD B,0
        CALL PRCHIS
        LD HL,STEMP+1
        LD A,(PLAYSPD+1)
        LD C,A
        LD B,0
        CALL PRCHIS
        LD HL,SSPEED+1
        LD A,(SPEED)
        LD C,A
        LD B,0
        CALL PRCHIS
        RET
RPODK
        LD HL,#C000
        LD A,2
        CALL LOAD
        CALL LOAC3
        CALL SCLEAR
        CALL PRINTK
        LD A,D
        DEC A
        LD (LMENU2+1),A
        RET
PEREG6
        LD L,C
        LD H,B
        LD B,0
PEREG11 LD DE,9
PEREG7  OR A
        SBC HL,DE
        JR C,PEREG8
        INC B
        JP PEREG7
PEREG8  ADD HL,DE
        LD C,L
        RET
SCLEAR  LD HL,#4100
        LD DE,#4102
        DEFB #DD
        LD L,191
SCLEAR1
        PUSH HL
        PUSH DE
        LD (HL),#80
        INC HL
        LD (HL),0
        LD BC,14
        LDIR
        POP DE
        POP HL
        CALL NEXTLNH
        CALL NEXTLND
        DEFB #DD
        DEC L
        JP NZ,SCLEAR1
        RET
;----------LOAD---------;
PRLOAD
        CALL MOUSPRN
LOADC
        XOR A
        LD (PRPLAY+1),A
        CALL LCAT
        CALL LOAC3
        CALL SCLEAR
        LD A,(BUFCAT+#10E7)
        CP #10
        JP NZ,LOADC6
        LD DE,#0402
        CALL PRINTS
        DEFB "TR DOS  DISK",#FF
        LD D,1
        JR LOADC5+2
LOADC6
        LD A,(KOLF+1)
        OR A
        JR NZ,LOADC5
        LD DE,#0402
        CALL PRINTS
        DEFB "NO FILES",#FF
        LD D,1
        JR LOADC5+2
LOADC5  CALL PRINTK
        ;RETURN D-KOL ELEM
        LD A,D
        DEC A
        LD (LMENU2+1),A
        CALL MOUSCLS
        XOR A
        LD (SLENGHT),A
        LD (SPOSIT),A
        LD (SPATERN),A
        LD (SLINE),A
        LD HL,SBEGIN1
        LD BC,SBEGIN2-SBEGIN1
        LD DE,SSPEED
        LDIR
        CALL SPRINT
        RET
LOAC3
        LD A,(BUFCAT+22)
        LD B,A
        LD HL,0
        LD DE,(BUFCAT+11)
LOAC3N
        ADD HL,DE
        DJNZ LOAC3N
        ADD HL,HL
        LD DE,#200
        ADD HL,DE
        LD A,H
        LD (SIZECAT),A
        LD A,(BUFCAT+24)
        CP #0A
        JP NZ,LOAC3N1
        LD A,(BUFCAT+13)
        CP #01
        JP NZ,LOAC3N1
        OR A
        SBC HL,DE
LOAC3N1
        LD C,L
        LD B,H
        XOR A
        LD (KOLF+1),A
        LD HL,BUFCAT
        ADD HL,BC
        PUSH HL
        POP IX
        LD HL,BUFCAT2
        LD (RPODK+1),IX
LOADC2  LD A,(IX)
        OR A
        RET Z
        CP #E5
        JR Z,LOADC1
        CP #2E
        JP NZ,LOADC2N
        LD A,(IX+1)
        CP #2E
        JP NZ,LOADC1
LOADC2N
        LD A,(IX+#0B)
        AND 8
        JP NZ,LOADC1
        PUSH IX
        POP DE
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        LD (HL),0
        INC HL
        LD (HL),0
        DEC HL
        LD A,(KOLF+1)
        INC A
        LD (KOLF+1),A
LOADC1  LD DE,32
        ADD IX,DE
        JP LOADC2
LCAT    LD HL,TABLS
        LD DE,0
        LD A,14
        LD B,A
LCAT1
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        INC DE
        LD A,E
        CP #9
        JR C,LCAT2
        LD E,0
        INC D
LCAT2   DJNZ LCAT1
        LD (HL),#FF
        INC HL
        LD (HL),#FF
        LD HL,BUFCAT
        LD A,2
        CALL LOAD
        RET
        DEFW 0,0,0,0
;--------IBM.LOAD--------;
LOAD
        PUSH BC
        LD IX,TABLS
        LD A,1
        LD (NEEXT2+1),A
        CALL CHSTR10
        POP BC
        LD A,#FF
        LD (LSEC1N+1),A
        CALL NEXXT
        LD BC,#20
        ADD HL,BC
        LD BC,(NEEXT2+1)
        DEC BC
        LD (LENDSTR),BC
        LD (LENDADR),HL
        CALL CHSTR10
        RET
LRET    DEFB 0
NLRET   XOR A
        LD (LRET),A
        RET
NLRET1  LD A,#FF
        LD (LRET),A
        RET
NEXXT
        LD E,(IX)
        INC IX
        LD D,(IX)
        INC IX
        LD A,D
        CP #FF
        JP Z,NLRET
        PUSH IX
        CALL LSEC1
        POP IX
        LD DE,512
        ADD HL,DE
        LD A,H
        CP #FE
        JR C,NEXXT
        LD (LIBM11+1),HL
        LD HL,PAT
        LD E,(IX)
        INC IX
        LD D,(IX)
        INC IX
        LD A,D
        CP #FF
        RET Z
        PUSH IX
        CALL LSEC1
        POP IX
        LD BC,#200
LIBM11
        LD DE,0
        LDIR
        LD HL,#FFF0
        LD BC,#10
        LD DE,PAT+#200
        LDIR
NEEXT2  LD BC,#6100
        LD A,(BC)
        INC BC
        CP #FF
        JP Z,NLRET1
        LD (NEEXT2+1),BC
        DEC BC
        CALL CHSTRN1
        LD HL,PAT+#200
        LD BC,#10
        LD DE,#C000
        LDIR
        LD BC,(LIBM11+1)
        LD A,B
        AND 1
        LD B,A
        LD HL,PAT+#200
        OR A
        SBC HL,BC
        LD A,B
        OR C
        JP Z,LIBM12
        LDIR
LIBM12
        EX DE,HL
        JP NEXXT

;------LOADSEC----;
LSEC1
        DI
        LD A,2
        LD (LADR1+1),A
LSEC1N
        LD A,0
        CP D
        JR Z,LSEC2
NEWLOAD
        PUSH DE
        LD A,D
        OR A
        RRA
        LD D,A
        LD A,#3C
        JR NC,SIDEI
        LD A,#2C
SIDEI
        LD C,#FF
        CALL DOSC
        LD A,D
        LD C,#7F
        CALL DOS
        LD A,#18
        LD C,#1F
        CALL DOS
        LD IX,#20B1
LSEC3
        LD B,1
        LD C,#7F
        CALL DOS
        AND #80
        JR Z,LSEC3
        POP DE
LSEC2
        LD A,D
        LD (LSEC1N+1),A
        LD (LSEC4+1),DE
        LD (LSEC5+1),HL
LERROR
        LD A,E
        INC A
        LD C,#5F
        CALL DOSC
        LD A,#80
        LD C,#1F
        CALL DOS
        CALL RELOAD
        JR Z,LSEC4
        BIT 4,A
        JR NZ,LADR1
        JR LERROR
LSEC4   LD DE,0
LSEC5   LD HL,0
        RET
LADR1
        LD A,3
        DEC A
        LD (LADR1+1),A
        JR NZ,LERROR
        LD A,3
        LD (LADR1+1),A
LADR1N  LD HL,(LSEC5+1)
        LD A,#C0
        LD C,#1F
        CALL DOSC
        CALL RELOAD
        JR NZ,LADR1N
        LD HL,(LSEC5+1)
        LD A,(HL)
        LD (LSEC1N+1),A
        CALL DOSCE
        LD DE,(LSEC4+1)
        JP LSEC1N
LADR1J  POP HL
        JR LADR1N
RELOAD
        LD C,#7F
        LD DE,#FFFF
        LD B,3
        LD IX,#3FD7
        CALL DOS
        LD A,D
        OR E
        OR B
        JR Z,LADR1J
        XOR A
        CALL DOSCE
        LD A,#0A
        LD C,#5F
        CALL DOS
        LD D,1
        LD IX,16179
        CALL DOS
        PUSH BC
        LD A,(LSEC1N+1)
        OR A
        RRA
        CALL DOSCE
        POP AF
        AND #7F
        RET
DOSCE   LD C,#3F
DOSC    LD IX,#2A53
DOS     PUSH IX
        JP #3D2F

PRINMES
PRTMES2
        LD A,(HL)
        OR A
        RET Z
        PUSH BC
        CALL PRINTB
        POP BC
        INC E
        INC HL
        DJNZ PRTMES2
        RET
PRINTDL DEFW 0
PRLEN
        LD B,2
        XOR A
        LD (PRLEN2+1),A
PRLEN1
        PUSH BC
        LD A,(HL)
        AND #F0
        RLCA
        RLCA
        RLCA
        RLCA
        CALL PRLEN5
        LD A,(HL)
        AND #0F
        CALL PRLEN5
        INC HL
        POP BC
        DJNZ PRLEN1
        LD A,(PRLEN2+1)
        OR A
        RET NZ
        LD A,"0"
        LD (DE),A
        INC DE
        RET
PRLEN5
        LD BC,NEXTABL
        ADD A,C
        LD C,A
        ADC A,B
        SUB C
        LD B,A
PRLEN2
        LD A,0
        OR A
        LD A,(BC)
        JP NZ,PRLEN3
        CP "0"
        RET Z
PRLEN3
        LD (DE),A
        LD (PRLEN2+1),A
        INC DE
        RET
        LD A,(HL)
NEXTABL
        DEFB "0","1","2","3","4","5","6","7","8","9","A"
        DEFB "B","C","D","E","F"
PECHATS
        LD DE,#1003
PRINTM1 LD A,(HL)
        CP #FF
        JP Z,PECHS1
        CALL PRINTB
        INC HL
        INC E
        LD A,E
        AND #1F
        LD E,A
        JR PRINTM1
PECHS1  INC HL
        EX (SP),HL
        RET
PRINTK
        XOR A
        LD (METKA8),A
PRINTKP LD HL,BUFCAT2
PRINTKO LD DE,#0100
PRINTK2 LD C,(HL)
        INC HL
        LD A,(HL)
        OR A
        RET Z
        INC HL
        LD B,A
        LD A,D
        CP 23
        RET Z
        LD E,2
        PUSH HL
        LD H,B
        LD L,C
        LD B,8
PRINTK1 LD A,(HL)
        CALL PRINTB
        INC HL
        INC E
        DJNZ PRINTK1
        LD A,#2E
        CALL PRINTB
        INC E
        LD B,3
PRINTK5 LD A,(HL)
        CALL PRINTB
        INC HL
        INC E
        DJNZ PRINTK5
        LD A,(HL)
        CP #10
        JR Z,PRINTK3
        INC E
        LD BC,#12
        ADD HL,BC
        LD C,(HL)
        INC HL
        LD B,(HL)
        INC HL
        LD A,(HL)
        RRA
        RR B
        RR C
        RRA
        RR B
        RR C
        PUSH DE
        LD HL,PRINTK6
        PUSH HL
        LD (HL),#20
        INC HL
        LD (HL),#20
        INC HL
        LD (HL),#20
        POP HL
        CALL PRCHIS
        LD A,#FF
        LD (PRINTK6+3),A
        POP DE
        CALL PRINTS
PRINTK6 DEFB "   ",#FF
        POP HL
        INC D
        JP PRINTK2
PRCHIS
        PUSH HL
        CALL NXDEC16
        LD A,H
        LD H,L
        LD L,A
        LD (PRINTDL),HL
        POP DE
        LD HL,PRINTDL
        CALL PRLEN
        EX DE,HL
        RET
PRINTK3
        LD B,4
PRINTK4 LD A,#20
        DEC E
        CALL PRINTB
        DJNZ PRINTK4
        POP HL
        INC D
        JP PRINTK2
NXDEC16
        ;BC-NEX
        ;AHL-DEC
        XOR A
        LD H,A
        LD L,A
        LD D,B
        LD E,C
        LD C,A
        LD B,16
NDEC161
        EX DE,HL
        ADD HL,HL
        EX DE,HL
        LD A,L
        ADC A,L
        DAA
        LD L,A
        LD A,H
        ADC A,H
        DAA
        LD H,A
        LD A,C
        ADC A,C
        DAA
        LD C,A
        DJNZ NDEC161
        LD A,C
        RET
PRINTS  POP HL
PRINTS1 LD A,(HL)
        INC HL
        CP #FF
        JR Z,PRINEND
        PUSH HL
        PUSH DE
        CALL PRINTB
        POP DE
        POP HL
        INC E
        JP PRINTS1
PRINEND PUSH HL
        RET
PRINNB2 LD A,D
        ADD A,A
        ADD A,A
        ADD A,A
        ADD A,2
        JP PRINNB3
PRINTB
        PUSH HL
        PUSH DE
        PUSH BC
        PUSH IX
        SUB #20
        CP #60
        JP C,PRINNB4
        XOR A
PRINNB4
        CP #5B
        JP C,PRINNB6
        SUB #1B
        JP PRINNB5
PRINNB6
        CP #41
        JP C,PRINNB5
        SUB #20
PRINNB5
        LD L,A
        LD H,0
        PUSH HL
        POP BC
        ADD HL,HL
        ADD HL,HL
        ADD HL,BC
        LD BC,FONT
        ADD HL,BC
        PUSH HL
        LD A,(METKA8)
        LD A,E
        ADD A,A
        LD E,A
        ADD A,A
        ADD A,E
        ADD A,2
        LD L,A
        AND 7
        LD B,A
        LD A,L
        RRCA
        RRCA
        RRCA
        AND #1F
        LD E,A
        LD A,(METKA8)
        OR A
        JP Z,PRINNB2
        CP #80
        LD A,D
        JP Z,PRINNB3+1
        ADD A,A
        LD D,A
        ADD A,A
        ADD A,D
PRINNB3
        INC A
        LD HL,PRTABL1
        ADD A,L
        LD L,A
        ADC A,H
        SUB L
        LD H,A
        LD A,(HL)
        INC H
        LD D,(HL)
        OR E
        LD E,A
        POP HL
        LD A,B
        OR A
        JP Z,PRINT7
PRINT2
        AND 4
        JP NZ,PRINT1
        DEFB #DD
        LD L,5
        EX DE,HL
        LD C,0
PRINT3  LD A,(DE)
        OR A
        PUSH BC
PRINT4  RRA
        RR C
        DJNZ PRINT4
        XOR (HL)
        LD (HL),A
        INC L
        LD A,C
        XOR (HL)
        LD (HL),A
        POP BC
        DEC L
        INC DE
        CALL NEXTLNH
        DEFB #DD
        DEC L
        JR NZ,PRINT3
PRINTBE
        POP  IX
        POP  BC
        POP  DE
        POP  HL
        RET
PRINT1
        LD A,B
        SUB 8
        NEG
        LD B,A
        DEFB #DD
        LD L,5
        EX DE,HL
        INC L
        LD C,0
PRINT5  LD A,(DE)
        OR A
        PUSH BC
PRINT6  RLA
        RL C
        DJNZ PRINT6
        XOR (HL)
        LD (HL),A
        DEC L
        LD A,C
        XOR (HL)
        LD (HL),A
        POP BC
        INC L
        INC DE
        CALL NEXTLNH
        DEFB #DD
        DEC L
        JR NZ,PRINT5
        JP PRINTBE
PRINT7
        LD B,5
        EX DE,HL
PRINT8  LD A,(DE)
        XOR (HL)
        LD (HL),A
        CALL NEXTLNH
        INC DE
        DJNZ PRINT8
        JP PRINTBE
TABLD1  DEFB #80,#40,#20,#10,#8,4,2,1
TABLD2  DEFB #FF,#7F,#3F,#1F,#0F,#7,3,1
TABLD3  DEFB #80,#C0,#E0,#F0,#F8,#FC,#FE,#FF
COORD
        LD HL,PRTABL1
        LD L,D
        LD C,(HL)
        INC H
        LD B,(HL)
        LD A,E
        AND #F8
        RRCA
        RRCA
        RRCA
        ADD A,C
        LD C,A
        LD HL,TABLD1
        LD A,E
        AND 7
        ADD A,L
        LD L,A
        ADC A,H
        SUB L
        LD H,A
        LD A,(HL)
        LD L,C
        LD H,B
        RET
SPRINT  CALL SCLEAR2
        LD A,#80
        LD (METKA8),A
        LD DE,#471D
        LD IX,SWTAB
SPRINT1
        LD L,(IX)
        INC IX
        LD A,(IX)
        INC IX
        CP #FF
        JP Z,SPRINT2
        LD H,A
        PUSH DE
        CALL PRINMES
        POP DE
        LD A,D
        ADD A,7
        LD D,A
        JP SPRINT1
SPRINT2
        XOR A
        LD (METKA8),A
        RET
SWTAB   DEFW SPOSIT,SPATERN,SLINE,SSPEED,STEMP,SVOLUM,SLENGHT
        DEFW #FFFF
SPOSIT  DEFB 0,"125(125)",0
SPATERN DEFB 0,"125(125)",0
SLINE   DEFB 0,"12 ",0
SSPEED  DEFB " 125",0
STEMP   DEFB " 6 ",0
SVOLUM  DEFB " 100%",0
SLENGHT DEFB 0,"156K",0
SBEGIN1 DEFB " 125",0
        DEFB " 6 ",0
SBEGIN2
        DEFB "         ",0
        DEFB "         ",0
        DEFB "    ",0
        DEFB "    ",0
        DEFB "   ",0
SBEGIN3
SCLEAR2 LD HL,#4E16
        LD C,49
SCLEAR4
        PUSH óÿÿ> Óþ>? Ã‚=íGÃ Ã'   Ãr/ÉbkÃ##6+¼ úÿÿÿÿÿûÉ·íR#05(5(ó+"´\¯>¨ {ë1 `" _!y å!/=å!í¸ÃV*"_õ>É2_ñ* _Ã_ë#"{\+@íC8\"²\! <"6\*²\6>+ù++"=\ÕíVý!:\!¶\"O\¯ ëÍë+"W\#"S\"K\6€#"Y\6#6€#"a\"c\"e\>82\2\2H\!#"	\ý5Æý5Ê!Æ\ ÍýËÎ!Â\6Éçß!k\6!‹å>ª2 [ûÃ1=" _!/=å!í°"_* _Ã_Íå Í—*Y\#^#Vz³ë(¯2]åÍ2á"B\¯2D\ç°*S\+"W\í{=\:]·!v(ç°å!Â\åÉÍñ ÍJ)>ÿ2]¯2÷\>ª2]!"]!  9"]++ùÍ*²\í[]\íRë0·íR"]\ÍÇÊÓþê# õÍÇ(óþ:ÂÓ#ÍH0*]Ã
~þÈþ€È·ÉÍC!  "ø\Íå Íc!]6ª!]~·6  ÍÍí{]*]íK] éÍ2ýË ~ÀÂ\í{=\ÕÉÍŒþÈÍ*õÍ"]*]++"=\=s#rÉ*]Í É!  "÷\9"]++ùÍ!]~þª> 2]ÊË6ªÍ—Íˆ!`ß   :¶\þô(! ß: [þª SÍñ *Y\>þ2]6÷#6"#6b#6o#6o#6t#6"#"[\6#6€#"a\"c\"e\ýËÞ?~#úÉ Åî