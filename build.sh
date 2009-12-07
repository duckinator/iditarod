AS=nasm
ASFLAGS=-fbin

OBJDIR="obj/boot"
SRCDIR="src/boot"
ISOBOOT="boot"
LOADERNAME="loader"
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

mkdir -p obj/boot
mkdir -p isofs/${ISOBOOT}

_ ${AS} ${ASDEBUG} ${ASFLAGS} -o ${OBJDIR}/${LOADERNAME}.o ${SRCDIR}/${LOADERNAME}.asm

_ cp ${OBJDIR}/${LOADERNAME}.o isofs/${ISOBOOT}/${LOADERNAME}

_ genisoimage -r -b ${ISOBOOT}/${LOADERNAME} -no-emul-boot -boot-load-size 4 -o ${ISOFILE} isofs
