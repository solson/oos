
oos
===

* oos is an Operating System with the goal of using [ooc][ooc] for
  as much of the code as possible
* oos stands for ooc operating system
* Repository: [http://github.com/tsion/oos][repo]


Downloading and Compiling oos
-------------

It is as simple as:

    $ git clone git://github.com/tsion/oos.git
    $ cd oos
    $ scons

That is, if you have scons installed. It should be readily available
from your package manager.

Note: You will also need the 'ooc' compiler in your PATH!


Running oos
-----------

I've provided scripts for running oos in the Bochs emulator with the
GUI debugger and without. You won't be able to use the GUI debugger
unless you compile Bochs with debugging enabled!

Without the debugger:

    $ ./run.sh

With the debugger:

    $ ./run-debug.sh

You should be able to use oos with qemu or any emulator of your choice
by telling your emulator to boot the iso/shiny.iso CD image.

    $ qemu -cdrom iso/shiny.iso

Running oos on real hardware is untested and not recommended (I am not
responsible for any fires, explosions, or alien abductions that may
result), but in theory it should work. I'll keep my fingers crossed.

UPDATE: sdkmvx has tested oos on real hardware, and it worked!


Features
--------

* el zilcho

Todo
----

* interrupts/exceptions and syscalls
* memory management
* drivers for keyboard, display, serial, filesystems, floppy, etc
* modules / elf32 loading
* ooc stdlib (all things like strlen, strcmp, etc, will be in pure ooc)


[repo]: http://github.com/tsion/oos
[ooc]:  http://ooc-lang.org
