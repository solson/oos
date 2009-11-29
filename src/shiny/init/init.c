#include <shiny/shiny.h>
#include <shiny/display.h>

#define CHECK_FLAG(flags,bit)   ((flags) & (1 << (bit)))

void kmain(multiboot_info_t* mbd, unsigned int magic)
{
     HalInit();
     
     if ( magic != MULTIBOOT_BOOTLOADER_MAGIC )
     {
          /* Something went not according to specs. Print an error */
          /* message and halt, but do *not* rely on the multiboot */
          /* data structure. */
     }

     if(CHECK_FLAG(mbd->flags, 9)) {
          clear_screen();
          print("Boot Loader: ", 0);
          print((char*) mbd->boot_loader_name, 1);
     }

     if(CHECK_FLAG(mbd->flags, 2)) {
          print("Command Line: ", 3);
          print((char*) mbd->cmdline, 4);
     }
}
