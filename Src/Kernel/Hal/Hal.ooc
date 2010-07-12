import GDT, IDT, ISR, IRQ, Interrupts, SysCall, Display, MM, Keyboard

Hal: class {
    setup: static func {
        GDT setup()
        Display setup()

        MM setup()

        IDT setup()
        ISR setup()
        IRQ setup()
        SysCall setup()

        Keyboard setup()

        Interrupts enable()
    }
}
