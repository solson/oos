# vim: syntax=python

# os is needed to get the environment
import os

ooc = ARGUMENTS.get('compiler', 'rock')

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
    AS='nasm',
    ASFLAGS=['-felf'],
    LINK='ld',
    LINKFLAGS=['-melf_i386', '-nostdlib'],
    OOC=ooc,
    OOCFLAGS=['-c', '-v', '-gcc', '-driver=sequence', '-nomain', '-gc=off', '+-m32', '+-nostdinc', '+-ffreestanding', '+-fno-stack-protector', '-IInclude', '-sourcepath=.', '-noclean', '-nolines'],
    ENV = os.environ, # pass outside env to build so ooc is in PATH and OOC_DIST exists
)


# set our custom ooc stdlib location
env.Append(ENV={'OOC_SDK' : 'Src/OocLib', 'ROCK_SDK' : 'Src/OocLib'})


# set up the ooc builder
ooc_builder = Builder(action = '$OOC $OOCFLAGS $SOURCE -staticlib=$TARGET')
env.Append(BUILDERS = {'ooc' : ooc_builder})


# default to debug mode. `scons debug=0` to build without debugging symbols
debug = ARGUMENTS.get('debug', 1)
if int(debug):
    env.Append(ASFLAGS=['-g'], LINKFLAGS=['-g'], OOCFLAGS=['-g'])


# run the child SConscripts
Export('env')
oos = SConscript('Src/SConscript')
SConscript('Iso/SConscript', 'oos')
