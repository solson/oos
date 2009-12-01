include shiny/shiny
include shiny/hal/hal

import src/shiny/display

MultiBootInfoT: cover from multiboot_info_t {
        cmdline, boot_loader_name: extern UInt
}
HalInit: extern func

kmain: func (mbd: MultiBootInfoT*, magic: UInt32) {
        HalInit()

        clearScreen()
        printString("This kernel is written in ooc!", 0)

        printString("Boot Loader:", 2)
        printString(mbd@ boot_loader_name as String, 3)

        printString("Command Line:", 5)
        printString(mbd@ cmdline as String, 6)
}
