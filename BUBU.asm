
	DEFB	#E0,10,14,15,#96,#AF,#B4,#B9,#BE,#BD,#C5,9
	DEFB	"L",#C4,4,#C5,",",#85,0,8,12,"%*U"
	DEFB	"\ik",9,"RE",#D4,#A4,"/",9,"PO",#D0,#94,#9A
	DEFB	"RE",#D4
	DEFB	"EX",#D8
	DEFB	"JP "
	DEFB	"(K",#A9
	DEFB	"LD "
	DEFB	"SP,"
	DEFB	#CB,9,"J"
	DEFB	#D0,"$",#C1
	DEFB	#D7,#BA,"JP ",#D7
	DEFB	#A0,"OUT (V),"
	DEFB	#C1,"IN	A,(V",#A9
	DEFB	"EX (SP),",#CB
	DEFB	"EX DE,H",#CC,"D"
	DEFB	#C9,"E",#C9
	DEFB	9,"CAL",#CC,"$"
	DEFB	#C1,#D7,"7"
	DEFB	9,"PUS",#C8,#94
	DEFB	#81,"CALL ",#D7,",",#81
	DEFB	#D6,9,"RS",#D4,#BA
	DEFB	"0",#B0,"0"
	DEFB	#B8,"1",#B0
	DEFB	"1",#B8,"2"
	DEFB	#B0,"2",#B8
	DEFB	"3",#B0,"3"
	DEFB	#B8,":RL",#C3,"RR",#C3,"R",#CC,"R",#D2
	DEFB	"SL",#C1
	DEFB	"SR",#C1
	DEFB	"SL",#C9
	DEFB	"SR",#CC
	DEFB	1,#A0,#85
	DEFB	9,"BI"
	DEFB	#D4,#1C,#C5
	DEFB	9,"RE"
	DEFB	#D3,#1C,#C5
	DEFB	9,"SE"
	DEFB	#D4,#1C,#C5
	DEFB	0,#B4,#BB
	DEFB	#C3,#D1,#DE
	DEFB	#E1,#E9,#F0
	DEFB	#1B,"L",#C4
	DEFB	"C",#D0,"I"
	DEFB	#CE,"O",#D4
	DEFB	6,#9A,#C9
	DEFB	#C4,"I",#D2
	DEFB	"D",#D2,#00
	DEFB	8,"%2akosx6",9,"J",#D2
	DEFB	"$",#C1,#AA
	DEFB	#9A,"NO"
	DEFB	#D0,"EX	AF,AF"
	DEFB	#A7,"DJNZ "
	DEFB	#AA,"JR	",#AA,"7"
	DEFB	9,"L",#C4
	DEFB	#0C,#C1,#D7
	DEFB	#01,"ADD ",#CB
	DEFB	#CC,9,"L"
	DEFB	#C4,#BA,"(BC)"
	DEFB	",",#C1,"A,(BC)"
	DEFB	#A9,"(DE),"
	DEFB	#C1,"A,(DE",#A9,"(W),"
	DEFB	#CB,"K,(W",#A9
	DEFB	"(W),",#C1,"A,(W"
	DEFB	#A9,"/",9
	DEFB	"IN",#C3
	DEFB	#8C,9,"DE",#C3,#8C
	DEFB	9,"IN"
	DEFB	#C3,#84,9
	DEFB	"DE",#C3
	DEFB	#84,9,"L"
	DEFB	#C4,4,#C1
	DEFB	#D6,#BA,"R"
	DEFB	"LC",#C1
	DEFB	"RRC"
	DEFB	#C1,"RL"
	DEFB	#C1,"RR"
	DEFB	#C1,"DA"
	DEFB	#C1,"CP"
	DEFB	#CC,"SC"
	DEFB	#C6,"CC"
	DEFB	#C6,9,"I"
	DEFB	#CE,4,#C1
	DEFB	"(C",#A9
	DEFB	1,"OUT ("
	DEFB	"C",#A9,#C4
	DEFB	"?",1,"SBC "
	DEFB	#CB,#CC,1
	DEFB	"ADC"
	DEFB	" ",#CB,#CC
	DEFB	9,"L",#C4
	DEFB	"/",1,"("
	DEFB	"W",#A9,#CC
	DEFB	12,#C1,"("
	DEFB	"W",#A9,#81
	DEFB	"NE",#C7
	DEFB	1,"RE"
	DEFB	#D4,#17,#81
	DEFB	#CE,#81,#C9
	DEFB	9,"I",#CD
	DEFB	#9A,#B0,#AD
	DEFB	#B1,#B2,">"
	DEFB	#8A,"RR"
	DEFB	#C4,"RL"
	DEFB	#C4,9,"L"
	DEFB	#C4,#9A,"I"
	DEFB	",",#C1,"R"
	DEFB	",",#C1,"A"
	DEFB	",",#C9,"A"
	DEFB	",",#D2
	DEFB	6,15,#15,#1B
	DEFB	#22,"-",#C2
	DEFB	#C3,#C4,#C5
	DEFB	#C8,#CC,"("
	DEFB	"Q",#A9,#C1
	DEFB	"B",#C3,"D"
	DEFB	#C5,#CB,"S"
	DEFB	#D0,"B",#C3
	DEFB	"D",#C5,#CB
	DEFB	"A",#C6,#B0
	DEFB	#B1,#B2,#B3
	DEFB	#B4,#B5,#B6
	DEFB	#B7,"N",#DA
	DEFB	#DA,"N",#C3
	DEFB	#C3,"P",#CF
	DEFB	"P",#C5,#D0
	DEFB	#CD,"ADD A"
	DEFB	#AC,"ADC A"
	DEFB	#AC,"SU"
	DEFB	"B",#A0,"SBC "
	DEFB	"A",#AC,"A"
	DEFB	"ND",#A0
	DEFB	"XOR"
	DEFB	#A0,"OR"
	DEFB	#A0,"CP",#A0
	DEFB	"HAL",#D4
	DEFB	"H",#CC,"I",#D8,"I",#D9


