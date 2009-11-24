#ifndef SHINY_H
#define SHINY_H

#include <multiboot.h>

#define WHITE_TEXT 0x07

void k_clear_screen();
unsigned int k_printf(char *message, unsigned int line);
void kmain(multiboot_info_t *mbd, unsigned int magic);

#endif
