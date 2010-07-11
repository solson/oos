import GDT, IDT, ISR, IRQ, Interrupts, SysCall, Display, MM

Hal: class {
    setup: static func {
        GDT setup()
        Display setup()

        MM setup()

        IDT setup()
        ISR setup()
        IRQ setup()
        SysCall setup()

        Interrupts enable()
    }
}
