[BITS 16]	;Tells the assembler that its a 16 bit code
[ORG 0x7C00]	;Origin, tell the assembler that where the code will
				;be in memory after it is been loaded

Start:
	cli					; Clear all Interrupts
	
	MOV AL, 0x46    ; Print the character "f"
	call printChar

	MOV AL, 'Z'    ; Print the character "0"
	call printChar

	MOV SI, strWelcome
	call printStr
	
	hlt					; halt the system

	; 
	printChar:
		MOV AH, 0x0E	;Tell BIOS that we need to print one character on screen.
		MOV BH, 0x00	;Page no.
		MOV BL, 0x07	;Text attribute 0x07 is light grey font on black background
		INT 0x10
		RET
	
	printStr:
		nextChar:
			MOV AL, [SI]
			INC SI
			OR  AL, AL
			JZ exitFunc
			call printChar
			JMP nextChar
		exitFunc:
		RET
		
	strWelcome db 'this is so',13,10,'me text',0
	
	times 510 - ($-$$) db 0				; We have to be 512 bytes. Clear the rest of the bytes with 0

	dw 0xAA55					; Boot Signature