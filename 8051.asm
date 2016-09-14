;---------------------------------
; Cross-Assembler for 8051 Series
; Copyright (C) 1997 by Rst7/CBS
;---------------------------------
;
opcode  EQU     0
secondbyte EQU  0-1
;
        DEFMAC  byte2
        DEFB    \0,\1
        ENDMAC
        DEFMAC  byte
        DEFB    \0
        ENDMAC
;
        DEFMAC  compil@1
        DEFB    \0
        .IF     secondbyte-#FFFF
        .ELSE
        DEFB    secondbyte
secondbyte      =       0-1
        .ENDIF
        ENDMAC
;
        DEFMAC  Error
\0
        ENDMAC
;
        DEFMAC  compile@
\r      .IF     "\c\c"-"RR"
        .ELSE
        Error   Adressing Error in @Rx
        .ENDIF
\r      .IF     " \n\c"-" 0"
        compil@1 opcode+6
        .ENDIF
\r      .IF     " \n\c"-" 1"
        compil@1 opcode+7
        .ENDIF
        Error   Adressing Error in @Rx
        ENDMAC
;
        DEFMAC  compilead
        DEFB    opcode+5,\0
        .IF     secondbyte-#FFFF
        .ELSE
        DEFB    secondbyte
secondbyte      =       0-1
        .ENDIF
        ENDMAC
;
        DEFMAC  compilereg
\r      DEFB    opcode+"\n\c"-"0"+8
        .IF     secondbyte-#FFFF
        .ELSE
        DEFB    secondbyte
secondbyte      =       0-1
        .ENDIF
        ENDMAC
;
        DEFMAC  mov.2A
\r      .IF     " \c"-" #"
        byte2   #74,\n\s
        .ENDIF
\r      .IF     " \c"-" @"
        compile@ \n\s
        .ENDIF
\r      .IF     ("\c\c"-"RR")|(" \n\c"-" 0"/8)|("\n\c"-" ")
        compilereg \0
        .ENDIF
        compilead \0
        ENDMAC
;
        DEFMAC  mov.fromA
;
\r      .IF     " \c"-" @"
        compile@ \n\s
        .ENDIF
\r      .IF     ("\c\c"-"RR")|(" \n\c"-" 0"/8)|("\n\c"-" ")
        compilereg \0
        .ENDIF
        compilead \0
        ENDMAC
;
;---------------------------------
        DEFMAC  MOV.part2
;\r\s,\n
        .IF     ("\c\c"-"RR")|(" \n\c"-" 0"/8)|("\n\c"-" ")
secondbyte      =       \0&#FF
opcode  =       #80
        compilereg \1
        .ENDIF
;\r\s,\n
        DEFB    #85,\s;,\0
;
        ENDMAC
;----
        DEFMAC  MOVC    A,@A+PC
        DEFB    #83
        ENDMAC
        DEFMAC  MOVC    A,@A+DPTR
        DEFB    #93
        ENDMAC
        DEFMAC  MOVX    A,@DPTR
        DEFB    #E0
        ENDMAC
        DEFMAC  MOVX    @DPTR,A
        DEFB    #F0
        ENDMAC
        DEFMAC  MOVX    A,@R0
        DEFB    #E2
        ENDMAC
        DEFMAC  MOVX    A,@R1
        DEFB    #E3
        ENDMAC
        DEFMAC  MOVX    @R0,A
        DEFB    #F2
        ENDMAC
        DEFMAC  MOVX    @R1,A
        DEFB    #F3
        ENDMAC
        DEFMAC  MOV     DPTR,#
        DEFB    #90
        DEFB    \0/256,\0
        ENDMAC
;----
        DEFMAC  MOV
;
        .IF     " \1"-" C"
        byte2   #92,\0
        .ENDIF
        .IF     " \0"-" C"
        byte2   #A2,\1
        .ENDIF
;
        .IF     " \1"-" A"
opcode  =       #F0
        mov.fromA \0 ;
        .ENDIF
        .IF     " \0"-" A"
opcode  =       #E0
        mov.2A  \1 ;
        .ENDIF
;\r\s,\n
        .IF     " \c"-" #"
secondbyte      =       \n\s
secondbyte      =       secondbyte&#FF
opcode  =       #70
        mov.fromA \0 ;
        .ENDIF
;
\r      .IF     " \c"-" @"
secondbyte      =       \1&#FF
opcode  =       #A0
        compile@ \n\s
        .ENDIF
