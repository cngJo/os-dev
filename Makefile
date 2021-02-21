build: build-bootloader

build-bootloader:
	nasm boot_sect.asm -f bin -o boot_sect.bin

run: build run-qemu

run-bochs:
	bochs -q

run-qemu:
	qemu-system-i386 boot_sect.bin