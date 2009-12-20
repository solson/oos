include multiboot // TODO: move this to ooc!
import hal
import display

// very unfinished cover of multiboot_info_t
MultiBootInfoT: cover from multiboot_info_t {
        cmdline, boot_loader_name: extern UInt
}

kmain: func (mbd: MultiBootInfoT*, magic: UInt32) {
        halInit()

        halDisplayString("This kernel is written in ooc!\n\n")

        halDisplayString("Boot Loader: ")
        halDisplayString(mbd@ boot_loader_name as String)
        halDisplayChar('\n')

        halDisplayString("Command Line: ")
        halDisplayString(mbd@ cmdline as String)
        halDisplayChar('\n')

        while(1){}
}
