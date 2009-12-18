import idt, isr, irq

// defined in gdt.asm
halInitGDT: extern func

halInit: func {
        halInitGDT()
        halInitIDT()
        halIsrInstall()
        halIrqInstall()
}

