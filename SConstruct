# vim: syntax=python

import os

arch = ARGUMENTS.get('arch', 'i386')
buildtype = ARGUMENTS.get('buildtype', 'debug')
ansi = ARGUMENTS.get('ansi', 'no')
strict = ARGUMENTS.get('strict', 'yes')

floppy = Builder(action='./makefloppy.sh')

distreq = []

env = Environment(
	ENV = {'PATH' : os.environ['PATH']},
	OBJPREFIX='',
	OBJSUFFIX='',
	SHOBJPREFIX='',
	SHOBJSUFFIX='.sho',
	PROGPREFIX='',
	PROGSUFFIX='.exe',
	LIBPREFIX='',
	LIBSUFFIX='.lib',
	SHLIBPREFIX='',
	SHLIBSUFFIX='.shl',
	AS='nasm',
	ASFLAGS=['-fbin'],
	LINK='ld',
	LINKFLAGS=['-nostdlib', '-melf_i386'],
	BUILDERS={'Floppy': floppy}
)

Export('env', 'arch', 'buildtype', 'distreq')

SConscript('src/SConscript')

env.Floppy('fdd.img', distreq)
