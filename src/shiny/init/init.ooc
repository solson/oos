include multiboot // TODO: move this to ooc!
import hal/i386/hal // TODO: should *not* have to specify arch here
import display

// very unfinished cover of multiboot_info_t
MultiBootInfoT: cover from multiboot_info_t {
        cmdline, boot_loader_name: extern UInt
}

kmain: func (mbd: MultiBootInfoT*, magic: UInt32) {
        halInit()

        clearScreen()
        printString("This kernel is written in ooc!", 0)

        printString("Boot Loader:", 2)
        printString(mbd@ boot_loader_name as String, 3)

        printString("Command Line:", 5)
        printString(mbd@ cmdline as String, 6)
}
