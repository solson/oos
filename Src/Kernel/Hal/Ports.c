#include <stdint.h>

void halOutPortByte(uint16_t port, uint8_t val)
{
	__asm volatile("outb %0, %1" : : "a"(val), "d" (port));
}

uint8_t halInPortByte(uint16_t port)
{
	uint8_t val;
	__asm volatile("inb %1, %0" : "=a" (val) : "d" (port));
	return val;
}

void halOutPortWord(uint16_t port, uint16_t val)
{
	__asm volatile("outw %0, %1" : : "a"(val), "d" (port));
}

uint16_t halInPortWord(uint16_t port)
{
	uint16_t val;
	__asm volatile("inw %1, %0" : "=a" (val) : "d" (port));
	return val;
}

void halOutPortLong(uint16_t port, uint32_t val)
{
	__asm volatile("outl %0, %1" : : "a"(val), "d" (port));
}

uint32_t halInPortLong(uint16_t port)
{
	uint32_t val;
	__asm volatile("inl %1, %0" : "=a" (val) : "d" (port));
	return val;
}
