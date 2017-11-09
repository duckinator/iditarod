NAME ?= iditarod

BUILD_TYPE ?= debug

LOADERNAME := "loader"
STAGE2NAME := "stage2"

LOADERDIR := "src/mbr"
STAGE2DIR := "src/stage2"

HDDFILE :="${NAME}.img"

SOURCE_SUFFIXES := '(' -name '*.c' -o -name '*.asm' ')'
#SRCFILES := $(shell find 'src' ${SOURCE_SUFFIXES})
SRCFILES := src/mbr/loader.asm src/eltorito/eltorito.asm $(shell find src/stage2/ ${SOURCE_SUFFIXES})
OBJFILES := $(patsubst %.asm, %.o, $(patsubst %.c, %.o, $(SRCFILES)))

override CFLAGS += -std=c11 -m32 -O0 -pedantic-errors -nostdinc -nostdlib -nostartfiles -nodefaultlibs -ffreestanding -fno-stack-protector -fno-stack-protector -Wall -Wextra -Wunused -Wconversion -Wundef -Wunused-parameter -Wswitch-enum -Waggregate-return -Wpacked -Wredundant-decls -Wunreachable-code -Winline -Wsystem-headers -Wbad-function-cast -Wunused-function

override LDFLAGS += -nostdlib -g -melf_i386

override ASFLAGS += -fbin

include config.mk

all: config.mk disk-image

config.mk:
	@printf "You will need to copy config.mk.dist to config.mk and edit it, first.\n"
	@false

%.o: %.c
	${CC} ${CFLAGS} -c $< -o $@

%.o: %.asm
	${AS} ${ASFLAGS} -o $@ $<

disk-image: ${OBJFILES}
	@printf "Generating disk image."
	@dd bs=1024 count=1440 if=/dev/zero of=${HDDFILE}
	@mkfs.msdos ${HDDFILE}
	@dd bs=512 count=1 if=${LOADERDIR}/${LOADERNAME}.o of=${HDDFILE} conv=notrunc
	@dd bs=512 count=2 seek=1 if=${STAGE2DIR}/${STAGE2NAME}.o of=${HDDFILE} conv=notrunc

isofs: ${OBJFILES}
	mkdir -p isofs/boot
	cp src/mbr/loader.o isofs/boot/loader.bin
	cp src/eltorito/eltorito.o isofs/boot/eltorito.bin
	cp src/stage2/stage2.o isofs/boot/stage2.bin

iso: ${NAME}.iso

${NAME}.iso: isofs
	${ISOFSTOOL} -R -J -c boot/bootcat \
		-b boot/eltorito.bin -hard-disk-boot -boot-load-size 4 \
		-o ./${NAME}.iso ./isofs

qemu: qemu-hdd

qemu-hdd: disk-image
	qemu-system-i386 -vga std -serial stdio -hda ${HDDFILE}

qemu-cdrom: iso
	qemu-system-i386 -vga std -serial stdio -cdrom ${NAME}.iso

clean:
	@find ./src -name '*.o'   -delete
	@find ./src -name '*.lib' -delete
	@find ./src -name '*.exe' -delete
	@find ./src -name '*.d'   -delete
	@rm -f ${HDDFILE}
	@rm -f ./${NAME}.iso
	@rm -rf ./isofs

.PHONY: all clean disk-image iso qemu qemu-hdd clean
