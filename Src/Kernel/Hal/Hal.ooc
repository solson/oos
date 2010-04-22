import GDT, IDT, ISR, IRQ, Interrupts, SysCall, Display, PMM, VMM

Hal: class {
    setup: static func {
        GDT setup()
        Display setup()

        PMM setup()
        '\n' print()
        VMM setup()
        '\n' print()

        IDT setup()
        ISR setup()
        IRQ setup()
        SysCall setup()

        Interrupts enable()
    }
}
