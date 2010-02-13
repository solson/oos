import Multiboot
import Hal/[Hal, Display, Panic]
import Printf

// from the Linker.ld linker script
kernelEnd: extern proto Int
kernelStart: extern proto Int

kmain: func (mb: MultibootInfo@, magic: UInt32) {
    initHal()

    printf("This kernel is written in ")
    setForeground(LIGHT_GREEN)
    printf("ooc")
    setForeground(LIGHT_GREY)
    printf("!\n\n")

    printf("Boot Loader: ")
    setForeground(LIGHT_BLUE)
    printf("%s\n", mb bootLoaderName)
    setForeground(LIGHT_GREY)

    printf("Command Line: ")
    setForeground(LIGHT_BLUE)
    printf("%s\n\n", mb cmdline)
    setForeground(LIGHT_GREY)

    printf("Kernel Start: 0x%x\n", kernelStart&)
    printf("Kernel End:   0x%x\n\n", kernelEnd&)

    panic("Splat: %i %s", 4, "(testing formatting abilities)")

    printf("This should never be shown.\n")

    // Never return from kmain
    while(1){}
}
