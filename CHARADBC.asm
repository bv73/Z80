;A - Char
CHARAD	LD	L,A
	LD	H,0
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	LD	BC,(23606)
	ADD	HL,BC
;HL - Address of char in znakogen.
	RET
