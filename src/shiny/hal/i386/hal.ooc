import idt, isr, irq, interrupts

// defined in gdt.asm
halInitGDT: extern func

halInit: func {
  halInitGDT()
  halInitIDT()
  halIsrInstall()
  halIrqInstall()

  halInterruptsEnable()
}

