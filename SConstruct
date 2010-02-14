# vim: syntax=python

# os is needed to get the environment
import os


# set up the default environment
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
	SHLIBSUFFIX='.shlib',
	CC='gcc',
    CCFLAGS=['-m32', '-nostdinc', '-ffreestanding', '-IInclude', '-fno-stack-protector'],
	AS='nasm',
	ASFLAGS=['-felf'],
	LINK='ld',
	LINKFLAGS=['-melf_i386', '-nostdlib'],
    OOC='ooc',
    OOCFLAGS=['-c', '-gcc', '-driver=sequence', '-nomain', '-gc=off', '+-m32', '+-nostdinc', '+-ffreestanding', '+-fno-stack-protector', '-IInclude', '-sourcepath=.', '-noclean', '-noline'],
    ENV = os.environ, # pass outside env to build so ooc is in PATH and OOC_DIST exists
)


# set our custom ooc stdlib location
env.Append(ENV={'OOC_SDK' : 'Src/OocLib'})


# set up the ooc builder
ooc_builder = Builder(action = '$OOC $OOCFLAGS $SOURCE -outlib=$TARGET')
env.Append(BUILDERS = {'Ooc' : ooc_builder})


# default to debug mode. `scons debug=0` to build without debugging symbols
debug = ARGUMENTS.get('debug', 1)
if int(debug):
    env.Append(CCFLAGS=['-g', '-DDEBUG'], ASFLAGS=['-g'], LINKFLAGS=['-g'], OOCFLAGS=['-g'])


# run the child SConscripts
Export('env')
oos = SConscript('Src/SConscript')
SConscript('Iso/SConscript', 'oos')

