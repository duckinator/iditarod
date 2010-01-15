# vim: syntax=python

import os

arch = ARGUMENTS.get('arch', 'i386')
buildtype = ARGUMENTS.get('buildtype', 'debug')
ansi = ARGUMENTS.get('ansi', 'no')
strict = ARGUMENTS.get('strict', 'yes')

floppy = Builder(action='./makefloppy.sh')

distreq = []

mbrenv = Environment(
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
	CC='gcc',
	CCFLAGS=['-nostdinc', '-g', '-I', 'include', '-I', '-D', '%s' % arch.upper()],
	AS='nasm',
	ASFLAGS=['-fbin'],
	LINK='ld',
	LINKFLAGS=['-nostdlib', '-melf_i386'],
	BUILDERS={'Floppy': floppy}
)

stage2env = Environment(
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
	CC='gcc',
	CCFLAGS=['-nostdinc', '-g', '-I', 'include', '-I', '-D', '%s' % arch.upper()],
	AS='nasm',
	ASFLAGS=['-fbin'],
	LINK='ld',
	LINKFLAGS=['-nostdlib', '-melf_i386'],
	BUILDERS={'Floppy': floppy}
)

if buildtype == 'debug':
  mbrenv.Append(CCFLAGS=['-g', '-D', 'DEBUG'], LINKFLAGS=['-g'])
  stage2env.Append(CCFLAGS=['-g', '-D', 'DEBUG'], LINKFLAGS=['-g'])

Export('mbrenv', 'stage2env', 'arch', 'buildtype', 'distreq')

SConscript('src/SConscript')

mbrenv.Floppy('fdd.img', distreq)
