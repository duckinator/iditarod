# vim: syntax=python

import os

arch = ARGUMENTS.get('arch', 'i386')
buildtype = ARGUMENTS.get('buildtype', 'debug')
ansi = ARGUMENTS.get('ansi', 'no')
strict = ARGUMENTS.get('strict', 'yes')

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
	CC='gcc',
	CCFLAGS=['-nostdinc', '-g', '-I', 'include', '-I', '-D', '%s' % arch.upper()],
	AS='nasm',
	ASFLAGS=['-fbin'],
	LINK='ld',
	LINKFLAGS=['-nostdlib', '-melf_i386']
)

if buildtype == 'debug':
	env.Append(CCFLAGS=['-g', '-D', 'DEBUG'], LINKFLAGS=['-g'])

Export('env', 'arch', 'buildtype', 'distreq')

SConscript('src/SConscript')

