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
    OOCFLAGS=['-c', '-driver=sequence', '-nomain', '-gc=off', '+-m32',
              '+-nostdinc', '+-ffreestanding', '+-fno-stack-protector',
              '-IInclude', '-sourcepath=.', '-noclean', '-sdk=Src/OocLib'],
    ENV = os.environ, # pass outside env to build so rock is in PATH and OOC_DIST exists
)


# The C compiler rock should use. Defaults to clang. `scons cc=gcc` to use gcc.
cc = ARGUMENTS.get('cc', 'clang')
env.Append(OOCFLAGS=['-' + cc])


# set up the ooc builder
ooc_builder = Builder(action = '$OOC $OOCFLAGS $SOURCE -staticlib=$TARGET')
env.Append(BUILDERS = {'ooc' : ooc_builder})


# default to debug mode. `scons debug=0` to build without debugging symbols
debug = ARGUMENTS.get('debug', 1)
if int(debug):
    env.Append(ASFLAGS=['-g'], LINKFLAGS=['-g'], OOCFLAGS=['-g'])


# default to verbose mode. `scons verbose=0` to build more quietly
verbose = ARGUMENTS.get('verbose', 1)
if int(verbose):
    env.Append(OOCFLAGS=['-v'])
    

# run the child SConscripts
Export('env')
oos = SConscript('Src/SConscript')
SConscript('Iso/SConscript', 'oos')
