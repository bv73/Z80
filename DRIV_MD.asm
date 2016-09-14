        ORG     #A000
;
MD_INIT
        LD      BC,#3BBF;Open DLAB
        LD      A,#80
        OUT     (C),A
        LD      B,4     ;2400 Baud
        LD      HL,#300
ROT_BAU
        SRL     H
        RR      L
        DJNZ    ROT_BAU
        LD      B,#39   ;Set DLAB
        OUT     (C),H
        DEC     B
        OUT     (C),L
        LD      B,#3B   ;Set: 8Bit, No parity, 1StopBit
        LD      A,3     ;and close DLAB
        OUT     (C),A
        LD      B,#38   ;???
        IN      A,(C)
        INC     B       ;No interrupts
        XOR     A
        OUT     (C),A
        LD      B,#3C   ;Set RTS & DTR
        LD      A,3
        OUT     (C),A
        INC     B
        HALT
        IN      A,(C)
        INC     A
        RET     Z       ;No modem / No port
        LD      B,#10
DET_LOOP
        HALT
        PUSH    BC
        LD      B,#3E
        IN      A,(C)
        POP     BC
        OR      #C0
        ADD     A,#10
        JR      C,DET_MD
        DJNZ    DET_LOOP
        LD      A,1     ;Modem not ready A=0
        RET
DET_MD  LD      A,#7F   ;Hayes detect A=#7F
        RET
MD_MAIN
        LD      BC,#3DBF;Line reg
        IN      A,(C)
        LD      (LINE_R),A
        RRA
        RET     NC      ;No data
        LD      B,#3E   ;DCD
        IN      A,(C)
        LD      HL,BUF_ONL
TMP_ONL EQU     $-2
        ADD     A,A
        JR      C,ONL_MODE
        LD      HL,BUF_COM
TMP_COM EQU     $-2
        LD      B,#38
        IN      A,(C)   ;Get byte
        LD      (HL),A
        INC     L
        LD      (TMP_COM),HL
        RET
ONL_MODE
        LD      B,#38
        IN      A,(C)
        LD      (HL),A
        INC     L
        LD      (TMP_ONL),HL
        RET
MD_MODE
        CALL    MD_MAIN
MD_MODE2
        LD      HL,TMP_ONL
        LD      A,(GET_ONL)
        CP      (HL)
        JR      NZ,INFO_R
        LD      HL,TMP_COM
        LD      A,(GET_COM)
        CP      (HL)
        JR      Z,INFO_NR
INFO_R
        SCF             ;Info ready
        RET
INFO_NR
        AND     A       ;Info not ready
        RET
MD_SEND
        PUSH    AF
MD_NOSEND
        CALL    MD_MAIN
        LD      A,(LINE_R)
        BIT     5,A
        JR      Z,MD_NOSEND
        POP     AF
        LD      BC,#38BF;Send byte
        OUT     (C),A
        JR      MD_MODE2
MD_GETB
        LD      HL,BUF_ONL
GET_ONL EQU     $-2
        LD      A,(TMP_ONL)
        CP      (HL)
        JR      Z,NEXT_BF
        LD      A,(HL)
        INC     L
        LD      (GET_ONL),HL
        AND     A       ;From bufer OnLine
        RET
NEXT_BF
        LD      HL,BUF_COM
GET_COM EQU     $-2
        LD      A,(TMP_COM)
        CP      (HL)
        JR      Z,FROM_COM
        LD      A,(HL)
        INC     L
        LD      (GET_COM),HL
        SCF             ;From bufer Command
        RET
FROM_COM
        XOR     A       ;No Symbols
        SCF
        RET
LINE_R  DEFB    0
MD_EOF__
BUF_ONL EQU     #A100
BUF_COM EQU     #A200
