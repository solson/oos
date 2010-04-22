import Kernel, Multiboot, Hal/[Hal, Display, Panic]

kmain: func (mb: MultibootInfo*, magic: UInt32) {
    multiboot = mb@
    Hal setup()

    "This kernel is written in " print()
    Display setForeground(Color lightGreen)
    "ooc" print()
    Display setForeground(Color lightGrey)
    "!\n\n" print()

    "Boot Loader:  " print()
    Display setForeground(Color lightBlue)
    multiboot bootLoaderName as String println()
    Display setForeground(Color lightGrey)

    "Command Line: " print()
    Display setForeground(Color lightBlue)
    multiboot cmdline as String print()
    "\n\n" print()
    Display setForeground(Color lightGrey)

    "Kernel Start: 0x%x" format(kernelStart&) println()
    "Kernel End:   0x%x" format(kernelEnd&) println()
    "Kernel Size:  %i B" format(kernelEnd& as Int - kernelStart& as Int) println()

    "\nUpper Memory: %i kB" format(multiboot memUpper) println()
    "Lower Memory: %i kB" format(multiboot memLower) println()

    // Never return from kmain
    while(1){}
}
