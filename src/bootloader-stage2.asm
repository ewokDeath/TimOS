[BITS 16]

;; include various helper macros
%include "bios/floppy.asm"
%include "common.asm"


Start:
	cli					; Clear all Interrupts

	mov	ax, 0x07c0
	mov	ds, ax
	mov	ax, 0x9000
	mov	es, ax
	mov	cx, 256
	xor	si, si
	xor	di, di
	rep	movsw ;; effectively copies 07C0h(DS):0000h(SI) to 9000h(ES):0000h(DI) 256 times (CX), word copies mean 512 bytes total

	mov	ds, ax
	mov	ss, ax

	jmp 0x9000:go

go:
	mov si, strLoading
	call printStr

    resetFloppy

    mov si, strFloppyReset
    call printStr

    killBL

    %include "printFunctions.asm"

    ;; end with a data block
	strLoading db 'Stage 1 Bootloader running from to 0x9000:0x0000',10,13,0
	strFloppyReset db 'Floppy drive reset successfully',10,13,0

	times 510 - ($-$$) db 0				; We have to be 512 bytes. Clear the rest of the bytes with 0

	dw 0xAA55					; Boot Signature