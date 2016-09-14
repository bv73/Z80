AT_Y	DEFB	0
AT_X	DEFB	0
ATTR	DEFB	0
LINE0	DEFB	#16,0,0,#11,6,#10,1,"<",#10,0
DISK	DEFM	" "
	DEFB	#10,1,">",#11,1,#10,5
	DEFM	" Title:"
	DEFB	#10,7
NAME_D	DEFM	"        "
	DEFB	#10,5
	DEFM	" Files"
	DEFB	#10,7
FILES	DEFM	"   "
	DEFB	#10,5,"(",#10,7
DELETE	DEFM	"   "
	DEFB	#10,5,")",0
LINE1	DEFB	#16,1,0,#11,5,#10,1
	DEFM	"Mark"
	DEFB	#10,0
MARK	DEFM	"    "
	DEFB	#10,1
	DEFM	"s <"
MASK	DEFB	#10,0,3,3,3,3,3,3,3,3,#10,1,"-",#10,0,3,#10,1
	DEFM	"> Free"
	DEFB	#10,0
FREE	DEFM	"    "
	DEFB	#10,1,"s",0
LINE22	DEFB	#16,22,0,#11,5,#10,1
	DEFM	"Size"
	DEFB	#10,0
SIZE	DEFM	"   "
	DEFB	#10,1
	DEFM	"s S"
	DEFB	#10,0
START	DEFM	"     "
	DEFB	#10,1," ","L",#10,0
LENGTH	DEFM	"     "
	DEFB	#10,1
	DEFM	" trk"
	DEFB	#10,0
TREK	DEFM	"  "
	DEFB	#10,1," ","s",#10,0
SECTOR	DEFM	"  "
	DEFB	0
LINE23	DEFB	#16,23,0,#11,1,#10,5
	DEFM	"    <Perfect Commander V1.0>    "
	DEFB	0
NAME_T	DEFB	#11
NAMPAP	DEFB	5,#10
NAMINK	DEFB	1
NAME	DEFM	"          "
	DEFB	0
SIGN	DEFM	"PC-boot"
