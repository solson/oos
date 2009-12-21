
oos
===

* oos is an Operating System with the goal of using [the ooc language][ooc] for
  as much of the code as possible
* oos stands for ooc operating system
* Repository: [http://github.com/tsion/oos][repo]
* IRC: [##oos on freenode][irc]


Downloading and Compiling oos
-----------------------------

You will need to have installed gcc, scons, nasm, genisoimage (cdrkit), and
[ooc][ooc]. I recommend you get the very latest version of ooc from the
[git repo][oocgit], because ooc is still in development and oos relies on some
recent bugfixes.

After you have all that, it is as simple as:

    $ git clone git://github.com/tsion/oos.git
    $ cd oos
    $ scons


Running oos
-----------

I've provided a script for running oos in the Bochs emulator.

    $ ./run.sh

You should be able to use oos with qemu or any emulator of your choice
by telling your emulator to boot the iso/shiny.iso CD image.

    $ qemu -cdrom iso/oos.iso

Running oos on real hardware is untested and not recommended (I am not
responsible for any fires, explosions, or alien abductions that may
result), but in theory it should work. I'll keep my fingers crossed.

UPDATE: sdkmvx has tested oos on real hardware, and it worked for him!


Features
--------

* el zilcho


Todo
----

* interrupts/exceptions - Done!
* syscalls - almost done
* memory management
* drivers for keyboard, display (text display driver mostly done), serial, filesystems, floppy, etc
* modules / elf32 loading
* ooc stdlib (all things like strlen, strcmp, etc, will be in pure ooc)


Thanks
------

* [nddrylliog][ndd] and everyone else involved in creating [the ooc language][ooc]!
* [OSDev][osdev], for all the great tutorials and informative articles
* The creators of [dux OS][dux]. I read and stole a lot of code from them. :)


[repo]:   http://github.com/tsion/oos
[ooc]:    http://ooc-lang.org
[oocgit]: http://github.com/nddrylliog/ooc
[irc]:    irc://freenode.net/##oos
[ndd]:    http://github.com/nddrylliog
[osdev]:  http://wiki.osdev.org/Main_Page
[dux]:    http://github.com/RockerMONO/dux

