
filename = write
flags = -f bin -o

all : $(filename).asm
	nasm $(filename).asm $(flags) $(filename).bin

qemu : $(filename).bin
	qemu-system-i386 $(filename).bin
