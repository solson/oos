include multiboot // TODO: move this to ooc!
import hal
import display

// very unfinished cover of multiboot_info_t
MultiBootInfoT: cover from multiboot_info_t {
        cmdline, boot_loader_name: extern UInt
}

kmain: func (mbd: MultiBootInfoT*, magic: UInt32) {
        halInit()

        halDisplayClearScreen()
        halDisplayPrintString("This kernel is written in ooc!\n\n")

        halDisplayPrintString("Boot Loader: ")
        halDisplayPrintString(mbd@ boot_loader_name as String)
        halDisplayPrintChar('\n')

        halDisplayPrintString("Command Line: ")
        halDisplayPrintString(mbd@ cmdline as String)
        halDisplayPrintChar('\n')

        while(1){}
}
