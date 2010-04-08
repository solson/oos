import Kernel, Multiboot, Hal/[Hal, Display, Panic]

kmain: func (mb: MultibootInfo*, magic: UInt32) {
    multiboot = mb@
    initHal()

    "This kernel is written in " print()
    setForeground(LIGHT_GREEN)
    "ooc" print()
    setForeground(LIGHT_GREY)
    "!\n\n" print()

    "Boot Loader: " print()
    setForeground(LIGHT_BLUE)
    multiboot bootLoaderName as String println()
    setForeground(LIGHT_GREY)

    "Command Line: " print()
    setForeground(LIGHT_BLUE)
    multiboot cmdline as String print()
    "\n\n" print()
    setForeground(LIGHT_GREY)

    "Kernel Start: 0x%x" format(kernelStart&) println()
    "Kernel End:   0x%x" format(kernelEnd&) println()

    '\n' print()

    panic("Splat: %i %s", 4, "(testing formatting abilities)")

    "This should never be shown." println()

    // Never return from kmain
    while(1){}
}
