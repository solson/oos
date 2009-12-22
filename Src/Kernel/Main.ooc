import Multiboot
import Hal/Hal
import Printf

kmain: func (mb: MultibootInfo*, magic: UInt32) {
        halInit()

        printf("This kernel is written in ooc!\n\n")
        printf("Boot Loader: %s\n", mb@ bootLoaderName)
        printf("Command Line: %s\n", mb@ cmdline)

        while(1){}
}
