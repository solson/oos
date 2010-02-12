#include <stdint.h>

void outByte(uint16_t port, uint8_t val)
{
	__asm__ __volatile__("outb %0, %1" : : "a"(val), "d" (port));
}

uint8_t inByte(uint16_t port)
{
	uint8_t val;
	__asm__ __volatile__("inb %1, %0" : "=a" (val) : "d" (port));
	return val;
}

void outWord(uint16_t port, uint16_t val)
{
	__asm__ __volatile__("outw %0, %1" : : "a"(val), "d" (port));
}

uint16_t inWord(uint16_t port)
{
	uint16_t val;
	__asm__ __volatile__("inw %1, %0" : "=a" (val) : "d" (port));
	return val;
}

void outLong(uint16_t port, uint32_t val)
{
	__asm__ __volatile__("outl %0, %1" : : "a"(val), "d" (port));
}

uint32_t inLong(uint16_t port)
{
	uint32_t val;
	__asm__ __volatile__("inl %1, %0" : "=a" (val) : "d" (port));
	return val;
}
