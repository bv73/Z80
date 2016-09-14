;-----------------------------------------------------------
; Процедуры печати десятичных чисел.
; Используется алгоритм печати без незначащих нулей
; впереди числа.


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
        LD      DE,#2710	;10000
        CALL    PRIDCM
DECIMA4 LD      DE,#3E8		;1000
        CALL    PRIDCM
DECIMA3 LD      DE,#64		;100
        CALL    PRIDCM
        LD      DE,10		;10
        CALL    PRIDCM
        LD      A,L
        ADD     A,#30
        JP      PRIA
PRIDCM  XOR     A
PRIDCM5 SBC     HL,DE		;Из HL вычитается DE
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

