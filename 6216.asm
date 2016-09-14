        ORG     #8000
;
;-------------------------------------
;Port A: Data FLASH
;Port B: Set High & Low Byte of FLASH Address
;Port C: 0 - BANK 0-1
;        1 - BANK 2-3
;        2 - /STROB     (Latch Low Byte )
;        3 - /WE        (Write Enable)
;        4 - /CS or /CE (Chip Select)
;        5 - /OE
;        6 -  ---
;        7 -  ---
;Mask #FC
;=====================
PORTA   EQU     #1F
PORTB   EQU     #3F
PORTC   EQU     #5F
PORTSET EQU     #7F
BORDER  EQU     0
BORDER2 EQU     7
;---------------------
        DI
        LD      A,BORDER
        OUT     (#FE),A
        LD      A,#80
        OUT     (PORTSET),A
        XOR     A
        OUT     (PORTA),A
        OUT     (PORTB),A
        DEC     A
        OUT     (PORTC),A
        IN      A,(PORTA)
        AND     A
        JP      NZ,ERREXIT
        LD      C,PORTA
        CALL    TESTP
        JP      C,ERREXIT
        LD      C,PORTB
        CALL    TESTP
        JP      C,ERREXIT
        LD      C,PORTC
        CALL    TESTP
        JP      C,ERREXIT
        LD      A,#FF
        OUT     (PORTA),A
        OUT     (PORTB),A
        OUT     (PORTC),A
;==========
        LD      B,32
        LD      IX,TABLEB
LOOPTST
        PUSH    BC
        LD      HL,#D000
        LD      A,(IX)
        CALL    FILLPAGE
        LD      A,2
        OUT     (#FE),A
        LD      DE,#D000        ;Write From
        CALL    WRITE2K
        XOR     A
        OUT     (#FE),A
        LD      HL,#C000
        CALL    CLSPAGE
        LD      DE,#C000        ;Read To
        CALL    READ2K
        CALL    COMPARE
        POP     BC
        JP      C,ERREXIT
        INC     IX
        DJNZ    LOOPTST
        EI
        RET
ERREXIT
        LD      A,BORDER2
        OUT     (#FE),A
        EI
        RET
;
TABLEB
        DEFB    #00,#FF,#0F,#F0,#AA,#55,#A5,#5A
        DEFB    #01,#02,#04,#08,#10,#20,#40,#80
        DEFB    #0A,#05,#A0,#50,#FA,#F5,#AF,#A5
        DEFB    #00,#FF,#00,#FF,#00,#FF,#00,#FF
;-------------------------
TESTP
        LD      B,0
TESTP0  OUT     (C),B
        IN      A,(C)
        CP      B
        JR      NZ,TESTP1
        DJNZ    TESTP0
        AND     A
        RET
TESTP1
        SCF
        RET
;----- Read 2Kb RAM --------
READ2K
        LD      HL,0
        LD      B,8
READ2KL
        PUSH    BC
        CALL    READ256
        INC     D
        INC     H
        POP     BC
        DJNZ    READ2KL
        RET
;------- Read 256 Bytes -------
READ256
        LD      C,PORTB
        SET     3,H             ;A11=1 -> Read Mode
        OUT     (C),H
        LD      A,#FB
        OUT     (PORTC),A       ;Latch High Byte
        LD      A,#FF
        OUT     (PORTC),A
;
        LD      B,0             ;Read 256 Byte
        LD      C,PORTC
LOOP_256
        LD      A,E
        OUT     (PORTB),A       ;Set Low Addr
        LD      A,#CF
        OUT     (C),A           ;/CS & /OE = 0
        IN      A,(PORTA)       ;Read Byte
        LD      (DE),A
        INC     E
        LD      A,#FF           ;/CS & /OE = 1
        OUT     (C),A
        DJNZ    LOOP_256
        RET
;------- Read 1 Byte ---------
READ1
        LD      C,PORTB         ;Latch Addr
        SET     3,H             ;A11=1 -> Read Mode
        OUT     (C),H
        LD      A,#FB
        OUT     (PORTC),A       ;Latch High Byte
        LD      A,#FF
        OUT     (PORTC),A
        OUT     (C),L           ;Set Low Byte
;
        LD      C,PORTC         ;Read Byte
        LD      A,#CF
        OUT     (C),A
        IN      A,(PORTA)
        LD      B,#FF
        OUT     (C),B
        RET
;------- Write 2Kb RAM -------
WRITE2K
        LD      HL,0            ;ADR WRITE
WRITE2KL
        LD      A,(DE)
        CALL    WRITE1
        INC     DE
        INC     HL
        BIT     3,H
        JR      Z,WRITE2KL
        RET
;----- Write 1 Byte ------
WRITE1
        OUT     (PORTA),A
        RES     3,H             ;A11=0 -> Write Mode
        LD      A,H
        OUT     (PORTB),A
        LD      A,#FB
        OUT     (PORTC),A       ;Latch High Byte
        LD      A,#FF
        OUT     (PORTC),A
        LD      A,L
        OUT     (PORTB),A       ;Set Low Byte
        LD      A,#CF
        OUT     (PORTC),A
        LD      A,#FF
        OUT     (PORTC),A
        RET
FILLPAGE
        LD      E,L
        LD      D,H
        INC     DE
        INC     DE
        LD      (HL),A
        INC     HL
        CPL
        LD      (HL),A
        DEC     HL
        LD      BC,#0FFF
        LDIR
        RET
CLSPAGE
        LD      E,L
        LD      D,H
        INC     DE
        LD      (HL),0
        LD      BC,#0FFF
        LDIR
        RET
COMPARE
        LD      HL,#C000
        LD      DE,#D000
        LD      BC,#0800
COMPARL
        LD      A,(DE)
        CP      (HL)
        JR      NZ,COMPERR
        INC     HL
        INC     DE
        DEC     BC
        LD      A,C
        OR      B
        JR      NZ,COMPARL
        AND     A
        RET
COMPERR
        SCF
        RET

