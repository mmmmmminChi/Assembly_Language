	AREA	LOWERUPPER,CODE,READONLY
SWI_WriteC EQU &0 
SWI_Write0 EQU &2 
SWI_ReadC  EQU &4 
SWI_Exit   EQU &11
SWI_Clock  EQU &61
SWI_Time   EQU &63

	ENTRY
START	ADRL	r0,TEXT3
	SWI     SWI_Write0
	ADR	r0,TEXT
        SWI     SWI_Write0
	ADRL	r1,TEXT2
	ADRL	r2,TEXT_1

LOOP	SWI     SWI_ReadC
	SWI     SWI_WriteC
	CMP	r0,#&55
	BEQ	UPPER
	CMP	r0,#&4C
	BEQ	LOWER
	BNE	RETRY

;<<Retry : when user input neither U/L>>
RETRY	ADRL	r0,TEXT3
	SWI     SWI_Write0
	ADR	r0,TEXT5
        SWI     SWI_Write0
	BAL	LOOP

;<<Again : when all process completed>>
AGAIN	ADRL	r0,TEXT7
	SWI     SWI_Write0
	SWI     SWI_ReadC
	SWI     SWI_WriteC
	CMP	r0,#&59
	BEQ	START
	CMP	r0,#&4E
	BEQ	EXIT
	BNE	RETRY
	
;<<Uppercase>>
UPPER	LDRB	r0,[r2],#1
	CMP	r0,#&61
	BLT	STORE_U
	CMP	r0,#&7A
	BGT	STORE_U
	SUB	r0,r0,#&20
	BAL	STORE_U
	

;<<Lowercase>>
LOWER	LDRB	r0,[r2],#1
	CMP	r0,#&41
	BLT	STORE_L
	CMP	r0,#&5A
	BGT	STORE_L
	ADD	r0,r0,#&20
	BAL	STORE_L

;<<Store : store changed characters>>
STORE_U	STRB	r0,[r1],#1
	CMP	r0,#0
	BNE	UPPER
	BAL	PRINT

STORE_L	STRB	r0,[r1],#1
	CMP	r0,#0
	BNE	LOWER
	BAL	PRINT

PRINT	ADR	r0,TEXT3
	SWI     SWI_Write0
	ADR	r0,TEXT6
	SWI	SWI_Write0
	ADR	r0,TEXT2
	SWI	SWI_Write0
	BAL	AGAIN

EXIT	SWI	SWI_Exit
	



TEXT	=	"Origin : AbCdEFghijK@#$%&()",&0a,&0d,"Lower(enter L) or Upper(enter U) : ",&0d,0
TEXT2	=	"                    ",&0a,&0d,0
TEXT3	=	"",&0a,&0d,0
TEXT5	=	"Failed, please try again !",&0a,&0d,0
TEXT6	=	"Result : ",0
TEXT7	=	"Try again ?( Y / N ) : ",&0d,0

TEXT_1	=	"AbCdEFghijK@#$%&()",&0a,&0d,0


	END