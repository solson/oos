#include <stdint.h>

void outByte(uint16_t port, uint8_t val)
{
	__asm volatile("outb %0, %1" : : "a"(val), "d" (port));
}

uint8_t inByte(uint16_t port)
{
	uint8_t val;
	__asm volatile("inb %1, %0" : "=a" (val) : "d" (port));
	return val;
}

void outWord(uint16_t port, uint16_t val)
{
	__asm volatile("outw %0, %1" : : "a"(val), "d" (port));
}

uint16_t inWord(uint16_t port)
{
	uint16_t val;
	__asm volatile("inw %1, %0" : "=a" (val) : "d" (port));
	return val;
}

void outLong(uint16_t port, uint32_t val)
{
	__asm volatile("outl %0, %1" : : "a"(val), "d" (port));
}

uint32_t inLong(uint16_t port)
{
	uint32_t val;
	__asm volatile("inl %1, %0" : "=a" (val) : "d" (port));
	return val;
}
