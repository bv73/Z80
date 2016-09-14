        ORG     #8000
;
MAIN    DI
        XOR     A
        OUT     (#FE),A
        JR      MAIN2
        LD      A,#80
        LD      BC,#3BBF
        OUT     (C),A
        LD      A,(SPEED)
        ADD     A,A
        LD      E,A
        LD      D,0
        LD      HL,TABSPEED
        ADD     HL,DE
        LD      B,#38
        LD      A,(HL)
        OUT     (C),A
        INC     B
        INC     HL
        LD      A,(HL)
        OUT     (C),A
        LD      B,#3B
        LD      A,3
        OUT     (C),A
        LD      B,#38
        IN      A,(C)
        INC     B
        LD      A,0     ;SET_INT_MODEM
        OUT     (C),A
        LD      B,#3C
        LD      A,#03   ;ENABLE_INT; DTR_RTS
        OUT     (C),A
MAIN2
        EI
        LD      B,2
LOOP1   HALT
        DJNZ    LOOP1
        LD      BC,#38BF
        IN      A,(C)
        CP      #FF
        JR      NZ,NOERR        ;NOERROR
        LD      A,7
        OUT     (#FE),A
NOERR
        LD      BC,#38BF
        LD      HL,#4000
        IN      A,(C)
        LD      (HL),A
        INC     B
        INC     HL
        IN      A,(C)
        LD      (HL),A
        INC     B
        INC     HL
        IN      A,(C)
        LD      (HL),A
        INC     B
        INC     HL
        IN      A,(C)
        LD      (HL),A
        INC     B
        INC     HL
        IN      A,(C)
        LD      (HL),A
        INC     B
        INC     HL
        IN      A,(C)
        LD      (HL),A
        INC     B
        INC     HL
        IN      A,(C)
        LD      (HL),A
        INC     B
        INC     HL
        JP      MAIN
        RET
SPEED   DEFB    1
TABSPEED  DEFW    #60,#30,#18,#0C,8,7,6,4,3,2

