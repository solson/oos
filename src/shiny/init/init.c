#include <shiny/shiny.h>

#include <multiboot.h>

#define CHECK_FLAG(flags,bit)   ((flags) & (1 << (bit)))

void kmain(multiboot_info_t* mbd, unsigned int magic)
{
   if ( magic != MULTIBOOT_BOOTLOADER_MAGIC )
   {
      /* Something went not according to specs. Print an error */
      /* message and halt, but do *not* rely on the multiboot */
      /* data structure. */
   }
 
   if(CHECK_FLAG(mbd->flags, 9)) {
     k_clear_screen();
     k_printf("Boot Loader: ", 0);
     k_printf((char*) mbd->boot_loader_name, 1);
   }

   if(CHECK_FLAG(mbd->flags, 2)) {
     k_printf("Command Line: ", 3);
     k_printf((char*) mbd->cmdline, 4);
   }
}

void k_clear_screen()
{
	char *vidmem = (char *) 0xb8000;
	unsigned int i = 0;
	while(i < (80*25*2)) { // That's 80 columns and 25 rows, 2 bytes each
        vidmem[i] = ' '; // set to space (blank)
        i++;
        vidmem[i] = WHITE_TEXT;
        i++;
    }
}

unsigned int k_printf(char *message, unsigned int line)
{
	char *vidmem = (char *) 0xb8000;
	unsigned int i=0;

	i=(line*80*2);

	while(*message!=0)
	{
		if(*message=='\n') // check for a new line
		{
			line++;
			i=(line*80*2);
			*message++;
		} else {
			vidmem[i]=*message;
			*message++;
			i++;
			vidmem[i]=0x07;
			i++;
		};
	};

	return(1);
}
