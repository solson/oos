import idt, isr, irq, interrupts, syscall

// defined in gdt.asm
halInitGDT: extern proto func

halInit: func {
  halInitGDT()
  halInitIDT()
  halIsrInstall()
  halIrqInstall()
  halSyscallInstall()

  halInterruptsEnable()
}

