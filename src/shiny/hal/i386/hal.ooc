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

  halDisplayString("Enabling interrupts... ")
  halInterruptsEnable()
  halDisplayString("Done.\n\n")
}

runInitializer: func (name: String, fun: Func) {
  halDisplayString("Initializing ")
  halDisplayString(name)
  halDisplayString("... ")
  fun()
  halDisplayString("Done.\n")
}

