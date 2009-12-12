import idt

// from exceptions.asm
halIsr0: extern func
halIsr1: extern func
halIsr2: extern func
halIsr3: extern func
halIsr4: extern func
halIsr5: extern func
halIsr6: extern func
halIsr7: extern func
halIsr8: extern func
halIsr9: extern func
halIsr10: extern func
halIsr11: extern func
halIsr12: extern func
halIsr13: extern func
halIsr14: extern func
halIsr15: extern func
halIsr16: extern func
halIsr17: extern func
halIsr18: extern func
halIsr19: extern func
halIsr20: extern func
halIsr21: extern func
halIsr22: extern func
halIsr23: extern func
halIsr24: extern func
halIsr25: extern func
halIsr26: extern func
halIsr27: extern func
halIsr28: extern func
halIsr29: extern func
halIsr30: extern func
halIsr31: extern func

Registers: cover {
  gs, fs, es, ds: UInt // segments
  edi, esi, ebp, esp, ebx, edx, ecx, eax: UInt // pushed by pusha
  interruptNumber, errorCode: UInt
  eip, cs, eflags, useresp, ss: UInt // pushed by the processor automatically
}

TASK  : const UInt8 = 0x5
INTR16: const UInt8 = 0x6
INTR32: const UInt8 = 0xe
TRAP16: const UInt8 = 0x7
TRAP32: const UInt8 = 0xf

halIsrInstall: func {
  halSetIDTGate(0, halIsr0, 0x8, 0, 0, INTR32)
  halSetIDTGate(1, halIsr1, 0x8, 0, 0, INTR32)
  halSetIDTGate(2, halIsr2, 0x8, 0, 0, INTR32)
  halSetIDTGate(3, halIsr3, 0x8, 0, 0, INTR32)
  halSetIDTGate(4, halIsr4, 0x8, 0, 0, INTR32)
  halSetIDTGate(5, halIsr5, 0x8, 0, 0, INTR32)
  halSetIDTGate(6, halIsr6, 0x8, 0, 0, INTR32)
  halSetIDTGate(7, halIsr7, 0x8, 0, 0, INTR32)
  halSetIDTGate(8, halIsr8, 0x8, 0, 0, INTR32)
  halSetIDTGate(9, halIsr9, 0x8, 0, 0, INTR32)
  halSetIDTGate(10, halIsr10, 0x8, 0, 0, INTR32)
  halSetIDTGate(11, halIsr11, 0x8, 0, 0, INTR32)
  halSetIDTGate(12, halIsr12, 0x8, 0, 0, INTR32)
  halSetIDTGate(13, halIsr13, 0x8, 0, 0, INTR32)
  halSetIDTGate(14, halIsr14, 0x8, 0, 0, INTR32)
  halSetIDTGate(15, halIsr15, 0x8, 0, 0, INTR32)
  halSetIDTGate(16, halIsr16, 0x8, 0, 0, INTR32)
  halSetIDTGate(17, halIsr17, 0x8, 0, 0, INTR32)
  halSetIDTGate(18, halIsr18, 0x8, 0, 0, INTR32)
  halSetIDTGate(19, halIsr19, 0x8, 0, 0, INTR32)
  halSetIDTGate(20, halIsr20, 0x8, 0, 0, INTR32)
  halSetIDTGate(21, halIsr21, 0x8, 0, 0, INTR32)
  halSetIDTGate(22, halIsr22, 0x8, 0, 0, INTR32)
  halSetIDTGate(23, halIsr23, 0x8, 0, 0, INTR32)
  halSetIDTGate(24, halIsr24, 0x8, 0, 0, INTR32)
  halSetIDTGate(25, halIsr25, 0x8, 0, 0, INTR32)
  halSetIDTGate(26, halIsr26, 0x8, 0, 0, INTR32)
  halSetIDTGate(27, halIsr27, 0x8, 0, 0, INTR32)
  halSetIDTGate(28, halIsr28, 0x8, 0, 0, INTR32)
  halSetIDTGate(29, halIsr29, 0x8, 0, 0, INTR32)
  halSetIDTGate(30, halIsr30, 0x8, 0, 0, INTR32)
  halSetIDTGate(31, halIsr31, 0x8, 0, 0, INTR32)
}

