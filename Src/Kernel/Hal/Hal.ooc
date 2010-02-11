import GDT, IDT, ISR, IRQ, Interrupts, SysCall, Display, Printf

initHal: func {
  initGDT()
  initDisplay()

  runInitializer("IDT", initIDT)
  runInitializer("ISRs", initISR)
  runInitializer("IRQs", initIRQ)
  runInitializer("syscalls", initSysCall)

  printf("Enabling interrupts... ")
  enableInterrupts()
  printf("Done.\n\n")
}

runInitializer: func (name: String, f: Func) {
  printf("Initializing %s... ", name)
  f()
  printf("Done.\n")
}
