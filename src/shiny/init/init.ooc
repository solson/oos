include shiny/shiny
include shiny/hal/hal

import src/shiny/display

MultiBootInfoT: cover from multiboot_info_t
HalInit: extern func

kmain: func (mbd: MultiBootInfoT*, magic: UInt32) {
        HalInit()

        clearScreen()
        printString("This kernel is written in ooc!", 0)
}
