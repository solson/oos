# vim: syntax=python

import os

arch = ARGUMENTS.get('arch', 'i386')
buildtype = ARGUMENTS.get('buildtype', 'debug')

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
    OOC='ooc',
    OOCFLAGS=['-c', '-gcc', '-driver=sequence', '-nomain', '-gc=off', '+-m32', '+-nostdinc', '+-ffreestanding', '-Iinclude', '-sourcepath=.'],
    ENV = os.environ, # pass outside env to build so ooc is in PATH and OOC_DIST exists
)

env.Append(ENV={'OOC_SDK' : 'src/ooc-sdk'})

ooc = Builder(action = '$OOC $OOCFLAGS $SOURCE -outlib=$TARGET')
env.Append(BUILDERS = {'ooc' : ooc})

if buildtype == 'debug':
	env.Append(CCFLAGS=['-g', '-DDEBUG'], LINKFLAGS=['-g'])

Export('env', 'arch', 'buildtype', 'distreq')

SConscript('src/SConscript')

SConscript('iso/SConscript')

