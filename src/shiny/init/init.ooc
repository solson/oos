include multiboot // TODO: move this to ooc!
import hal, printf

// very unfinished cover of multiboot_info_t
MultiBootInfoT: cover from multiboot_info_t {
        cmdline, boot_loader_name: extern UInt
}

kmain: func (mbd: MultiBootInfoT*, magic: UInt32) {
        halInit()

        printf("This kernel is written in ooc!\n\n")
        printf("Boot Loader: %s\n", mbd@ boot_loader_name)
        printf("Command Line: %s\n", mbd@ cmdline)

        while(1){}
}
