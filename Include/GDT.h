#ifndef GDT_H
#define GDT_H

#include <stdint.h>

/* GDT */
typedef struct GDTD {
    uint16_t size;
    uint32_t offset;
} __attribute__((packed)) GDTD;

typedef struct GDTE {
    uint16_t limit_1;
    uint16_t base_1;
    uint8_t base_2;
    uint8_t access_byte;
    uint8_t flags__limit_2;
    uint8_t base_3;
} __attribute__((packed)) GDTE;

#endif /* GDT_H */
