# vim: syntax=python

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
    CCFLAGS=['-m32', '-nostdinc', '-ffreestanding', '-I', 'include', '-D', '%s' % arch.upper()],
	AS='nasm',
	ASFLAGS=['-felf32'],
	LINK='ld',
	LINKFLAGS=['-melf_i386', '-nostdlib'],
)

if buildtype == 'debug':
	env.Append(CCFLAGS=['-g', '-DDEBUG'], LINKFLAGS=['-g'])

Export('env', 'arch', 'buildtype', 'distreq')

SConscript('src/SConscript')

SConscript('iso/SConscript')

