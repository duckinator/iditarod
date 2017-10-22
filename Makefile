NAME ?= semplice

BUILD_TYPE ?= debug

LOADERNAME := "loader"
STAGE2NAME := "stage2"

LOADERDIR := "src/mbr"
STAGE2DIR := "src/stage2"

HDDFILE :="${NAME}.img"

SOURCE_SUFFIXES := '(' -name '*.c' -o -name '*.asm' ')'
SRCFILES := $(shell find 'src' ${SOURCE_SUFFIXES})
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

qemu: qemu-hdd

qemu-hdd: disk-image
	qemu-system-i386 -vga std -serial stdio -hda ${HDDFILE}

clean:
	@find ./src -name '*.o'   -delete
	@find ./src -name '*.lib' -delete
	@find ./src -name '*.exe' -delete
	@find ./src -name '*.d'   -delete
	@rm -f ${HDDFILE}

.PHONY: all clean disk-image qemu qemu-hdd clean
