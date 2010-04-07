import Multiboot
import Hal/[Hal, Display, Panic]
import Printf

// from the Linker.ld linker script
kernelEnd: extern proto Int
kernelStart: extern proto Int

kmain: func (mb: MultibootInfo@, magic: UInt32) {
    initHal()

    "This kernel is written in " print()
    setForeground(LIGHT_GREEN)
    "ooc" print()
    setForeground(LIGHT_GREY)
    "!\n\n" print()

    "Boot Loader: " print()
    setForeground(LIGHT_BLUE)
    mb bootLoaderName as String println()
    setForeground(LIGHT_GREY)

    "Command Line: " print()
    setForeground(LIGHT_BLUE)
    mb cmdline as String print()
    "\n\n" print()
    setForeground(LIGHT_GREY)

    printf("Kernel Start: 0x%x\n", kernelStart&)
    printf("Kernel End:   0x%x\n\n", kernelEnd&)

    panic("Splat: %i %s", 4, "(testing formatting abilities)")

    "This should never be shown." println()

    // Never return from kmain
    while(1){}
}
