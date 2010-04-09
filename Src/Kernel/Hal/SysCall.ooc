import IDT, Registers

SysCall: class {
    // in Exceptions.asm
    isrSyscall: extern proto static func

    setup: static func {
        IDT setGate(0x80, isrSyscall, 0x08, 0, 0, IDT INTR32)
    }

    handler: static func (regs: Registers@) {
        // TODO
    }
}
