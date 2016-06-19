[BITS 16]	;Tells the assembler that its a 16 bit code
[ORG 0x7C00]	;Origin, tell the assembler that where the code will
				;be in memory after it is been loaded

MOV SI, WelcomeTXT ;Store string pointer to SI
CALL PrintString	;Call print string procedure

MOV SI, BootTXT
CALL PrintString

MOV SI, A20BeforeTXT
CALL PrintString

CALL EnableA20

MOV SI, A20AfterTXT
CALL PrintString

call resetDrive

MOV SI, ResetDriveTXT
CALL PrintString

call readDrive

MOV SI, ReadDriveTXT
CALL PrintString

lgdt [gdtr]
mov eax, cr0
or al, 1
mov cr0, eax

jmp SYS_CODE_SEL:do_pm

JMP $ 		;Infinite loop, hang it here.

EnableA20:
	in al, 0x92
	test al, 2
	jnz after
	or al, 2
	and al, 0xFE
	out 0x92, al
	after:
	RET	

resetDrive:
		.reset:
			mov ah, 0
			int 13h
			jc .reset

readDrive:
	.read:
		mov ax,0
		mov es, ax
		mov bx, 8000h
		mov ah, 2
		mov al, 5
		mov ch, 0
		mov cl, 2
		mov dh, 0
		mov dl, 0
		int 13h
		jc .read

	
PrintCharacter:	;Procedure to print character on screen
	MOV AH, 0x0E	;Tell BIOS that we need to print one charater on screen.
	MOV BH, 0x00	;Page no.
	MOV BL, 0x07	;Text attribute 0x07 is lightgrey font on black background
	
	INT 0x10	;Call video interrupt
	RET		;Return to calling procedure

PrintString:	;Procedure to print string on screen
	next_character:	;Lable to fetch next character from string
		MOV AL, [SI]	;Get a byte from string and store in AL register
		INC SI		;Increment SI pointer
		OR AL, AL	;Check if value in AL is zero (end of string)
		JZ exit_function ;If end then return
		CALL PrintCharacter ;Else print the character which is in AL register
		JMP next_character	;Fetch next character from string
		exit_function:	;End label
		RET		;Return from procedure

;Data
WelcomeTXT db 'Welcome to timOS version 0.1',10,13,0 ; string to be null terminated
BootTXT db 'Booting...',10,13,0
A20BeforeTXT db 'Enabling A20 line...',10,13,0
A20AfterTXT db 'A20 line enabled',10,13,0
ResetDriveTXT db 'Floppy Drive reset',10,13,0
ReadDriveTXT db 'Read Floppy disk complete',10,13,0

[BITS 32]
do_pm:
	mov ax, SYS_DATA_SEL
	mov ds, ax
	mov es, ax
	mov ss, ax
	
	mov esp, 9000h
	
	jmp $
	;jpm 08000h

;----------------------------------
;             GDT
;----------------------------------
gdtr:
	dw gdt_end - gdt -1
	dd gdt

gdt:
	times 8 db 0
	SYS_CODE_SEL equ $-gdt
		dw 0xFFFF
		dw 0
		dw 0
		db 0x9A
		db 0xCF
		db 0
	
	SYS_DATA_SEL
		dw 0xFFFF
		dw 0
		dw 0
		db 0x9A
		db 0xCF
		db 0

gdt_end:

TIMES 510 - ($ - $$) db 0	;Fill the rest of sector with 0
DW 0xAA55			;Add boot signature at the end of bootloader
