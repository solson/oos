import IDT into IDT

// in Exceptions.asm
isrSyscall: extern proto func

init: func {
  IDT setGate(0x80, isrSyscall, 0x08, 0, 0, INTR32)
}

syscallHandler: func (regs: Registers@) {
  // TODO
}
