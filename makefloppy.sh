dd bs=1024 count=1440 if=/dev/zero of=fdd.img
mkfs.msdos fdd.img
dd bs=512 count=1 if=obj/loader of=fdd.img conv=notrunc
dd bs=512 count=2 seek=1 if=obj/semplice/stage2 of=fdd.img conv=notrunc

