# vim: syntax=python

import os

debug = ARGUMENTS.get('debug', 'true')

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
    CCFLAGS=['-m32', '-nostdinc', '-ffreestanding', '-I', 'include'],
	AS='nasm',
	ASFLAGS=['-felf32'],
	LINK='ld',
	LINKFLAGS=['-melf_i386', '-nostdlib'],
    OOC='ooc',
    OOCFLAGS=['-c', '-gcc', '-driver=sequence', '-nomain', '-gc=off', '+-m32', '+-nostdinc', '+-ffreestanding', '-Iinclude', '-sourcepath=.'],
    ENV = os.environ, # pass outside env to build so ooc is in PATH and OOC_DIST exists
)

env.Append(ENV={'OOC_SDK' : 'Src/OocLib'})

ooc = Builder(action = '$OOC $OOCFLAGS $SOURCE -outlib=$TARGET')
env.Append(BUILDERS = {'Ooc' : ooc})

if debug == 'true':
	env.Append(CCFLAGS=['-g', '-DDEBUG'], LINKFLAGS=['-g'], OOCFLAGS=['-g'])

buildtype = debug
arch = ''
Export('env', 'arch', 'buildtype', 'distreq')

SConscript('Src/SConscript')

SConscript('Iso/SConscript')

