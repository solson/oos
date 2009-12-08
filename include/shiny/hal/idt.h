#ifndef IDT_H
#define IDT_H

#include <stdint.h>

/* IDT */
typedef struct IDTD {
	uint16_t size;
	uint32_t offset;
} __attribute__((packed)) IDTD;

typedef struct IDTG {
	uint16_t offset_1;
	uint16_t selector;
	uint8_t zero;
	uint8_t type;
	uint16_t offset_2;
} __attribute__((packed)) IDTG;

void halLoadIDT(IDTD);

#endif
