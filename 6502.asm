;
; Cross-Assembler for 6502 series
; Copyright (C) 1997 by Rst7/CBS
;
;-----------------------------------------
; Variable Section
;-----------------------------------------
;
ENABLE.ADDR.MODE        EQU     0
OpCode                  EQU     0
;
;-----------------------------------------
; Parser Section
;-----------------------------------------
;
        DEFMAC  AdressingError
        DISPLAY AdressingError
        ENDMAC
;
        DEFMAC  PARSE_IMD
        .IF     ENABLE.ADDR.MODE&1
        AdressingError
        .ELSE
        DEFB    OpCode|#08
\r      DEFB    \n\s ; %...
        .ENDIF
        ENDMAC
;
        DEFMAC  PARSE_SX
        .IF     ENABLE.ADDR.MODE&2
        AdressingError
        .ELSE
        DEFB    OpCode|#00
\r      DEFB    \n\s ; (...,X)
        .ENDIF
        ENDMAC
;
        DEFMAC  PARSE_SY
        .IF     ENABLE.ADDR.MODE&4
        AdressingError
        .ELSE
        DEFB    OpCode|#10
\r      DEFB    \n\s ; (...),Y
        .ENDIF
        ENDMAC
;
        DEFMAC  PARSE_IX
        .IF     ENABLE.ADDR.MODE&8
        AdressingError
        .ELSE
        .IF     \0&#FF00
        DEFB    OpCode|#14
\r      DEFB    \0 ; ...,X  ZERO
        .ELSE
        DEFB    OpCode|#1C
\r      DEFW    \0 ; ...,X  Norm
        .ENDIF
        ENDMAC
;
        DEFMAC  PARSE_IY
        .IF     ENABLE.ADDR.MODE&16
        AdressingError
        .ELSE
        DEFB    OpCode|#18
\r      DEFW    \0 ; ...,Y
        .ENDIF
        ENDMAC
;
        DEFMAC  PARSE_ABSOLUTE
\r      .IF     ENABLE.ADDR.MODE&32
        AdressingError
        .ELSE
        .IF     \0&#FF00
        DEFB    OpCode|#04
\r      DEFB    \0 ; ...  ZERO
        .ELSE
        DEFB    OpCode|#0C
\r      DEFW    \0 ; ...  Norm
        .ENDIF
        ENDMAC
;
        DEFMAC  PARSE_ACC
        .IF     ENABLE.ADDR.MODE&64
        AdressingError
        .ELSE
        DEFB    OpCode|#08
        .ENDIF
        ENDMAC
;
        DEFMAC  PARSE
\r      .IF     "  \0"-"  "
        PARSE_ACC
        .ENDIF
\r      .IF     "\c"-"%"
        PARSE_IMD \s
        .ENDIF
        .IF     "\c"-"("|(" \1"-"X)")
        PARSE_SX \s,
        .ENDIF
        .IF     "\c"-"("|("\1 "-"Y ")
        PARSE_SY \s)
        .ENDIF
        .IF     "\c"-"("
        AdressingError
        .ENDIF
        .IF     "\1 "-"X "
        PARSE_IX \s,
        .ENDIF
        .IF     "\1 "-"Y "
        PARSE_IY \s,
        .ENDIF
;
        PARSE_ABSOLUTE \s
        ENDMAC
;
;-----------------------------------------
; Command Section
;-----------------------------------------
;
        DEFMAC  ADC 
ENABLE.ADDR.MODE        =       #3F
OpCode                  =       #61
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  AND 
ENABLE.ADDR.MODE        =       #3F
OpCode                  =       #21
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  CMP
ENABLE.ADDR.MODE        =       #3F
OpCode                  =       #C1
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  EOR
ENABLE.ADDR.MODE        =       #3F
OpCode                  =       #41
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  LDA
ENABLE.ADDR.MODE        =       #3F
OpCode                  =       #A1
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  ORA
ENABLE.ADDR.MODE        =       #3F
OpCode                  =       #01
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  SBC 
ENABLE.ADDR.MODE        =       #3F
OpCode                  =       #E1
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  STA
ENABLE.ADDR.MODE        =       #3E
OpCode                  =       #81
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  BRK
        DEFB    #00
        ENDMAC
;
        DEFMAC  CLC
        DEFB    #18
        ENDMAC
;
        DEFMAC  CLD
        DEFB    #D8
        ENDMAC
;
        DEFMAC  CLI
        DEFB    #58
        ENDMAC
;
        DEFMAC  CLV
        DEFB    #B8
        ENDMAC
;
        DEFMAC  DEX
        DEFB    #CA
        ENDMAC
;
        DEFMAC  DEY
        DEFB    #88
        ENDMAC
;
        DEFMAC  INX
        DEFB    #E8
        ENDMAC
