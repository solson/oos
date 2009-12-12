import idt, isr

// defined in gdt.asm
halInitGDT: extern func

halInit: func {
        halInitGDT()
        halInitIDT()
        halIsrInstall()
}

