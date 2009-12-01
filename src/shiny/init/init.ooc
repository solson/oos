include shiny/shiny
include shiny/display

include shiny/hal/hal

MultiBootInfoT: cover from multiboot_info_t
HalInit: extern func
print: extern func (message: String, line: UInt) -> UInt

clearScreen: func {
        vidmem := 0xb8000 as Char*
        i := 0
        while(i < (80*25*2)) { // That's 80 columns and 25 rows, 2 bytes each
                vidmem[i] = ' ' // set to space (blank)
                i += 1
                vidmem[i] = 0x07 // WHITE_TEXT
                i += 1
        }
}

kmain: func (mbd: MultiBootInfoT*, magic: UInt32) {
        HalInit()

        clearScreen()
        print("This kernel is written in ooc!", 0)
}
