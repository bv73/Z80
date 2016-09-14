        ORG     #8000
TABLEUD EQU     #A000
        LD      HL,FILES
        LD      (HL),5
SELECT  XOR     A
        LD      (TABSF),A
        LD      (TABSF+5),A
        LD      A,(TABSF+4)
        LD      HL,FILES
        CP      (HL)
        JR      C,SELFILG
        LD      A,(HL)
SELFILG LD      (F_SELF0),A
SELFILF XOR     A
        LD      IX,TABSF
        LD      (23560),A
        CALL    INVER_S
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
        ADD     A,10
        CP      0                       ;All Files
FILES   EQU     $-1
        JR      NC,SELFI_
        INC     (IX+5)
        SUB     9
        LD      (FIRSTN),A
CSELF11 CALL    SEARCH
        LD      DE,#504
        PUSH    IX
        CALL    PFILES
        LD      A,(FIRSTN)
        CALL    PUDCODE
        POP     IX
        CALL    PLENS
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
CSELF2  CP      13              ;<ENTER> - Select & Exit
        JR      NZ,CSELF3
        CALL    INVER_S
        LD      A,(IX+5)
        RET
CSELF3  CP      14              ;<CS>+<SS> - Break & Exit
        JP      NZ,CSELF33
        CALL    INVER_S
        LD      A,#FF
        RET
CSELF33 CP      #20             ;Metka
        JP      NZ,SELFI_
        LD      C,(IX+5)
        LD      B,0
        LD      HL,TABUD
        ADD     HL,BC
        LD      A,(HL)
        CP      32
        LD      A,#FB
        JR      Z,CSELF4
        LD      A,32
CSELF4  LD      (HL),A
        LD      A,(FIRSTN)
        CALL    PUDCODE
        JP      SELFID0
;------------------
INVER_S LD      A,(IX+2)        ;Print Cursor
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
        RET
PUDCODE                 ;A-Num File
        RET
SEARCH                  ;A-Num File
        RET
PFILES                  ;IX-Addr FileName
                        ;DE-Koor
        RET
PLENS                   ;IX-Addr FileName
        RET

FIRSTN  DEFB    0               ;First Name
TABSF   DEFB    0               ;Num File Cursor
        DEFW    #502            ;Koor Cursor
        DEFB    5               ;Len Cursor
        DEFB    10              ;Lines Select
        DEFB    0               ;Num File Select
        ORG     TABLEUD
TABUD   DEFS    256
        .RUN    #8000
