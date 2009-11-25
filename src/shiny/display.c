#include <shiny/display.h>

void clear_screen()
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

unsigned int print(char *message, unsigned int line)
{
     char *vidmem = (char *) 0xb8000;
     unsigned int i=0;

     i=(line*80*2);

     while(*message!=0)
     {
          if(*message=='\n') { // check for a new line
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
