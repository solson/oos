import idt, isr

// in exceptions.asm
halIsrSyscall: extern proto func

halSyscallInstall: func {
  halSetIDTGate(0x80, halIsrSyscall, 0x08, 0, 0, INTR32)
}

halSyscallHandler: func (regs: Registers*) {
  // TODO
}

