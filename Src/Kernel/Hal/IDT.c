#include <idt.h>

void loadIDT(IDTD idtd)
{
	__asm__ __volatile__("lidt %0" : : "m" (idtd));
}
