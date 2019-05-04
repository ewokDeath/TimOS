[BITS 16]
;; [ORG 0x9000] ;; Boot Loader starting load address

Start:
	cli					; Clear all Interrupts

	mov	ax, 0x07c0
	mov	ds,ax
	mov	ax,0x9000
	mov	es,ax
	mov	cx,256
	xor	si,si
	xor	di,di
	rep	movsw
	jmp  far [0x9000 + go]

go:
	MOV SI, strWelcome
	call printStr

	MOV SI, strPrompt
	call printStr

	
	promptHandler:
		MOV AH, 0x00
		INT 0x16
		CMP AL, 0x0D
		JE returnHandler
		call printChar
		
		JMP promptHandler
	
	returnHandler:
		MOV SI, strCRLF
		call printStr
		MOV SI, strEnter
		call printStr
		MOV SI, strCRLF
		call printStr
		JMP promptHandler
	
	hlt					; halt the system

	%include "printFunctions.asm"
	
	strWelcome db 'Begin OS Boot Process',10,13,0
	strPrompt db 'TimOS> ',0
	strEnter db 'You pressed enter',0
	strCRLF db 10,13,0
	
	times 510 - ($-$$) db 0				; We have to be 512 bytes. Clear the rest of the bytes with 0

	dw 0xAA55					; Boot Signature