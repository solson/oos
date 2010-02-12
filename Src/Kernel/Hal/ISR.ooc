import IDT into IDT
import SysCall into SysCall
import Registers
import Panic

// from exceptions.asm
isr0: extern proto func
isr1: extern proto func
isr2: extern proto func
isr3: extern proto func
isr4: extern proto func
isr5: extern proto func
isr6: extern proto func
isr7: extern proto func
isr8: extern proto func
isr9: extern proto func
isr10: extern proto func
isr11: extern proto func
isr12: extern proto func
isr13: extern proto func
isr14: extern proto func
isr15: extern proto func
isr16: extern proto func
isr17: extern proto func
isr18: extern proto func
isr19: extern proto func
isr20: extern proto func
isr21: extern proto func
isr22: extern proto func
isr23: extern proto func
isr24: extern proto func
isr25: extern proto func
isr26: extern proto func
isr27: extern proto func
isr28: extern proto func
isr29: extern proto func
isr30: extern proto func
isr31: extern proto func

exceptionMessages: const String[32] = [
  "0 #DE Divide Error",
  "1 #DB RESERVED",
  "2 - NMI Interrupt",
  "3 #BP Breakpoint",
  "4 #OF Overflow",
  "5 #BR BOUND Range Exceeded",
  "6 #UD Invalid Opcode (Undefined Opcode)",
  "7 #NM Device Not Available (No Math Coprocessor)",
  "8 #DF Double Fault",
  "9   Coprocessor Segment Overrun (reserved)",
  "10 #TS Invalid TSS",
  "11 #NP Segment Not Present",
  "12 #SS Stack-Segment Fault",
  "13 #GP General Protection",
  "14 #PF Page Fault",
  "15 - (Intel reserved. Do not use.)",
  "16 #MF x87 FPU Floating-Point Error (Math Fault)",
  "17 #AC Alignment Check",
  "18 #MC Machine Check",
  "19 #XM SIMD Floating-Point Exception",
  "20 - Intel reserved. Do not use.",
  "21 - Intel reserved. Do not use.",
  "22 - Intel reserved. Do not use.",
  "23 - Intel reserved. Do not use.",
  "24 - Intel reserved. Do not use.",
  "25 - Intel reserved. Do not use.",
  "26 - Intel reserved. Do not use.",
  "27 - Intel reserved. Do not use.",
  "28 - Intel reserved. Do not use.",
  "29 - Intel reserved. Do not use.",
  "30 - Intel reserved. Do not use.",
  "31 - Intel reserved. Do not use."
]

isrHandler: unmangled func (regs: Registers@) {
  if (regs interruptNumber == 0x80) {
    SysCall syscallHandler(regs&)
  } else if (regs interruptNumber == 3) {
    // Handle breakpoints here
    panic(exceptionMessages[3])
  } else if (regs interruptNumber < 32) {
    // panic with appropriate message
    panic(exceptionMessages[regs interruptNumber])
  }
}

initISR: func {
  IDT setGate(0, isr0, 0x8, 0, 0, IDT INTR32)
  IDT setGate(1, isr1, 0x8, 0, 0, IDT INTR32)
  IDT setGate(2, isr2, 0x8, 0, 0, IDT INTR32)
  IDT setGate(3, isr3, 0x8, 0, 0, IDT INTR32)
  IDT setGate(4, isr4, 0x8, 0, 0, IDT INTR32)
  IDT setGate(5, isr5, 0x8, 0, 0, IDT INTR32)
  IDT setGate(6, isr6, 0x8, 0, 0, IDT INTR32)
  IDT setGate(7, isr7, 0x8, 0, 0, IDT INTR32)
  IDT setGate(8, isr8, 0x8, 0, 0, IDT INTR32)
  IDT setGate(9, isr9, 0x8, 0, 0, IDT INTR32)
  IDT setGate(10, isr10, 0x8, 0, 0, IDT INTR32)
  IDT setGate(11, isr11, 0x8, 0, 0, IDT INTR32)
  IDT setGate(12, isr12, 0x8, 0, 0, IDT INTR32)
  IDT setGate(13, isr13, 0x8, 0, 0, IDT INTR32)
  IDT setGate(14, isr14, 0x8, 0, 0, IDT INTR32)
  IDT setGate(15, isr15, 0x8, 0, 0, IDT INTR32)
  IDT setGate(16, isr16, 0x8, 0, 0, IDT INTR32)
  IDT setGate(17, isr17, 0x8, 0, 0, IDT INTR32)
  IDT setGate(18, isr18, 0x8, 0, 0, IDT INTR32)
  IDT setGate(19, isr19, 0x8, 0, 0, IDT INTR32)
  IDT setGate(20, isr20, 0x8, 0, 0, IDT INTR32)
  IDT setGate(21, isr21, 0x8, 0, 0, IDT INTR32)
  IDT setGate(22, isr22, 0x8, 0, 0, IDT INTR32)
  IDT setGate(23, isr23, 0x8, 0, 0, IDT INTR32)
  IDT setGate(24, isr24, 0x8, 0, 0, IDT INTR32)
  IDT setGate(25, isr25, 0x8, 0, 0, IDT INTR32)
  IDT setGate(26, isr26, 0x8, 0, 0, IDT INTR32)
  IDT setGate(27, isr27, 0x8, 0, 0, IDT INTR32)
  IDT setGate(28, isr28, 0x8, 0, 0, IDT INTR32)
  IDT setGate(29, isr29, 0x8, 0, 0, IDT INTR32)
  IDT setGate(30, isr30, 0x8, 0, 0, IDT INTR32)
  IDT setGate(31, isr31, 0x8, 0, 0, IDT INTR32)
}
