
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


Features
--------

* el zilcho


Note
----

At this time oos contains no ooc code... it may be necessary to
implement malloc/memory management before that can happen


[repo]: http://github.com/tsion/oos
[ooc]:  http://ooc-lang.org