;
\r      .IF     ("\c\c"-"RR")|(" \n\c"-" 0"/8)|(" \n\c"-" ,")
secondbyte      =       \1&#FF
opcode  =       #A0
        compilereg \0
        .ENDIF
;
;\r\s,
        .IF     " \n\c"-" @"
secondbyte      =       \0&#FF
opcode  =       #80
        compile@ \n\s
        .ENDIF
        MOV.part2 \0,\1 ;
        ENDMAC
;----
        DEFMAC  onebytecmd
        .IF     " \1"-" \2"
        DEFB    \0
        .ELSE
        Error   Need '\2' operand
        .ENDIF
        ENDMAC
;
        DEFMAC  RR 
        onebytecmd #03,\0,A
        ENDMAC
        DEFMAC  RRC 
        onebytecmd #13,\0,A
        ENDMAC
        DEFMAC  RL 
        onebytecmd #23,\0,A
        ENDMAC
        DEFMAC  RLC 
        onebytecmd #33,\0,A
        ENDMAC
        DEFMAC  RET
        onebytecmd #22,\0,
        ENDMAC
        DEFMAC  RETI
        onebytecmd #32,\0,
        ENDMAC
        DEFMAC  DIV
        onebytecmd #84,\0,AB
        ENDMAC
        DEFMAC  MUL
        onebytecmd #A4,\0,AB
        ENDMAC
        DEFMAC  SWAP
        onebytecmd #C4,\0,A
        ENDMAC
        DEFMAC  DA
        onebytecmd #D4,\0,A
        ENDMAC
;------
        DEFMAC  parse1
\r      .IF     " \c"-" #"
        byte2   opcode+4,\n\s
        .ENDIF
\r      .IF     " \c"-" @"
        compile@ \n\s
        .ENDIF
\r      .IF     ("\c\c"-"RR")|(" \n\c"-" 0"/8)|("\n\c"-" ")
        compilereg \0
        .ENDIF
        compilead \0
        ENDMAC
;
        DEFMAC  parse2
        .IF     \2
        Error   Illegal adressing mode
        .ENDIF
        .IF     " \0"-" A"
        byte2   opcode+2,\1
        .ENDIF
        .IF     " \r\c"-" #"
        DEFB    opcode+3
        byte2   \1,\n\s,
        .ENDIF
        Error   Illegal adressing mode
        ENDMAC
;
        DEFMAC  parse
opcode  =       \1
        .IF     " \2"-" A"
        parse1  \0 ;
        .ELSE
        parse2  \0,\2,\3
        .ENDIF
        ENDMAC
;
        DEFMAC  ADD 
        parse   \1,#20,\0,0
        ENDMAC
        DEFMAC  ADDC
        parse   \1,#30,\0,0
        ENDMAC
;
        DEFMAC  ORL.part2
\r      .IF     " \c"-" /"
        DEFB    #A0,\n\s
        .ELSE
        DEFB    #72,\s
        .ENDIF
        ENDMAC
;
        DEFMAC  ORL
        .IF     " \0"-" C"
        ORL.part2 \1
        .ENDIF
        parse   \1,#40,\0,1
        ENDMAC
;
        DEFMAC  ANL.part2
\r      .IF     " \c"-" /"
        DEFB    #B0,\n\s
        .ELSE
        DEFB    #82,\s
        .ENDIF
        ENDMAC
;
        DEFMAC  ANL
        .IF     " \0"-" C"
        ANL.part2 \1
        .ENDIF
        parse   \1,#50,\0,1
        ENDMAC
        DEFMAC  XRL
        parse   \1,#60,\0,1
        ENDMAC
        DEFMAC  SUBB
        parse   \1,#90,\0,0
        ENDMAC
        DEFMAC  XCHD    A,@R0
        DEFB    #D6
        ENDMAC
        DEFMAC  XCHD    A,@R1
        DEFB    #D7
        ENDMAC
        DEFMAC  XCH
        parse   \1,#C0,\0,0
        ENDMAC
;
        DEFMAC  INC.part2
\r      .IF     ("\c\c"-"RR")|(" \n\c"-" 0"/8)|("\n\c"-" ")
        compilereg \0
        .ENDIF
\r      .IF     ("\c\n\c\n"-"DP")|("\c\n\c\n\s "-"TR")
        byte    #A3
        .ENDIF
        compilead \0
        ENDMAC

        DEFMAC  INC 
        .IF     "~~\1"-"~~"
        .ELSE
        Error   Only one operand need
        .ENDIF
