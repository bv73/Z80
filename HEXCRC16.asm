HEXD2DEC
        LD      A,#C8
        LD      (HEXD15),A
        PUSH BC
        PUSH HL
        POP BC
        LD HL,59*256+154
        LD (HEXD11+1),HL
        LD HL,202*256+0
        LD (HEXD12+1),HL
        POP HL
        EX DE,HL
        CALL HEXD10
        PUSH HL
        LD HL,5*256+245
        LD (HEXD11+1),HL
        LD HL,225*256+0
        LD (HEXD12+1),HL
        POP HL
        CALL HEXD10
        PUSH HL
        LD HL,152
        LD (HEXD11+1),HL
        LD HL,150*256+128
        LD (HEXD12+1),HL
        POP HL
        CALL HEXD10
        PUSH HL
        LD HL,15
        LD (HEXD11+1),HL
        LD HL,66*256+64
        LD (HEXD12+1),HL
        POP HL
        CALL HEXD10
        PUSH HL
        LD HL,1
        LD (HEXD11+1),HL
        LD HL,134*256+160
        LD (HEXD12+1),HL
        POP HL
        CALL HEXD10
        PUSH HL
        LD HL,0
        LD (HEXD11+1),HL
        LD HL,10000
        LD (HEXD12+1),HL
        POP HL
        CALL HEXD10

        LD A,(HEXD15)
        LD (HEX2D_N),A
        LD E,C
        LD D,B
        JP HEXDDEC

HEXD10  XOR A
        PUSH BC
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
        POP BC
HEXD15  RET Z
        ADD     A,#30
        LD      (BC),A
        INC     BC
        XOR     A
        LD      (HEXD15),A
        RET
HEX2DEC LD      A,#C8
        LD      (HEX2D_N),A
        EX      DE,HL
        LD      BC,10000
        CALL    HEX2D_T
HEXDDEC LD      BC,1000
        CALL    HEX2D_T
        LD      BC,100
        CALL    HEX2D_T
        LD      BC,10
        CALL    HEX2D_T
        LD      A,L
        ADD     A,#30
        LD      (DE),A
        EX      DE,HL
        INC     HL
        LD      (HL),0
        RET
HEX2D_T XOR     A
        SBC     HL,BC
        JR      C,$+5
        INC     A
        JR      $-5
        ADD     HL,BC
        OR      A
HEX2D_N RET     Z
        ADD     A,#30
        LD      (DE),A
        INC     DE
        XOR     A
        LD      (HEX2D_N),A
        RET
CRC_16
        LD      DE,0
CRC16_1 PUSH    BC
        LD      A,(HL)
        INC HL
        CALL UPDCRC16
        POP     BC
        DEC     BC
        LD      A,B
        OR      C
        JP      NZ,CRC16_1
        RET
UPDCRC16
        PUSH HL
        XOR     D
        LD      L,A
        LD      H,0
        LD      A,E
        ADD     HL,HL
        LD      DE,TAB16
        ADD     HL,DE
        LD      E,(HL)
        INC     HL
        XOR     (HL)
        LD      D,A
        POP     HL
        RET
TAB16  DEFW 0,#1021,#2042,#3063,#4084,#50A5
       DEFW #60C6,#70E7,#8108,#9129,#A14A,#B16B,#C18C
       DEFW #D1AD,#E1CE,#F1EF,#1231,#210,#3273
       DEFW #2252,#52B5,#4294,#72F7,#62D6,#9339,#8318
       DEFW #B37B,#A35A,#D3BD,#C39C,#F3FF,#E3DE
       DEFW #2462,#3443,#420,#1401,#64E6,#74C7,#44A4
       DEFW #5485,#A56A,#B54B,#8528,#9509,#E5EE
       DEFW #F5CF,#C5AC,#D58D,#3653,#2672,#1611,#630
       DEFW #76D7,#66F6,#5695,#46B4,#B75B,#A77A
       DEFW #9719,#8738,#F7DF,#E7FE,#D79D,#C7BC,#48C4
       DEFW #58E5,#6886,#78A7,#840,#1861,#2802
       DEFW #3823,#C9CC,#D9ED,#E98E,#F9AF,#8948,#9969
       DEFW #A90A,#B92B,#5AF5,#4AD4,#7AB7,#6A96
       DEFW #1A71,#A50,#3A33,#2A12,#DBFD,#CBDC,#FBBF
       DEFW #EB9E,#9B79,#8B58,#BB3B,#AB1A,#6CA6
       DEFW #7C87,#4CE4,#5CC5,#2C22,#3C03,#C60,#1C41
       DEFW #EDAE,#FD8F,#CDEC,#DDCD,#AD2A,#BD0B
       DEFW #8D68,#9D49,#7E97,#6EB6,#5ED5,#4EF4,#3E13
       DEFW #2E32,#1E51,#E70,#FF9F,#EFBE,#DFDD
       DEFW #CFFC,#BF1B,#AF3A,#9F59,#8F78,#9188,#81A9
       DEFW #B1CA,#A1EB,#D10C,#C12D,#F14E,#E16F
       DEFW #1080,#A1,#30C2,#20E3,#5004,#4025,#7046
       DEFW #6067,#83B9,#9398,#A3FB,#B3DA,#C33D
       DEFW #D31C,#E37F,#F35E,#2B1,#1290,#22F3,#32D2
       DEFW #4235,#5214,#6277,#7256,#B5EA,#A5CB
       DEFW #95A8,#8589,#F56E,#E54F,#D52C,#C50D,#34E2
       DEFW #24C3,#14A0,#481,#7466,#6447,#5424
       DEFW #4405,#A7DB,#B7FA,#8799,#97B8,#E75F,#F77E
       DEFW #C71D,#D73C,#26D3,#36F2,#691,#16B0
       DEFW #6657,#7676,#4615,#5634,#D94C,#C96D,#F90E
       DEFW #E92F,#99C8,#89E9,#B98A,#A9AB,#5844
       DEFW #4865,#7806,#6827,#18C0,#8E1,#3882,#28A3
       DEFW #CB7D,#DB5C,#EB3F,#FB1E,#8BF9,#9BD8
       DEFW #ABBB,#BB9A,#4A75,#5A54,#6A37,#7A16,#AF1
       DEFW #1AD0,#2AB3,#3A92,#FD2E,#ED0F,#DD6C
       DEFW #CD4D,#BDAA,#AD8B,#9DE8,#8DC9,#7C26,#6C07
       DEFW #5C64,#4C45,#3CA2,#2C83,#1CE0,#CC1
       DEFW #EF1F,#FF3E,#CF5D,#DF7C,#AF9B,#BFBA,#8FD9
       DEFW #9FF8,#6E17,#7E36,#4E55,#5E74,#2E93
       DEFW #3EB2,#ED1,#1EF0

