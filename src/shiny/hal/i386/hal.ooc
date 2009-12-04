// defined in gdt.asm
halInitGDT: extern func

halInit: func {
        halInitGDT()
}
