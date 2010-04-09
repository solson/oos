import GDT, IDT, ISR, IRQ, Interrupts, SysCall, Display, Printf

Hal: class {
    init: static func {
        GDT init()
        Display init()

        runInitializer("IDT", IDT init)
        runInitializer("ISRs", ISR init)
        runInitializer("IRQs", IRQ init)
        runInitializer("syscalls", SysCall init)

        "Enabling interrupts... " print()
        Interrupts enable()
        "Done.\n" println()
    }
}

runInitializer: func (name: String, fn: Func) {
  "Initializing %s... " format(name) print()
  fn()
  "Done." println()
}
