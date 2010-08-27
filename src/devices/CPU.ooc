import cpu/[GDT, IDT, ISR, IRQ, SysCall]

CPU: cover {
    setup: static func {
        GDT setup()
        IDT setup()
        ISR setup()
        IRQ setup()
        SysCall setup()
    }

    enableInterrupts:  extern proto static func
    disableInterrupts: extern proto static func

    halt: static extern proto func
}
