AS=nasm
ASFLAGS=-fbin

OBJDIR="obj/mbr"
SRCDIR="src/mbr"
LOADERNAME="loader"
S2OBJDIR="obj/stage2"
S2SRCDIR="src/stage2"
STAGE2NAME="stage2"
ISOFILE="cd.iso"

if [ "-g" == "$1" ]; then
	ASDEBUG=" -g "
else
	ASDEBUG=""
fi

if [ "clean" == "$1" ]; then
	rm -r obj
	rm -r isofs
	rm ${ISOFILE}
	exit
fi

function _ {
	echo $@
	$@
}

mkdir -p ${OBJDIR} ${S2OBJDIR}

_ ${AS} ${ASDEBUG} ${ASFLAGS} -o ${OBJDIR}/${LOADERNAME}.o ${SRCDIR}/${LOADERNAME}.asm
_ ${AS} ${ASDEBUG} ${ASFLAGS} -o ${S2OBJDIR}/${STAGE2NAME}.o ${S2SRCDIR}/${STAGE2NAME}.asm

_ dd bs=1024 count=1440 if=/dev/zero of=fdd.img
_ mkfs.msdos fdd.img
_ dd bs=512 count=1 if=obj/mbr/loader.o of=fdd.img conv=notrunc
_ dd bs=512 count=2 seek=1 if=obj/stage2/stage2.o of=fdd.img conv=notrunc