;
        DEFMAC  INY
        DEFB    #C8
        ENDMAC
;
        DEFMAC  NOP
        DEFB    #EA
        ENDMAC
;
        DEFMAC  PHA
        DEFB    #48
        ENDMAC
;
        DEFMAC  PHP
        DEFB    #08
        ENDMAC
;
        DEFMAC  PLA
        DEFB    #68
        ENDMAC
;
        DEFMAC  PLP
        DEFB    #28
        ENDMAC
;
        DEFMAC  RTI
        DEFB    #40
        ENDMAC
;
        DEFMAC  RTS
        DEFB    #60
        ENDMAC
;
        DEFMAC  SEC
        DEFB    #38
        ENDMAC
;
        DEFMAC  SED
        DEFB    #F8
        ENDMAC
;
        DEFMAC  SEI
        DEFB    #78
        ENDMAC
;
        DEFMAC  TAX
        DEFB    #AA
        ENDMAC
;
        DEFMAC  TAY
        DEFB    #A8
        ENDMAC
;
        DEFMAC  TXA
        DEFB    #8A
        ENDMAC
;
        DEFMAC  TYA
        DEFB    #98
        ENDMAC
;
        DEFMAC  TSX
        DEFB    #BA
        ENDMAC
;
        DEFMAC  TXS
        DEFB    #9A
        ENDMAC
;
        DEFMAC  ASL
ENABLE.ADDR.MODE        =       64+32+8
OpCode                  =       #02
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  BIT 
ENABLE.ADDR.MODE        =       32
OpCode                  =       #20
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  for.CP?
        DEFB    OpCode
\r      DEFB    \0
        ENDMAC
;
        DEFMAC  CPX
ENABLE.ADDR.MODE        =       32
OpCode                  =       #E0
\r      .IF     "\c"-"%"
        for.CP? \n\s
        .ENDIF
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  CPY
ENABLE.ADDR.MODE        =       32
OpCode                  =       #C0
\r      .IF     "\c"-"%"
        for.CP? \n\s
        .ENDIF
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  DEC 
ENABLE.ADDR.MODE        =       32+8
OpCode                  =       #C2
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  INC 
ENABLE.ADDR.MODE        =       32+8
OpCode                  =       #E2
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  JMP
\r      .IF     "\c"-"("
        DEFB    #6C
\r      DEFW    \0
        .ELSE
        DEFB    #4C
\r      DEFW    \0
        .ENDIF
        ENDMAC
;
        DEFMAC  JSR
        DEFB    #20
        DEFW    \0
        ENDMAC
;
        DEFMAC  LDX
ENABLE.ADDR.MODE        =       32+8
OpCode                  =       #A2
\r      .IF     "\c"-"%"
        for.CP? \n\s
        .ENDIF
        .IF     "\1 "-"Y "
        PARSE_IX \s,
        .ENDIF
        PARSE_ABSOLUTE \s
        ENDMAC
;
        DEFMAC  LDY
ENABLE.ADDR.MODE        =       32+8
OpCode                  =       #A0
\r      .IF     "\c"-"%"
        for.CP? \n\s
        .ENDIF
        .IF     "\1 "-"X "
        PARSE_IX \s,
        .ENDIF
        PARSE_ABSOLUTE \s
        ENDMAC
;
        DEFMAC  LSR
ENABLE.ADDR.MODE        =       64+32+8
OpCode                  =       #42
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  ROL
ENABLE.ADDR.MODE        =       64+32+8
OpCode                  =       #22
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  ROR
ENABLE.ADDR.MODE        =       64+32+8
OpCode                  =       #62
\r      PARSE   \s
        ENDMAC
;
        DEFMAC  STX
ENABLE.ADDR.MODE        =       32
OpCode                  =       #96
        .IF     "\1 "-"Y "
        for.CP? \0
        .ENDIF
OpCode                  =       #82
\r      PARSE_ABSOLUTE \s
        ENDMAC
;
        DEFMAC  STY
ENABLE.ADDR.MODE        =       32
OpCode                  =       #94
        .IF     "\1 "-"Y "
        for.CP? \0
        .ENDIF
OpCode                  =       #80
\r      PARSE_ABSOLUTE \s
        ENDMAC
;
        DEFMAC  BCC
        DEFB    #90,\0
        ENDMAC
        DEFMAC  BCS
        DEFB    #B0,\0
        ENDMAC
        DEFMAC  BEQ
        DEFB    #F0,\0
        ENDMAC
        DEFMAC  BNE
        DEFB    #D0,\0
        ENDMAC
        DEFMAC  BMI
        DEFB    #30,\0
        ENDMAC
        DEFMAC  BPL
        DEFB    #10,\0
        ENDMAC
        DEFMAC  BVS
        DEFB    #70,\0
        ENDMAC
;
;---------

