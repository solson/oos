void k_clear_screen() // clear the entire text screen
{
	char *vidmem = (char *) 0xb8000;
	unsigned int i=0;
	while(i < (80*25*2)) { // That's 80 columns by 25 rows, 2 bytes each
        vidmem[i] = ' '; // set to space (blank)
        i++;
        vidmem[i] = 0x07; // white on black text
        i++;
    }
}

unsigned int k_printf(char *message, unsigned int line) // the message and then the line #
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
};

void kmain( void* mbd, unsigned int magic )
{
   if ( magic != 0x2BADB002 )
   {
      /* Something went not according to specs. Print an error */
      /* message and halt, but do *not* rely on the multiboot */
      /* data structure. */
   }
 
   /* You could either use multiboot.h */
   /* (http://www.gnu.org/software/grub/manual/multiboot/multiboot.html#multiboot_002eh) */
   /* or do your offsets yourself. The following is merely an example. */ 
   char * boot_loader_name =(char*) ((long*)mbd)[16];
 
   /* Print a letter to screen to see everything is working: */
//   unsigned char *videoram = (unsigned char *) 0xb8000;
//   videoram[0] = 'H';
//   videoram[1] = 0x07; /* forground, background color. */
 
   /* Write your kernel here. */
   k_clear_screen();
   k_printf("Boot Loader: ", 0);
   k_printf(boot_loader_name, 1);
}
