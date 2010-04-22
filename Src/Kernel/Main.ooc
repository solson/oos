import Kernel, Multiboot, Hal/[Hal, Display, Panic], Bochs

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
    multiboot cmdline as String println()
    Display setForeground(Color lightGrey)
    '\n' print()

    "Kernel Start: 0x%x" format(kernelStart&) println()
    "Kernel End:   0x%x" format(kernelEnd&) println()
    "Kernel Size:  %i kB" format((kernelEnd& as Int - kernelStart& as Int) / 1024) println()
    '\n' print()
}
