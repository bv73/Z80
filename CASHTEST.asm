;-----------------------------------------------------------
;CMOS RAM COMPARER (16Kbyte) By (R)soft 19/11/1999
;Compare Mask from #00 to #FF (Outing to #4000)
;After test:
;BORDER WHITE - ERROR at (ADRERR) with Byte ERROR (ERRB)
;BORDER BLACK - No ERRORS
;Test Time: 72 Sec
;-----------------------------------------------------------
ADDR    EQU     #0
LEN     EQU     #3FFF

        ORG     #8000
        DI
        IN      A,(#FB)         ;CMOS Enable
;
        LD      B,0             ;First Mask
LOOP
        PUSH    BC
        LD      A,B
        LD      (#4000),A
        LD      HL,ADDR
        LD      BC,LEN
        LD      E,L
        LD      D,H
        INC     DE
        LD      (HL),A
        LDIR
        LD      HL,ADDR
        LD      BC,LEN
        CALL    COMPARE
        POP     BC
        JR      C,ERROR
        DJNZ    LOOP
;
        IN      A,(#7B)         ;ROM Enable
        XOR     A               ;No ERROR
        OUT     (#FE),A
        EI
        RET
ERROR
        LD      (ADRERR),HL
        LD      A,(HL)
        LD      (ERRB),A
        CALL    COPY            ;Bank Memory from #C000
;
        IN      A,(#7B)
        LD      A,7     ;ERROR - White Border
        OUT     (#FE),A
        LD      HL,0    ;Address of ERROR
ADRERR  EQU     $-2
        LD      A,0     ;Error Byte
ERRB    EQU     $-1
        EI
        RET
;
COMPARE
        CP      (HL)    ;Compare (HL) and ACC
        JR      NZ,ERR_HL
        INC     HL
        DEC     BC
        LD      A,C
        OR      B
        JP      NZ,COMPARE
        AND     A       ;Reset CARRY - No Error
        RET
ERR_HL
        SCF             ;Set CARRY - Error
        RET
;
COPY
        LD      HL,ADDR
        LD      DE,#C000
        LD      BC,LEN
        INC     BC
        LDIR
        RET

