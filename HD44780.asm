;______/\_______________/\_____________
;Driver For LCD Displays Based HD44780 \_____
;(c) By (R)soft 24 Feb - 3 Mar 2001 Ver 0.07 \
;LCD Display Type: SC2002AS*B-EH-G (Bolymin) /
;2 Lines And 20 Symbols Per Line   _________/
;______________/\_________________/
;Connect LCD Display to Ports:    \____
;PA0-PA3: Data 0-3  Bidirectional Bus /
;PB0: RS (Register Select) Output Pin \
;PB1: R/W (Read/Write) Output Pin     /
;PB2: E (Enable R/W) Output Pin      /
;Data Transfering 4Bit Protocol ____/
;
SYMBOLS EQU     20      ;Number Of Symbols Per Line
DATA    EQU     #1F     ;Port A
CONTROL EQU     #3F     ;Port B
PSET    EQU     #7F     ;Port Set
COUNTER EQU     #80     ;TimeOut Counter of BUSY Loop
MASK    EQU     #FF     ;Mask Byte Of Data
DELAY   EQU     #01     ;Delay For Out Operations
TSTADR  EQU     #5B70
SHPAU   EQU     250
PAUSCRL EQU     10      ;Scroll Pause
;
        ORG     #8000
;
        DI
        LD      (SPREAL),SP
        LD      A,#80           ;Set PA & PB to In/Out
        OUT     (PSET),A
        LD      A,MASK
        OUT     (DATA),A        ;Data Bus=Hi
        XOR     A
        OUT     (CONTROL),A
        CALL    PAUSELONG
        CALL    INIT
        LD      HL,SET2         ;64 Bytes User Symbols
        CALL    USERSET
        JP      MAIN_ONE
;
;------------------------------------------
;Scrolling External (Loading) Text Into Display
;With Russian Symbols
;Press SPACE to Exit
;Press ENTER to STOP Scroll
;
MAIN_FOUR
        LD      A,1             ;Display On/Off
        LD      C,0             ;Cursor On/Off
        AND     A               ;Blinking On/Off (AND A)
        CALL    SHOW
        CALL    CLS
        LD      HL,#C000        ;Load Text & Marking End #1F
        CALL    TXTSCROL
        EI
        RET
;
;------------------------------------------
;Scrolling Include Text Into Display
;Press SPACE to Exit
;Press ENTER to STOP Scroll
;Press CAPS to Speed Up
;
MAIN_THREE
        LD      A,1             ;Display On/Off
        LD      C,0             ;Cursor On/Off
        AND     A               ;Blinking On/Off (AND A)
        CALL    SHOW
        CALL    CLS
        LD      HL,TXTSCRL
        CALL    TXTSCROL
        EI
        RET
TXTSCROL
        LD      (TXTTMP),HL
        LD      (TXTTMP2),HL
        LD      HL,BUFER        ;Clear Bufer
        LD      D,H
        LD      E,L
        INC     DE
        LD      (HL),#20
        LD      BC,SYMBOLS-1
        LDIR
