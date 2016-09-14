;D - YCOOR
;E - XCOOR
ADDATT	LD	B,0
	LD	C,E
	LD	H,B
	LD	L,D
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,HL
	ADD	HL,BC
	LD	BC,#5800
	ADD	HL,BC
;HL - Address for out of first ATTR
	RET
