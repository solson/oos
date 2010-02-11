import IDT into IDT
import Registers

// in Exceptions.asm
isrSyscall: extern proto func

initSysCall: func {
  IDT setGate(0x80, isrSyscall, 0x08, 0, 0, IDT INTR32)
}

syscallHandler: func (regs: Registers@) {
  // TODO
}
