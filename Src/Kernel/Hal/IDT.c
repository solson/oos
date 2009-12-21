#include <shiny/hal/idt.h>

void halLoadIDT(IDTD idtd)
{
	__asm__ __volatile__ ("lidt %0" : : "m" (idtd));
}

