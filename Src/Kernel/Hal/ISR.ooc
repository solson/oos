import IDT into IDT
import SysCall into SysCall

// from exceptions.asm
halIsr0: extern proto func
halIsr1: extern proto func
halIsr2: extern proto func
halIsr3: extern proto func
halIsr4: extern proto func
halIsr5: extern proto func
halIsr6: extern proto func
halIsr7: extern proto func
halIsr8: extern proto func
halIsr9: extern proto func
halIsr10: extern proto func
halIsr11: extern proto func
halIsr12: extern proto func
halIsr13: extern proto func
halIsr14: extern proto func
halIsr15: extern proto func
halIsr16: extern proto func
halIsr17: extern proto func
halIsr18: extern proto func
halIsr19: extern proto func
halIsr20: extern proto func
halIsr21: extern proto func
halIsr22: extern proto func
halIsr23: extern proto func
halIsr24: extern proto func
halIsr25: extern proto func
halIsr26: extern proto func
halIsr27: extern proto func
halIsr28: extern proto func
halIsr29: extern proto func
halIsr30: extern proto func
halIsr31: extern proto func

Registers: cover {
  gs, fs, es, ds: UInt // segments
  edi, esi, ebp, esp, ebx, edx, ecx, eax: UInt // pushed by pusha
  interruptNumber, errorCode: UInt
  eip, cs, eflags, useresp, ss: UInt // pushed by the processor automatically
}

TASK   := 0x5
INTR16 := 0x6
INTR32 := 0xe
TRAP16 := 0x7
TRAP32 := 0xf

isrHandler: unmangled func (regs: Registers@) {
  if (regs interruptNumber == 0x80) {
    SysCall syscallHandler(regs&)
  }
}

init: func {
  IDT setGate(0, halIsr0, 0x8, 0, 0, INTR32)
  IDT setGate(1, halIsr1, 0x8, 0, 0, INTR32)
  IDT setGate(2, halIsr2, 0x8, 0, 0, INTR32)
  IDT setGate(3, halIsr3, 0x8, 0, 0, INTR32)
  IDT setGate(4, halIsr4, 0x8, 0, 0, INTR32)
  IDT setGate(5, halIsr5, 0x8, 0, 0, INTR32)
  IDT setGate(6, halIsr6, 0x8, 0, 0, INTR32)
  IDT setGate(7, halIsr7, 0x8, 0, 0, INTR32)
  IDT setGate(8, halIsr8, 0x8, 0, 0, INTR32)
  IDT setGate(9, halIsr9, 0x8, 0, 0, INTR32)
  IDT setGate(10, halIsr10, 0x8, 0, 0, INTR32)
  IDT setGate(11, halIsr11, 0x8, 0, 0, INTR32)
  IDT setGate(12, halIsr12, 0x8, 0, 0, INTR32)
  IDT setGate(13, halIsr13, 0x8, 0, 0, INTR32)
  IDT setGate(14, halIsr14, 0x8, 0, 0, INTR32)
  IDT setGate(15, halIsr15, 0x8, 0, 0, INTR32)
  IDT setGate(16, halIsr16, 0x8, 0, 0, INTR32)
  IDT setGate(17, halIsr17, 0x8, 0, 0, INTR32)
  IDT setGate(18, halIsr18, 0x8, 0, 0, INTR32)
  IDT setGate(19, halIsr19, 0x8, 0, 0, INTR32)
  IDT setGate(20, halIsr20, 0x8, 0, 0, INTR32)
  IDT setGate(21, halIsr21, 0x8, 0, 0, INTR32)
  IDT setGate(22, halIsr22, 0x8, 0, 0, INTR32)
  IDT setGate(23, halIsr23, 0x8, 0, 0, INTR32)
  IDT setGate(24, halIsr24, 0x8, 0, 0, INTR32)
  IDT setGate(25, halIsr25, 0x8, 0, 0, INTR32)
  IDT setGate(26, halIsr26, 0x8, 0, 0, INTR32)
  IDT setGate(27, halIsr27, 0x8, 0, 0, INTR32)
  IDT setGate(28, halIsr28, 0x8, 0, 0, INTR32)
  IDT setGate(29, halIsr29, 0x8, 0, 0, INTR32)
  IDT setGate(30, halIsr30, 0x8, 0, 0, INTR32)
  IDT setGate(31, halIsr31, 0x8, 0, 0, INTR32)
}
