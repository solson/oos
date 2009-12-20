import idt, isr, irq, interrupts, syscall, display

// defined in gdt.asm
halInitGDT: extern proto func

halInit: func {
  halInitGDT()
  halInitDisplay()

  runInitializer("IDT", halInitIDT)
  runInitializer("ISRs", halIsrInstall)
  runInitializer("IRQs", halIrqInstall)
  runInitializer("syscalls", halSyscallInstall)

  halDisplayPrintString("Enabling interrupts... ")
  halInterruptsEnable()
  halDisplayPrintString("Done.\n\n")
}

runInitializer: func (name: String, fun: Func) {
  halDisplayPrintString("Initializing ")
  halDisplayPrintString(name)
  halDisplayPrintString("... ")
  fun()
  halDisplayPrintString("Done.\n")
}