TXTSCROL2
        LD      A,#BF                   ;Press ENTER
        IN      A,(#FE)
        RRA
        JR      NC,TXTSCROL4
        LD      B,1
        LD      A,#FE                   ;Press CAPS
        IN      A,(#FE)
        RRA
        LD      A,1
        JR      NC,TXTSCROL5
        LD      A,PAUSCRL
TXTSCROL5
        LD      (TMPPAU),A
        LD      A,#7F                   ;Press SPACE
        IN      A,(#FE)
        RRA
        RET     NC
        LD      HL,0
TXTTMP2 EQU     $-2
        LD      A,(HL)
        CALL    TABLER
        INC     HL
        LD      (TXTTMP2),HL
        CP      #1F
        JR      NZ,TXTSCROL3
        LD      HL,0
TXTTMP  EQU     $-2
        LD      (TXTTMP2),HL
        JR      TXTSCROL2
TXTSCROL3
        LD      DE,BUFER        ;Scroll In Bufer
        LD      H,D
        LD      L,E
        INC     HL
        LD      BC,SYMBOLS-1
        LDIR
        LD      (DE),A
        LD      HL,BUFER
        LD      DE,#0000
        CALL    TEXTOUT         ;Out Bufer
TXTSCROL4
        LD      B,0
TMPPAU  EQU     $-1
        CALL    PAUSEB
        LD      A,3
        CALL    FLASHTXT
        JR      TXTSCROL2
TABLER
        CP      "-"
        JR      NZ,TABLER9
        INC     HL
        LD      A,(HL)
        DEC     HL
        CP      #0D
        LD      A,"-"
        RET     NZ
        POP     BC
        INC     HL
        INC     HL
        LD      (TXTTMP2),HL
        JR      TXTSCROL2
TABLER9
        CP      #0D
        JR      NZ,TABLER1
        LD      A,#20
        RET
TABLER1
        CP      #0A
        JR      NZ,TABLER2
        POP     BC              ;Stack -2
        INC     HL
        LD      (TXTTMP2),HL
        JR      TXTSCROL2
TABLER2
        BIT     7,A
        RET     Z
        LD      IX,TABLEC-#80
        LD      C,A
        LD      B,0
        ADD     IX,BC
        LD      A,(IX)
        RET
FLASHTXT
        LD      A,3
FLTMP   EQU     $-1
        DEC     A
        LD      (FLTMP),A
        AND     A
        RET     NZ
        LD      A,3
FLTMP0  EQU     $-1
        LD      (FLTMP),A
        LD      A,1
FLTMP1  EQU     $-1
        XOR     1
        LD      (FLTMP1),A
        AND     A
        LD      HL,TXTFL0
FLTMP10 EQU     $-2
        JR      Z,FLASHSP
        LD      HL,TXTFL1
FLTMP20 EQU     $-2
FLASHSP
        LD      DE,#0104
FLTMP30 EQU     $-2
        JP      TEXTOUT
TXTFL0  DEFB    "           ",#1F
TXTFL1  DEFB    "Press SPACE",#1F
BUFER   DEFS    SYMBOLS
        DEFB    #1F
TXTSCRL DEFB    "     Press SPACE to Exit or Press ENTER to "
        DEFB    "Stop Scrolling...   "
        DEFB    "Ooo! Hi! This is NEW Pervertional "
        DEFB    "Scroller Written By Bakum Vladimir 27 "
        DEFB    "February 2001 Year. Test Controller "
        DEFB    "Undo Outing of Scroll-Text. If This Working "
        DEFB    "Is Really Beautiful, Then I Made Converter "
        DEFB    "From Alternative Coding Into LCD Coding... "
        DEFB    "                    ",#FF,#FF,#FF
        DEFB    "          "
        DEFB    "This Is Version 0.07 of Prorgram. "
        DEFB    " --->     Read Again...                  ",#1F
;
;-------------------------------------------
;See All Font Into Display
;Press SPACE to Exit
;Or Press ENTER to Display Next Symbol
;
MAIN_TWO
        LD      A,1             ;Display On/Off
        LD      C,0             ;Cursor On/Off
        SCF                     ;Blinking On/Off (AND A)
        CALL    SHOW
        CALL    CLS
;
        LD      HL,TEXT9
        LD      DE,#0007
        CALL    TEXTOUT
        LD      HL,TEXT10
        LD      DE,#010A
        CALL    TEXTOUT
;
        XOR     A
        LD      (COUNTA),A
MT2
        LD      HL,0
        LD      (TMPX),HL
        CALL    KOOR
        LD      A,"#"
        CALL    PRIA
        LD      A,0
COUNTA  EQU     $-1
        CALL    PRIHB
        LD      A,"="
        CALL    PRIA
        LD      A,(COUNTA)
        CALL    PRIA
LP1
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      NC,ABORT1
        LD      A,#BF
        IN      A,(#FE)
        RRA
        JR      C,LP1
        LD      B,2
        CALL    PAUSEB
        LD      A,(COUNTA)
        INC     A
        LD      (COUNTA),A
        AND     A
        JR      NZ,MT2
ABORT1
        EI
        RET
TEXT9   DEFB    "Press <ENTER>",#1F
TEXT10  DEFB    "Or <SPACE>",#1F
;----------------------------------------------
;Printed Into Display Text
;Press ENTER to Fast Looking
;Or Press SPACE to Abort
;
MAIN_ONE
        LD      A,1             ;Display On/Off
        LD      C,0             ;Cursor On/Off
        AND     A               ;Blinking On/Off (AND A)
        CALL    SHOW
        CALL    CLS
        LD      HL,TEXT         ;Addr Text
        LD      DE,#0000        ;Position Y,X
        CALL    TEXTOUT
        LD      B,SHPAU
        CALL    PAUSEB
        LD      B,9
LOOPM
        PUSH    BC
        CALL    CLS
        LD      DE,#0000
        CALL    TEXTOUT
        LD      B,SHPAU
        CALL    PAUSEB
        POP     BC
        DJNZ    LOOPM
        LD      HL,TXTFL9
        LD      (FLTMP10),HL
        LD      HL,TXTFL8
        LD      (FLTMP20),HL
        LD      HL,#0100
        LD      (FLTMP30),HL
        LD      A,8
        LD      (FLTMP),A
        LD      (FLTMP0),A
;
LOOPM0
        LD      A,#F7
        IN      A,(#FE)
        RRA
        LD      HL,SET2
        JR      NC,LOOPMZ
        RRA
        LD      HL,SET3
        JR      NC,LOOPMZ
        RRA
        LD      HL,SET4
        JR      NC,LOOPMZ
        RRA
        JR      C,LOOPMX
        LD      HL,SET5
LOOPMZ
        CALL    USERSET
LOOPMX
        LD      B,20
        LD      HL,LINE0
FTABL1  EQU     $-2
LOOPM1
        CALL    JACH
        INC     HL
        DJNZ    LOOPM1
        LD      HL,0
        LD      (TMPX),HL
        CALL    KOOR
        LD      B,20
        LD      HL,LINE0
FTABL2  EQU     $-2
LOOPM2
        PUSH    BC
        LD      A,(HL)
        INC     HL
        PUSH    HL
        RES     7,A
        CALL    PRIA
        POP     HL
        POP     BC
        DJNZ    LOOPM2
;
        LD      B,5
        CALL    PAUSEB
        CALL    FLASHTXT
        CALL    STABL
;
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,LOOPM0
        EI
        RET
STABL
        LD      A,#40
STABL0  EQU     $-1
        DEC     A
        LD      (STABL0),A
        RET     NZ
        LD      A,#40
        LD      (STABL0),A
        LD      HL,TABLIN
STABL1  EQU     $-2
        INC     HL
        INC     HL
        LD      (STABL1),HL
STABL6
        LD      A,(HL)
        INC     HL
        LD      H,(HL)
        LD      L,A
        AND     A
        JR      NZ,STABL5
        LD      HL,TABLIN
        LD      (STABL1),HL
        JR      STABL6
STABL5
        LD      (FTABL1),HL
        LD      (FTABL2),HL
        RET
TABLIN  DEFW    LINE0,LINE1,LINE2,LINE3,LINE4,LINE5,LINE6
        DEFW    0
LINE0   DEFB    #87,#86,#85,#84,#83,#82,#81,6,5,4,3,2,1
        DEFB    0,#81,#82,#83,#84,#85,#86
LINE1   DEFB    0,1,2,3,2,1,0,1,2,3,2,1,0,1,2,3,2,1,0,1
LINE2   DEFB    0,1,2,3,4,5,6,#87
        DEFB    #86,#85,#84,#83,#82,#81,0,1,2,3,4,5
LINE3   DEFB    0,2,4,6,4,2,0,2,4,6,4,2,0,2,4,6,4,2,0,2
LINE4   DEFB    0,0,2,2,1,1,3,3,5,5,4,4,0,0,1,1,2,2,3,3
LINE5   DEFB    6,#86,5,#85,4,#84,3,#83,2,#82,1,#81,0,#87
        DEFB    3,#83,6,#86,5,#85
LINE6   DEFB    0,6,1,5,2,4,3,5,2,3,0,5,6,2,3,1,4,0,3,2
;
JACH
        LD      A,(HL)
        BIT     7,A
        JR      Z,JUP
        DEC     A
        CP      #80
        JR      Z,SETUP
        LD      (HL),A
        RET
SETUP
        RES     7,A
        LD      (HL),A
        RET
JUP
        INC     A
        CP      7
        JR      Z,SETDOWN
        LD      (HL),A
        RET
SETDOWN
        SET     7,A
        LD      (HL),A
        RET
;
TEXT    DEFB    "Hi!!! This Is Great",13        ;Line 1
        DEFB    "Text Screened LCD",#1F         ;Line 2
;
        DEFB    "You May Looking Now",13
        DEFB    "All Russian Fonts",#1F
;
        DEFB    "KOHTPO",#A7,#A7,"EP ",#A3,"K",#A5,13
        DEFB    #E0,#A5,"C",#A8,#A7,"E",#B1," - SC2002AS",#1F
;
        DEFB    #A0,"A",#A4,#A5,"P",#A9,"ETC",#B1
        DEFB    " HA OCHOBE"
        DEFB    "KP",#A5,"CTA",#A7,#A7,"A HD44780",#1F
;
        DEFB    #A8,"PO",#A1,"PAMM",#A9," PA",#A4
        DEFB    "PA",#A0,"OTA",#A7
        DEFB    #A0,"AK",#A9,"M B",#A7,"AD",#A5,"M",#A5,"P",#1F
;
        DEFB    "HA",#A8,#A5,"CAHO HA Sinclair"
        DEFB    "ZX-Spectrum T",#A5,#A8,"A",#1F
;
        DEFB    "  ",#C8," PENTAGON 128 ",#C9,13
        DEFB    "XAP",2,"KOB 25.2.2001",#1F
;
        DEFB    "Driver LCD Display",13
        DEFB    "Version 0.07",#1F
;
        DEFB    "26 ",#AA,"e",#B3,"pa",#BB,#C7," 2001 "
        DEFB    #B4,"o",#E3,"a"
        DEFB    "(c) By (R)soft",#1F
;
        DEFB    0,1,2,3,4,5,6,7,13
TXTFL9  DEFB    #A0,"AK",#A9,"M BOBA - (R)SOFT",#1F
TXTFL8  DEFB    "  Press <1> to <4>  ",#1F
;
;In: DE=YX, HL=Addr Text
;    B=Num Symb
;
TEXTOUT
        LD      A,D
        AND     1               ;Num Col
        LD      A,#40           ;Addr 2 Line
        JR      NZ,TEXTOUT0
        LD      A,0             ;Addr 1 Line
TEXTOUT0
        ADD     A,E             ;+Num Row
        LD      C,A             ;C=Addr DDRAM
        CALL    SET_DDADR
TXTMAIN
        LD      A,(HL)
        INC     HL
        CP      #1F
        RET     Z               ;#1F-Code=Exit
        CP      13
        JR      NZ,TXTM1        ;Enter
        CALL    NEXTLINE
        JR      TXTMAIN
TXTM1
        CALL    WR_RAM
        INC     E               ;Increment X
        LD      A,E
        CP      SYMBOLS
        CALL    Z,NEXTLINE
        JR      TXTMAIN
NEXTLINE
        BIT     6,C             ;C=Addr
        LD      C,0             ;Set New Addr
        LD      DE,#0000        ;Set New ColRow
        JR      NZ,SET_DDADR
        LD      C,#40
        INC     D
        JR      SET_DDADR
CLEARCGRAM
        LD      C,0             ;CGADR
        CALL    SET_CGADR
        LD      B,64
        XOR     A
CCRLOOP
        CALL    WR_RAM
        DJNZ    CCRLOOP
        RET
USERSET
        LD      C,0
        CALL    SET_CGADR
        LD      B,64            ;8x8 Bytes
USERSETL
        LD      A,(HL)
        INC     HL
        CALL    WR_RAM
        DJNZ    USERSETL
        RET
;
;--= Standart Command "Clear Screen" =--
;
CLS
        LD      A,1
        JR      WR_COM
;
;--= Standart Command "Return to Begin" =--
;
BEGIN
        LD      A,2
        JR      WR_COM
;
;--= Standart Command "Set Input Mode" =--
; A=0 Dec ADDR (Right Scroll) , A=1 Inc ADDR (Left Scroll)
; C=0 No Scroll Display, C=1 Scroll Display
;
INPUT_SET
        RLCA
        LD      B,4
        OR      B
        OR      C
        AND     7
        JR      WR_COM
;
;--= Standart Command "On/Off Display"
; A=0 Display Off, A=1 Display On
; C=0 Cursor Off, C=1 Cursor On
; Set CARRY - Blinking On
;
SHOW
        PUSH    AF
        LD      B,8
        RLCA
        RLCA
        OR      B
        LD      B,A
        POP     AF
        LD      A,C
        RLA
        OR      B
        AND     #0F
        JR      WR_COM
;
;--= Standart Commands "Scroll Cursor/Display" =--
;
;Scroll Display Left
;
SCROL_LEFT
        LD      A,#18
        JR      WR_COM
;
;Scroll Display Right
;
SCROL_RIGHT
        LD      A,#1C
        JR      WR_COM
;
;Scroll Cursor Left
;
CUR_LEFT
        LD      HL,TMPX
        DEC     (HL)
        LD      A,#10
        JR      WR_COM
;
;Scroll Cursor Right
;
CUR_RIGHT
        LD      HL,TMPX
        INC     (HL)
        LD      A,#14
        JR      WR_COM
;
;--= Standart Command "Set Function" =--
;
;DL=0 - 4Bit Interface
;N=1 - 2 Lines Displayed
;F=0 - Matrix of Symbol 5x8 Pixels
;
SET_FUNCTION
        LD      A,#28
        JR      WR_COM
;
;--= Standart Command "Set Address CGRAM" =--
; C=Addr CGRAM
;
SET_CGADR
        LD      A,#40
        OR      C
        AND     #7F
        JR      WR_COM
;
;--= Standart Command "Set Address DDRAM" =--
; C=Addr DDRAM
;
SET_DDADR
        LD      A,#80
        OR      C
;In: A=Byte
;Exit: CF=1 ERROR, CF=0 OK
WR_COM
        CALL    BUSY
        JR      C,ERROR
;
;       PUSH    AF
;       XOR     A
;       OUT     (CONTROL),A
;       CALL    PAUSE
;       POP     AF
;
        OUT     (DATA),A        ;Hi Tetrade
        RLCA
        RLCA
        RLCA
        RLCA
;
        PUSH    BC
        LD      C,A
        LD      A,4             ;  _ Write In Com_Reg
        OUT     (CONTROL),A     ;_/ \_  1
        CALL    PAUSE
        XOR     A
        OUT     (CONTROL),A
        CALL    PAUSE
        LD      A,C
        POP     BC
;
        OUT     (DATA),A        ;Low Tetrade
        LD      A,4             ;  _ Write In Com_Reg
        OUT     (CONTROL),A     ;_/ \_  2
        CALL    PAUSE
        XOR     A
        OUT     (CONTROL),A
        CALL    PAUSE
        LD      A,MASK
        OUT     (DATA),A
        AND     A               ;CARRY Reset
        RET
;
;--= Standart Command "Write In DD/CGRAM" =--
;In:A=BYTE
;Out: CF=1 Error, CF=0 OK
WR_RAM
        CALL    BUSY
        JR      C,ERROR
;
;       PUSH    AF
;       LD      A,1
;       OUT     (CONTROL),A     ;RS=1
;       CALL    PAUSE
;       POP     AF
;
        OUT     (DATA),A        ;Out High Tetrade
        RLCA
        RLCA                    ; EN  R/W  RS
        RLCA                    ; B2  B1   B0
        RLCA
;
        PUSH    BC
        LD      C,A
        LD      A,5             ;  _ Write In DD/CGRAM 1
        OUT     (CONTROL),A     ;_/ \_  1
        CALL    PAUSE
        LD      A,1
        OUT     (CONTROL),A
        CALL    PAUSE
        LD      A,C
        POP     BC
;
        OUT     (DATA),A
        LD      A,5             ;  _ Write In DD/CGRAM 2
        OUT     (CONTROL),A     ;_/ \_  2
        CALL    PAUSE
        XOR     A
        OUT     (CONTROL),A
        CALL    PAUSE
        LD      A,MASK
        OUT     (DATA),A        ;Data Bus=Hi
        AND     A               ;CF Reset
        RET
ERROR
        LD      A,0
ERRORC  EQU     $-1
        OUT     (#FE),A
        INC     A
        AND     7
        LD      (ERRORC),A
        NOP
        NOP
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,ERROR
EXIT
        LD      SP,0
SPREAL  EQU     $-2
        XOR     A
        OUT     (DATA),A
        OUT     (CONTROL),A
        EI
        RET
;
;--= Function of Initialization LCD After Power On =--
;
INIT
        LD      A,(TSTADR)
        AND     A
        RET     NZ
        CALL    PAUSELONG
        LD      A,#30
        CALL    OUTPORT
;
        CALL    PAUSELONG
        LD      A,#30
        CALL    OUTPORT
;
        CALL    PAUSELONG
        LD      A,#30
        CALL    OUTPORT
;
        CALL    BUSY
        JP      C,ERROR
;
        LD      A,#20           ;Set 4bit Interface
        CALL    OUTPORT
;
        CALL    SET_FUNCTION    ;Display Setting
        XOR     A               ;Display Off
        LD      C,0             ;Cursor Off
        AND     A               ;Blink Off
        CALL    SHOW
        CALL    CLS             ;CLS Display
        LD      A,1             ;Increment
        LD      C,0             ;No Scroll
        CALL    INPUT_SET
        LD      A,123           ;Set Special Flag
        LD      (TSTADR),A
        RET
OUTPORT
        OUT     (DATA),A
        LD      A,4             ;Write In Command Reg
        OUT     (CONTROL),A
        CALL    PAUSE
        XOR     A
        OUT     (CONTROL),A
        CALL    PAUSE
        LD      A,MASK
        OUT     (DATA),A        ;Set DB4-DB7=High
        RET
BUSY
        PUSH    AF
        PUSH    BC
        LD      B,COUNTER
BUSY_LOOP
        LD      A,2             ;E=0, R/W=1
        OUT     (CONTROL),A
        CALL    PAUSE
        LD      A,6             ;E=1, R/W=1
        OUT     (CONTROL),A
        CALL    PAUSE
        IN      A,(DATA)        ;High Tetrada
        AND     #F0
        LD      C,A
        LD      A,2             ;E=0, R/W=1
        OUT     (CONTROL),A
        CALL    PAUSE
;
        LD      A,6
        OUT     (CONTROL),A
        CALL    PAUSE
        IN      A,(DATA)        ;Low Tetrada
        RRCA
        RRCA
        RRCA
        RRCA
        AND     #0F
        XOR     C
        LD      C,A
        LD      A,2
        OUT     (CONTROL),A
        CALL    PAUSE
        XOR     A
        OUT     (CONTROL),A
        CALL    PAUSE
;
        BIT     7,C             ;BUSY-Bit -> CF
        JR      Z,NOT_BUSY
        DJNZ    BUSY_LOOP
        POP     BC
        POP     AF
        SCF             ;Error: Time Out Of BUSY
        RET
NOT_BUSY
        POP     BC
        POP     AF
        AND     A
        RET
PAUSE
        PUSH    BC
        LD      B,DELAY
        DJNZ    $
        POP     BC
        RET
PAUSEB
        EI
        PUSH    BC
PAUSEB0
        HALT
        LD      A,#7F
        IN      A,(#FE)
        RRA
        JP      NC,EXIT
        LD      A,#BF
        IN      A,(#FE)
        RRA
        JR      NC,PAUSEB1
        DJNZ    PAUSEB0
        POP     BC
        DI
        RET
PAUSEB1
        LD      B,5
        HALT
        DJNZ    $-1
        POP     BC
        DI
        RET
PAUSELONG
        EI
        HALT
        HALT
        HALT
        DI
        RET
;=========================
; Other Procedures       /
;=======================/
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
PRIA
        CALL    WR_RAM
        LD      HL,TMPX
        INC     (HL)            ;Increment X
        LD      A,(HL)
        CP      SYMBOLS
        RET     NZ
        INC     HL
        BIT     6,(HL)
        LD      DE,#0000        ;Set New ColRow
        JP      NZ,PRIACOL
        INC     D
PRIACOL
        LD      (TMPX),DE
KOOR
        LD      A,(TMPY)
        AND     1               ;Col
        LD      C,#40
        JR      NZ,KOOR0
        LD      C,0
KOOR0
        LD      A,(TMPX)
        ADD     A,C             ;+Num Row
        LD      C,A             ;C=Addr DDRAM
        JP      SET_DDADR
TMPX    DEFB    0
TMPY    DEFB    0
TABLEC  DEFB    #41,#A0,#42,#A1,#E0,#45,#A3,#A4 ;Z      #80
        DEFB    #A5,#A6,#4B,#A7,#4D,#48,#4F,#A8 ;P
        DEFB    #50,#43,#54,#A9,#AA,#58,#E1,#E5 ;CHE    #90
        DEFB    #AC,#E2,#AD,#AE,#C4,#AF,#B0,#B1 ;JA
        DEFB    #61,#B2,#B3,#B4,#E3,#65,#B6,#B7 ;z      #A0
        DEFB    #B8,#B9,#BA,#BB,#BC,#BD,#6F,#BE ;p
        DEFB    #F0,#F1,#FF,#FF,#FF,#FF,#FF,#E7 ;       #B0
        DEFB    #E8,#E9,#EA,#EB,#EC,#ED,#EE,#EF
        DEFB    #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ;       #C0
        DEFB    #C8,#C9,#CA,#CB,#CC,#CD,#CE,#CF
        DEFB    #D0,#D1,#D2,#D3,#D4,#D5,#D6,#D7 ;       #D0
        DEFB    #D8,#D9,#DA,#DB,#DC,#DD,#DE,#DF
        DEFB    #70,#63,#BF,#79,#E4,#78,#E5,#C0 ;che    #E0
        DEFB    #C1,#E6,#C2,#C3,#C4,#C5,#C6,#C7 ;ja
        DEFB    #A2,#B5,#F2,#F3,#F4,#F5,#F6,#F7 ;       #F0
        DEFB    #F8,#F9,#FA,#FB,#FC,#FD,#FE,#FF
;
SET1
        DEFB    #1E,#10,#10,#1E,#11,#11,#1E,0   ;B
        DEFB    #0F,#11,#11,#0F,#05,#09,#11,0   ;Ja
        DEFB    #10,#10,#10,#1E,#11,#11,#1E,0   ;Znak
        DEFB    #11,#11,#13,#15,#19,#11,#11,0   ;I
        DEFB    #07,#09,#09,#09,#09,#09,#11,0   ;L
        DEFB    #15,#15,#0E,#04,#0E,#15,#15,0   ;Dj
        DEFB    #1F,#11,#11,#11,#11,#11,#11,0   ;P
        DEFB    #1E,#10,#10,#10,#10,#10,#10,0   ;G
SET2
        DEFB    #1F,#11,#11,#11,#11,#11,#1F,0
        DEFB    #00,#1F,#11,#11,#11,#11,#1F,0
        DEFB    #00,#00,#1F,#11,#11,#11,#1F,0
        DEFB    #00,#00,#00,#1F,#11,#11,#1F,0
        DEFB    #00,#00,#00,#00,#1F,#11,#1F,0
        DEFB    #00,#00,#00,#00,#00,#1F,#1F,0
        DEFB    #00,#00,#00,#00,#00,#00,#1F,0
        DEFB    #00,#00,#00,#00,#00,#00,#00,0
SET3
        DEFB    #18,#18,#18,#18,#18,#18,#18,0
        DEFB    #00,#18,#18,#18,#18,#18,#1B,0
        DEFB    #00,#00,#18,#18,#18,#1B,#1B,0
        DEFB    #00,#00,#00,#18,#1B,#1B,#1B,0
        DEFB    #00,#00,#00,#03,#1B,#1B,#1B,0
        DEFB    #00,#00,#03,#03,#03,#1B,#1B,0
        DEFB    #00,#03,#03,#03,#03,#03,#1B,0
        DEFB    #03,#03,#03,#03,#03,#03,#03,0
SET4
        DEFB    #10,#10,#10,#10,#10,#10,#10,0
        DEFB    #00,#10,#10,#14,#10,#10,#11,0
        DEFB    #00,#00,#10,#14,#14,#11,#11,0
        DEFB    #00,#00,#04,#14,#15,#11,#11,0
        DEFB    #00,#00,#04,#05,#15,#15,#11,0
        DEFB    #00,#04,#05,#05,#05,#15,#11,0
        DEFB    #00,#05,#05,#05,#05,#05,#15,0
        DEFB    #05,#05,#05,#05,#05,#05,#05,0
SET5
        DEFB    #1F,#1F,#1F,#1F,#1F,#1F,#1F,0
        DEFB    #00,#1F,#1F,#1F,#1F,#1F,#1F,0
        DEFB    #00,#00,#1F,#1F,#1F,#1F,#1F,0
        DEFB    #00,#00,#00,#1F,#1F,#1F,#1F,0
        DEFB    #00,#00,#00,#00,#1F,#1F,#1F,0
        DEFB    #00,#00,#00,#00,#00,#1F,#1F,0
        DEFB    #00,#00,#00,#00,#00,#00,#1F,0
        DEFB    #00,#00,#00,#00,#00,#00,#00,0

