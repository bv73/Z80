CRC_16	EX	DE,HL		; вход:	BC=Размер блока
	LD	HL,0		;	HL=Адрес наЧала	блока
	PUSH	BC		;выход: DE=CRC16 :)
	LD	A,(DE)		;	BC=0
	XOR	H		;	HL=Адрес:Блок+Лен.
	LD	H,A
	SCF
	RL	C
CRC_161 ADD	 HL,HL
	JR	NC,CRC_162	; переход если 15 бит =0
	LD	A,H		; h=h xor #10
	XOR	#10
	LD	H,A
	LD	A,L		; l=l xor #21
	XOR	#21
	LD	L,A
CRC_162 RL	 C
	JR	NZ,CRC_161
	POP	BC
	INC	DE
	DEC	BC
	LD	A,B
	OR	C
	JP	NZ,CRC_16+4
	EX	DE,HL
	RET
