        ORG     #8000
;
        DI
        CALL    CLSCR
        LD      HL,0
        LD      (TMPX),HL
        CALL    KOOR_Y
        CALL    PRI_T
        DEFB    "Comparer Flash Info V1.0  "
        DEFB    "Copyright By (R)soft 1999",13
        DEFB    "Loading File: ",0
        LD      B,8
        LD      HL,NAMFILE
        CALL    PRI_B
        LD      A," "
        CALL    PRIA
        LD      A,"<"
        CALL    PRIA
        LD      A,(NAMFILE+8)
        CALL    PRIA
        LD      A,">"
        CALL    PRIA
        LD      HL,NAMFILE
        LD      DE,#5CDD
        LD      BC,9
        LDIR
        XOR     A
        LD      (23801),A
        LD      (23824),A
        DEC     A
        LD      HL,#C000
        LD      DE,#4000
        LD      C,#0E
;       CALL    #3D13
        LD      A,(#5D0F)
        AND     A
        JR      Z,CONTCOM
        CALL    PRI_T
        DEFB    13,"Disk Error!",0
        EI
        RET
CONTCOM
        CALL    PRI_T
        DEFB    "      Loading Complete.",0
        LD      HL,#9000+#1080
        LD      DE,#0000        ;Koord
        LD      B,0             ;How Many Print
        CALL    COMPRINT
        LD      HL,#A8C7+#4000
        LD      IX,#9000+#1080
        LD      DE,#0800
        LD      B,0
        CALL    COMPARER
        LD      HL,#AA25+#4000
        LD      IX,#9000+#1080
        LD      DE,#1000        ;Koord
        LD      B,#63           ;How Many Print
        CALL    COMPARER
        EI
LOOPKEY
        HALT
        LD      A,1
        OUT     (#FE),A
        LD      HL,0
        LD      DE,0
        LD      BC,1499
        LDIR
        XOR     A
        OUT     (#FE),A
        LD      BC,673
        LDIR
        LD      A,1
        OUT     (#FE),A
        LD      A,#BF
        IN      A,(#FE)
        RRCA
        JR      C,LOOPKEY
        RET
NAMFILE DEFB    "PAGE2.3 C"
;------------------------------

COMPARER
        LD      (TMPX),DE
        EX      DE,HL
        CALL    KOOR_Y
LOOPC
        PUSH    BC
        PUSH    HL
        LD      A,(HL)
        CP      (IX)
        LD      A,0
        JR      Z,NOINV
        DEC     A
NOINV
        LD      (INVERSE),A
        LD      A,(HL)
        CALL    PRIHB
        LD      A,#3F
        LD      HL,TMPX
        AND     (HL)
        LD      (HL),A
        JR      NZ,LOOPC1
        LD      (HL),0
        INC     HL
        INC     (HL)
        CALL    KOOR_Y
LOOPC1
        POP     HL
        INC     HL
        INC     IX
        POP     BC
        DJNZ    LOOPC
        XOR     A
        LD      (INVERSE),A
        RET
COMPRINT
        LD      (TMPX),DE
        EX      DE,HL
        CALL    KOOR_Y
LOOPCOMP
        PUSH    BC
        PUSH    HL
        LD      A,(HL)
        CALL    PRIHB
        LD      A,#3F
        LD      HL,TMPX
        AND     (HL)
        LD      (HL),A
        JR      NZ,LOOPCOM1
        LD      (HL),0
        INC     HL
        INC     (HL)
        CALL    KOOR_Y
LOOPCOM1
        POP     HL
        INC     HL
        POP     BC
        DJNZ    LOOPCOMP
        RET
CLSCR
        LD      HL,#4000
        LD      E,L
        LD      D,H
        INC     DE
        LD      (HL),L
        LD      BC,#17FF
        LDIR
        INC     HL
        INC     DE
        LD      (HL),#17+(8*2)
        INC     HL
        INC     DE
        LD      (HL),7+(8*2)
        DEC     HL
        DEC     C
        DEC     C
        LDIR
        INC     HL
        INC     HL
        INC     DE
        INC     DE
        LD      (HL),#14+#40
        INC     HL
        LD      (HL),4+#40
        DEC     HL
        DEC     C
        DEC     C
        LDIR
        INC     HL
        INC     HL
        INC     DE
        INC     DE
        LD      (HL),#17+(8*2)
        INC     HL
        LD      (HL),7+(8*2)
        DEC     HL
        DEC     C
        DEC     C
        LDIR
        RET
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
DEC99   LD      C,A             ;Decimal 0-99
        LD      B,0             ;A - Byte
DEC9999 LD      HL,FPRIA        ;DE - Koord
        LD      (#5C51),HL
        LD      (TMPX),DE
        CALL    KOOR_Y
        JP      #1A1B
FPRIA   DEFW    PRIA
;
DECIMA2 PUSH    AF              ;Decimal 0-255
        LD      (TMPX),DE       ;A - Byte
        CALL    KOOR_Y          ;DE - Koord
        POP     AF
        LD      L,A
        LD      H,0
        JR      DECIMA3
;
DECIMAL LD      (TMPX),DE       ;Decimal 0-65535
        EX      DE,HL           ;HL - Word
        CALL    KOOR_Y          ;DE - Koord
        LD      DE,#2710
        CALL    PRIDCM
        LD      DE,#3E8
        CALL    PRIDCM
DECIMA3 LD      DE,#64
        CALL    PRIDCM
        LD      DE,10
        CALL    PRIDCM
        LD      A,L
        ADD     A,#30
        JP      PRIA
PRIDCM  LD      A,#2F
PRIDCM2 ADD     A,1
        SBC     HL,DE
        JR      NC,PRIDCM2
        ADD     HL,DE
        PUSH    HL
        CALL    PRIA
        POP     HL
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
NOCHET
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
;---------------------
TMPX    DEFB    0
TMPY    DEFB    0
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

