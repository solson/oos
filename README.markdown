
oos
===

* oos is an Operating System with the goal of using [the ooc language][ooc] for
  as much of the code as possible
* oos stands for ooc operating system
* Repository: [http://github.com/tsion/oos][repo]
* IRC: [##oos][irc-oos] or [#ooc-lang][irc-ooc] on freenode


Downloading and Compiling oos
-----------------------------

You will need to have installed gcc, make, nasm, genisoimage (cdrkit),
and [rock][rock] (the ooc compiler). I recommend you get the very
latest version of rock from the [git repo][rockgit], because ooc is
still in development and oos usually relies on some pretty recent
bugfixes. If you want to run oos in an emulator, bochs is a good
choice, and there is a makefile target for it.

Also, if you don't have `/boot/grub/stage2_eltorito`, you should `wget
http://osdev.googlecode.com/svn-history/r12/trunk/geekos/build/x86/boot/stage2_eltorito`
and move it to `isofs/boot/grub/stage2_eltorito`.

If you have `stage2_eltorito`, but it's just in a different location,
run `make STAGE2=/path/to/stage2_eltorito`.

After you have all that, it is as simple as:

    $ git clone git://github.com/tsion/oos.git
    $ cd oos
    $ make bochs

You can leave off 'bochs' if you only want to build the ISO.


Running oos
-----------

As seen above, I've provided a makefile target for running oos in the
Bochs emulator. You should be able to use oos with qemu or any
emulator of your choice by telling your emulator to boot the oos.iso
CD image.

    $ qemu -cdrom oos.iso

Running oos on real hardware is untested and not recommended (I am not
responsible for any fires, explosions, or alien abductions that may
result), but in theory it should work. I'll keep my fingers crossed.

UPDATE: [sdkmvx][sdkmvx] has tested oos on real hardware, and it worked for him!


Debugging oos
-------------

I have also created a make target to run bochs listening for a remote
gdb connection on port 1234. You need to compile bochs with
--enable-gdb-stub to use this script!

    $ make bochs-dbg

When you run that, bochs will say "Waiting for gdb connection on port
1234." You can now connect with gdb from another terminal. Use
--symbols=oos.exe so that gdb is aware of our function and variable
names.

    $ gdb --symbols=oos.exe
    GNU gdb (GDB) 7.0
    Copyright (C) 2009 Free Software Foundation, Inc.
    License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
    This is free software: you are free to change and redistribute it.
    There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
    and "show warranty" for details.
    This GDB was configured as "x86_64-unknown-linux-gnu".
    For bug reporting instructions, please see:
    <http://www.gnu.org/software/gdb/bugs/>.
    Reading symbols from /home/scott/code/os/oos/Src/Kernel/oos.exe...done.
    (gdb) target remote :1234
    Remote debugging using :1234
    warning: Remote failure reply: Eff
    0x0000fff0 in ?? ()
    (gdb) break kmain
    Breakpoint 1 at 0x100c2c: file ooc_tmp/oos/Src/Kernel/Main.c, line 11.
    (gdb) c
    Continuing.

    Breakpoint 1, kmain (mb=0x354a0, magic=732803074) at ooc_tmp/oos/Src/Kernel/Main.c:11
    11	void kmain(MultibootInfo *mb, uint32_t magic) {
    (gdb) bt
    #0  kmain (mb=0x354a0, magic=732803074) at ooc_tmp/oos/Src/Kernel/Main.c:11
    #1  0x00100018 in _start () at Src/Kernel/Boot.asm:25

This can be extremely useful for finding those annoying little
problems! The same can also be done with any GUI front-end to gdb, just
consult its documentation on how to do a remote gdb connection. And by
the way, since I compile with ooc -g, gdb can walk through ooc code
line by line, and display the ooc source of the line it's on. Hooray!

Note: gdb can do a *lot*, check out `help` (duh).

Note again: [nemiver][nemiver] is a decent GTK+ GUI front-end for gdb. Or
if you like to like to live on the 'K' side of life, there is [kdbg][kdbg].


Features
--------

* el zilcho
* Can I call printing colour text a feature? =)


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


[repo]:    http://github.com/tsion/oos
[rock]:    http://ooc-lang.org
[rockgit]: http://github.com/nddrylliog/rock
[irc-oos]: irc://freenode.net/##oos
[irc-ooc]: irc://freenode.net/#ooc-lang
[sdkmvx]:  http://github.com/martinbrandenburg
[nemiver]: http://projects.gnome.org/nemiver/
[kdbg]:    http://www.kdbg.org/
[ndd]:     http://github.com/nddrylliog
[osdev]:   http://wiki.osdev.org/Main_Page
[dux]:     http://github.com/RockerMONO/dux
