import Kernel, Multiboot, Hal/[Hal, Display, Panic]

kmain: func (mb: MultibootInfo*, magic: UInt32) {
    multiboot = mb@
    Hal setup()

    "This kernel is written in " print()
    Display setForeground(Color lightGreen)
    "ooc" print()
    Display setForeground(Color lightGrey)
    "!\n\n" print()

    "Boot Loader: " print()
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

    '\n' print()

    panic("Splat: %i %s", 4, "(testing formatting abilities)")

    "This should never be shown." println()

    // Never return from kmain
    while(1){}
}
