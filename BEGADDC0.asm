;D - YCOOR [0,191]
;E - XCOOR [0,31]
BEGADD	LD	A,D
	AND	#38
	ADD	A,A
	ADD	A,A
	ADD	A,E
	LD	E,A
	LD	A,D
	RRA
	RRA
	RRA
	AND	#18
	LD	C,A
	LD	A,D
	AND	#07
	ADD	A,C
	ADD	A,#40
	LD	D,A
;DE - Address
	RET
