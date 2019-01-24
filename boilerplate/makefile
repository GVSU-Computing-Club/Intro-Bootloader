
filename = boot
flags = -f bin -o
gdbflags = -q -x
debug = -s -S

all : $(filename).asm
	nasm $(filename).asm $(flags) $(filename).bin

qemu : $(filename).bin
	qemu-system-i386 $(filename).bin

debug : $(filename).bin
	qemu-system-i386 $(debug) $(filename).bin

gdb :
	gdb $(gdbflags) ../gdbcommands.txt
