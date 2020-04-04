$(info Starting OS build)

D_BIN  = .\bin
D_SRC  = .\src
D_RES  = .\res
OS_NAME = TimOS

all:	bt.bin

bt.bin:
	$(info Build Bootloader)
	nasm $(D_SRC)\bootloader-stage1.asm -f bin -o $(D_BIN)\bootloader-stage1.bin -i'c:\dev\timos\src\' -g
	nasm $(D_SRC)\bootloader-stage2.asm -f bin -o $(D_BIN)\bootloader-stage2.bin -i'c:\dev\timos\src\' -g
	copy $(D_RES)\BlankFloppy.img $(D_BIN)\$(OS_NAME)-Bootloader.img

	cmd /c copy /b .\bin\bootloader-stage1.bin+.\bin\bootloader-stage2.bin .\bin\$(OS_NAME)-Bootloader.img

clean:
	rm .\bin\\*.bin