NAME= semplice

BUILD_TYPE := debug

QEMU:= qemu-system-i386

AS=nasm
ASFLAGS=-fbin

LOADERNAME="loader"
STAGE2NAME="stage2"

LOADERDIR="src/mbr"
STAGE2DIR="src/stage2"

FDDFILE="${NAME}.img"
ISOFILE="${NAME}.iso"



include terminal.mk

NAME= semplice

BUILD_TYPE := debug

QEMU:= qemu-system-i386

SOURCE_SUFFIXES := '(' -name '*.c' -o -name '*.asm' ')'
SRCFILES := $(shell find 'src' ${SOURCE_SUFFIXES})
OBJFILES := $(patsubst %.asm, %.o, $(patsubst %.c, %.o, $(SRCFILES)))

#CFLAGS=-std=c99 -Wall -Wextra -nostdlib -nostartfiles -nodefaultlibs -fno-builtin -Iinclude -Iinclude/kernel -m32
override CFLAGS += -std=c99 -Wall -nostdinc -ffreestanding  -fno-stack-protector -fno-builtin -g -Iinclude -Iinclude/kernel -fdiagnostics-show-option -Wextra -Wunused -Wformat=2 -Winit-self -Wmissing-include-dirs -Wstrict-overflow=4 -Wfloat-equal -Wwrite-strings -Wconversion -Wundef -Wtrigraphs -Wunused-parameter -Wunknown-pragmas -Wcast-align -Wswitch-enum -Waggregate-return -Wmissing-noreturn -Wmissing-format-attribute -Wpacked -Wredundant-decls -Wunreachable-code -Winline -Winvalid-pch -Wdisabled-optimization -Wsystem-headers -Wbad-function-cast -Wunused-function -m32 -gdwarf-2 -pedantic-errors

override LDFLAGS += -nostdlib -g -melf_i386

#override ASFLAGS += -felf32

ifeq ($(BUILD_TYPE),debug)
	ASDEBUG="-g"
endif

include config.mk

all: config.mk floppy

config.mk:
	@printf "You will need to copy config.mk.dist to config.mk and edit it, first.\n"
	@false

-include $(find ./src -name '*.d')
%.o: %.c
	@$(call STATUS,"COMPILE ",$^)
	@${CC} ${CFLAGS} -MMD -MP -MT "$*.d $*.o"  -c $< -o $@

%.o: %.asm
	@$(call STATUS,"ASSEMBLE",$^)
	@${ASM} ${ASFLAGS} ${ASDEBUG} -o $@ $<

fdd: floppy
floppy: ${OBJFILES}
	@$(call STATUS,"FDD IMG ",$^)
	@dd bs=1024 count=1440 if=/dev/zero of=${FDDFILE}
	@mkfs.msdos ${FDDFILE}
	@dd bs=512 count=1 if=${LOADERDIR}/${LOADERNAME}.o of=${FDDFILE} conv=notrunc
	@dd bs=512 count=2 seek=1 if=${STAGE2DIR}/${STAGE2NAME}.o of=${FDDFILE} conv=notrunc

qemu: qemu-fdd

qemu-hdd: floppy
	qemu-system-i386 -vga std -serial stdio -hda ${FDDFILE}

qemu-fdd: floppy
	qemu-system-i386 -vga std -serial stdio -fda ${FDDFILE}

qemu-monitor: floppy
	qemu-system-i386 -monitor stdio -cdrom ${FDDFILE}

clean:
	@find ./src -name '*.o'   -delete
	@find ./src -name '*.lib' -delete
	@find ./src -name '*.exe' -delete
	@find ./src -name '*.d'   -delete
	@rm -f tools/bootinfo
	@rm -f ${FDDFILE}

.PHONY: all kernel-libs iso clean test qemu qemu-monitor bochs todo sloc clean
