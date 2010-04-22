import GDT, IDT, ISR, IRQ, Interrupts, SysCall, Display, Printf, PMM, VMM

Hal: class {
    setup: static func {
        GDT setup()
        Display setup()

        PMM setup()
        VMM setup()

        runInitializer("IDT", IDT setup)
        runInitializer("ISRs", ISR setup)
        runInitializer("IRQs", IRQ setup)
        runInitializer("syscalls", SysCall setup)

//        "Enabling interrupts... " print()
        Interrupts enable()
//        "Done.\n" println()
    }
}

runInitializer: func (name: String, fn: Func) {
//  "Initializing %s... " format(name) print()
  fn()
//  "Done." println()
}
