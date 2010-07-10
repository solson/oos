import Kernel, Multiboot, Hal/[Hal, Display, Panic], Bochs

kmain: func (mb: MultibootInfo*, magic: UInt32) {
    multiboot = mb@
    Hal setup()

    "This kernel is written in " print()
    Display setFgColor(Color lightGreen)
    "ooc" print()
    Display setFgColor(Color lightGrey)
    "!\n\n" print()

    "Boot Loader:  " print()
    Display setFgColor(Color lightBlue)
    multiboot bootLoaderName as String println()
    Display setFgColor(Color lightGrey)

    "Command Line: " print()
    Display setFgColor(Color lightBlue)
    multiboot cmdline as String println()
    Display setFgColor(Color lightGrey)
    '\n' print()

    "Kernel Start: %p" format(kernelStart&) println()
    "Kernel End:   %p" format(kernelEnd&) println()
    "Kernel Size:  %i kB" format((kernelEnd& as Int - kernelStart& as Int) / 1024) println()
    '\n' print()
}