opcode  =       0
\r      .IF     " \c"-" A"
        byte    opcode+4
        .ENDIF
\r      .IF     " \c"-" @"
        compile@ \n\s
        .ENDIF
        INC.part2 \0 ;   ;
        ENDMAC
;
        DEFMAC  DEC.part2
\r      .IF     ("\c\c"-"RR")|(" \n\c"-" 0"/8)|("\n\c"-" ")
        compilereg \0
        .ENDIF
        compilead \0
        ENDMAC
        DEFMAC  DEC 
        .IF     "~~\1"-"~~"
        .ELSE
        Error   Only one operand need
        .ENDIF
opcode  =       #10
\r      .IF     " \c"-" A"
        byte    opcode+4
        .ENDIF
\r      .IF     " \c"-" @"
        compile@ \n\s
        .ENDIF
        DEC.part2 \0 ;   ;
        ENDMAC
;
        DEFMAC  DJNZ 
opcode  =       #D0
secondbyte      =       \1-$-2
        .IF     secondbyte+#80/256
        .ELSE
        Error   DJNZ too far
        .ENDIF
secondbyte      =       secondbyte&255
\r      .IF     ("\c\c"-"RR")|(" \n\c"-" 0"/8)|(" \n\c"-" ,")
        compilereg \0
        .ENDIF
        compilead \0
        ENDMAC
;
        DEFMAC  JMP     @A+DPTR
        DEFB    #73
        ENDMAC
;
        DEFMAC  PUSH 
        DEFB    #C0,\0
        ENDMAC
        DEFMAC  POP 
        DEFB    #D0,\0
        ENDMAC
;
        DEFMAC  CPL     C
        DEFB    #B3
        ENDMAC
        DEFMAC  CLR     C
        DEFB    #C3
        ENDMAC
        DEFMAC  SETB    C
        DEFB    #D3
        ENDMAC
;
        DEFMAC  CPL
        DEFB    #B2,\0
        ENDMAC
        DEFMAC  CLR
        DEFB    #C2,\0
        ENDMAC
        DEFMAC  SETB
        DEFB    #D2,\0
        ENDMAC
;
        DEFMAC  LJMP
        DEFB    #02,\0/256,\0
        ENDMAC
        DEFMAC  LCALL
        DEFB    #12,\0/256,\0
        ENDMAC
;
        DEFMAC  AJMP
        DEFB    #01|(\0&#700/8),\0
        ENDMAC
        DEFMAC  ACALL
        DEFB    #11|(\0&#700/8),\0
        ENDMAC
;
        DEFMAC  sendrel
opcode          =       \1-$-2
        .IF     opcode+#80/256
        .ELSE
        Error   Relative jump too far
        .ENDIF
        DEFB    \0
        .IF     "~~\2"-"~~"
        .ELSE
        DEFB    \2
        .ENDIF
        DEFB    opcode
        ENDMAC
;
        DEFMAC  JBC
        sendrel #10,\1,\0
        ENDMAC
        DEFMAC  JB
        sendrel #20,\1,\0
        ENDMAC
        DEFMAC  JNB
        sendrel #30,\1,\0
        ENDMAC
        DEFMAC  JC
        sendrel #40,\0
        ENDMAC
        DEFMAC  JNC
        sendrel #50,\0
        ENDMAC
        DEFMAC  JZ
        sendrel #60,\0
        ENDMAC
        DEFMAC  JNZ
        sendrel #70,\0
        ENDMAC
        DEFMAC  SJMP
        sendrel #80,\0
        ENDMAC
;---------------------------------
; Define symbolical names of internal ports/registers
;
ACC     EQU     0E0H
BREG    EQU     0F0H
PSW     EQU     0D0H
SPP     EQU     081H
DPH     EQU     083H
DPL     EQU     082H
P0      EQU     080H
P1      EQU     090H
P2      EQU     0A0H
P3      EQU     0B0H
IP      EQU     0B8H
IE      EQU     0A8H
TMOD    EQU     089H
TCON    EQU     088H
TH0     EQU     08CH
TL0     EQU     08AH
TH1     EQU     08DH
TL1     EQU     08BH
SCON    EQU     098H
SBUF    EQU     099H
PCON    EQU     087H
;
        ORG     #8000
        MOV     A,1
        MOV     C,1
