
SOURCE_DIR = .

SOURCES = $(wildcard $(SOURCE_DIR)/*.c)
OBJECTS = $(addprefix ./, $(notdir $(SOURCES:.c=.o)))
CC = i686-elf-gcc
CFLAGS = -std=gnu99 -ffreestanding -Wall -Wextra
EFLAGS = -ffreestanding -O2 -nostdlib boot.o
YUC = yuc.bin

all: iso

iso: yufiles yuos.bin
	cp yuos.bin isodir/boot/
	grub-mkrescue -o yuos.iso isodir

yuos.bin: $(OBJECTS)
	$(CC) -T linker.ld -o $@ $(EFLAGS) kernel.o $^ -lgcc

yufiles:
	$(YUC) kernel.yu --baremetal -o kernel.o --usecc=$(CC) --includeo $(OBJECTS)

%.o: $(SOURCE_DIR)/%.c
	$(CC) -c $(CFLAGS) -o $@ $<