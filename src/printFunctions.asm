printChar:
    MOV AH, 0x0E	;Tell BIOS that we need to print one character on screen.
	MOV BH, 0x00	;Page no.
	MOV BL, 0x07	;Text attribute 0x07 is light grey font on black background
	INT 0x10
	RET
	
printStr:
    ; POP SI

	nextChar:
		MOV AL, [SI]
		INC SI
		OR  AL, AL
		JZ exitFunc
		call printChar
		JMP nextChar
	exitFunc:
		RET
	