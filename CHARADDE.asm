;A - Char
CHARAD	LD	L,A
	LD	H,0
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	LD	DE,(23606)
	ADD	HL,DE
;HL - Address of char in znakogen.
	RET
