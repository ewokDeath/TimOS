$(info Starting OS build)

D_BIN = .\bin
D_SRC = .\src
D_RES = .\res

all:	bt.bin

bt.bin:
	$(info Build Bootloader)
	nasm $(D_SRC)\bt.asm -f bin -o $(D_BIN)\bt.bin
	copy $(D_RES)\BlankFloppy.img $(D_BIN)\test.img
	partcopy $(D_BIN)\bt.bin $(D_BIN)\test.img 0d 511d
