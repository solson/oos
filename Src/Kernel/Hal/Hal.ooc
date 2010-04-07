import GDT, IDT, ISR, IRQ, Interrupts, SysCall, Display, Printf

initHal: func {
  initGDT()
  initDisplay()

  runInitializer("IDT", initIDT)
  runInitializer("ISRs", initISR)
  runInitializer("IRQs", initIRQ)
  runInitializer("syscalls", initSysCall)

  "Enabling interrupts... " print()
  enableInterrupts()
  "Done.\n" println()
}

runInitializer: func (name: String, f: Func) {
  "Initializing " print()
  name print()
  "... " print()
  f()
  "Done." println()
}
