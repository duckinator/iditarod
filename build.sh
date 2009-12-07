AS=nasm
ASFLAGS=-fbin

OBJDIR="obj/boot"
SRCDIR="src/boot"
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

_ ${AS} ${ASDEBUG} ${ASFLAGS} -o ${OBJDIR}/${LOADERNAME}.o ${SRCDIR}/${LOADERNAME}.asm

_ dd bs=1024 count=1440 if=/dev/zero of=fdd.img
_ mkfs.msdos fdd.img
_ dd bs=512 count=1 if=obj/boot/loader.o of=fdd.img conv=notrunc

