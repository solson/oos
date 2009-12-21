import IDT, ISR, IRQ, Interrupts, SysCall, Display, Printf

// defined in gdt.asm
halInitGDT: extern proto func

halInit: func {
  halInitGDT()
  halInitDisplay()

  runInitializer("IDT", halInitIDT)
  runInitializer("ISRs", halIsrInstall)
  runInitializer("IRQs", halIrqInstall)
  runInitializer("syscalls", halSyscallInstall)

  printf("Enabling interrupts... ")
  halInterruptsEnable()
  printf("Done.\n\n")
}

runInitializer: func (name: String, fun: Func) {
  printf("Initializing %s... ", name)
  fun()
  printf("Done.\n")
}

