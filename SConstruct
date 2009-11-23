# vim: syntax=python

import os

#os.system("python ./tools/buildid.py > ./include/buildid.h")

arch = ARGUMENTS.get('arch', 'i386')
buildtype = ARGUMENTS.get('buildtype', 'debug')
ansi = ARGUMENTS.get('ansi', 'no')
strict = ARGUMENTS.get('strict', 'yes')

distreq = []

env = Environment(
	OBJPREFIX='',
	OBJSUFFIX='.o',
	SHOBJPREFIX='',
	SHOBJSUFFIX='.sho',
	PROGPREFIX='',
	PROGSUFFIX='.exe',
	LIBPREFIX='',
	LIBSUFFIX='.lib',
	SHLIBPREFIX='',
	SHLIBSUFFIX='.shl',
	CC='gcc',
    CCFLAGS=['-m32', '-nostdinc', '-ffreestanding', '-I', 'include', '-DARCH=\'"%s"\'' % arch, '-D%s' % arch.upper()],
	AS='nasm',
	ASFLAGS=['-felf32'],
	LINK='ld',
	LINKFLAGS=['-melf_i386', '-nostdlib'],
)

if buildtype == 'debug':
	env.Append(CCFLAGS=['-g', '-DDEBUG'], LINKFLAGS=['-g'])

if ansi == 'yes':
	env.Append(CCFLAGS=['-ansi'])

if strict == 'yes':
	env.Append(CCFLAGS=['-Werror'])

Export('env', 'arch', 'buildtype', 'distreq')

SConscript('src/SConscript')
SConscript('iso/SConscript', distreq)

