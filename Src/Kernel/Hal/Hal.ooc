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

runInitializer: func (name: String, fn: Func) {
  "Initializing %s... " format(name) print()
  fn()
  "Done." println()
}
