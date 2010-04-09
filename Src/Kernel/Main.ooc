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

    '\n' print()

    "Memory Map:" println()
    printMMap()

    '\n' print()

    panic("Splat: %i %s", 4, "(testing formatting abilities)")

    "This should never be shown." println()

    // Never return from kmain
    while(1){}
}

printMMap: func {
    mmap := multiboot mmapAddr as MMapEntry*
    mmapLength := multiboot mmapLength
    marker := 0

    while(marker < mmapLength) {
        "  %s0x%08x-0x%08x (%i kB)" format((mmap@ type == 1 ? "Available: " : "Reserved:  "), mmap@ baseAddrLow, mmap@ baseAddrLow + mmap@ lengthLow - 1, mmap@ lengthLow / 1024) println()
        marker += mmap@ size + 4
        mmap = (multiboot mmapAddr + marker) as MMapEntry*
    }
}
