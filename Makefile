
SOURCE_DIR = .

SOURCES = $(wildcard $(SOURCE_DIR)/*.c)
OBJECTS = $(addprefix ./, $(notdir $(SOURCES:.c=.o)))
CC = i686-elf-gcc
AS = i686-elf-as
CFLAGS = -std=gnu99 -ffreestanding -Wall -Wextra
EFLAGS = -ffreestanding -O2 -nostdlib boot.o
AKUC = akuc.bin

all: bootloader akufiles iso

SOURCES = $(wildcard $(SOURCE_DIR)/*.c)

bootloader:
	$(AS) boot.s -o boot.o

iso: akuos.bin
	cp grub.cfg isodir/boot/grub/
	cp akuos.bin isodir/boot/
	grub-mkrescue -o akuos.iso isodir

akuos.bin: $(OBJECTS)
	$(CC) -T linker.ld -o $@ $(EFLAGS) kernel.o $< -lgcc

akufiles:
	$(AKUC) kernel.aku --baremetal -o kernel.o --usecc=$(CC) --includeo $(OBJECTS)

%.o: $(SOURCE_DIR)/%.c
	$(CC) -c $(CFLAGS) -o $@ $<

clean:
	rm *.o
	rm *.bin
	rm *.iso