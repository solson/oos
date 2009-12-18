import idt, ports, isr

irqRoutines: Pointer[16] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

// from exceptions.asm
halIrq0: extern proto func
halIrq1: extern proto func
halIrq2: extern proto func
halIrq3: extern proto func
halIrq4: extern proto func
halIrq5: extern proto func
halIrq6: extern proto func
halIrq7: extern proto func
halIrq8: extern proto func
halIrq9: extern proto func
halIrq10: extern proto func
halIrq11: extern proto func
halIrq12: extern proto func
halIrq13: extern proto func
halIrq14: extern proto func
halIrq15: extern proto func

halIrqHandlerInstall: func (irq: Int, handler: Func (Registers*)) {
  irqRoutines[irq] = handler
}

halIrqHandlerUninstall: func (irq: Int) {
  irqRoutines[irq] = 0
}

/* Normally, IRQs 0 to 7 are mapped to entries 8 to 15. This
*  is a problem in protected mode, because IDT entry 8 is a
*  Double Fault! Without remapping, every time HalIrq0 fires,
*  you get a Double Fault Exception, which is NOT actually
*  what's happening. We send commands to the Programmable
*  Interrupt Controller (PICs - also called the 8259's) in
*  order to make HalIrq0 to 15 be remapped to IDT entries 32 to
*  47 */
halIrqRemap: func {
  halOutPort(0x20, 0x11)
  halOutPort(0xA0, 0x11)
  halOutPort(0x21, 0x20)
  halOutPort(0xA1, 0x28)
  halOutPort(0x21, 0x04)
  halOutPort(0xA1, 0x02)
  halOutPort(0x21, 0x01)
  halOutPort(0xA1, 0x01)
  halOutPort(0x21, 0x00)
  halOutPort(0xA1, 0x00)
}

/* We first remap the interrupt controllers, and then we install
*  the appropriate ISRs to the correct entries in the IDT. This
*  is just like installing the exception handlers */
halIrqInstall: func {
  halIrqRemap()

  halSetIDTGate(32, halIrq0, 0x8, 0, 0, INTR32)
  halSetIDTGate(33, halIrq1, 0x8, 0, 0, INTR32)
  halSetIDTGate(34, halIrq2, 0x8, 0, 0, INTR32)
  halSetIDTGate(35, halIrq3, 0x8, 0, 0, INTR32)
  halSetIDTGate(36, halIrq4, 0x8, 0, 0, INTR32)
  halSetIDTGate(37, halIrq5, 0x8, 0, 0, INTR32)
  halSetIDTGate(38, halIrq6, 0x8, 0, 0, INTR32)
  halSetIDTGate(39, halIrq7, 0x8, 0, 0, INTR32)
  halSetIDTGate(40, halIrq8, 0x8, 0, 0, INTR32)
  halSetIDTGate(41, halIrq9, 0x8, 0, 0, INTR32)
  halSetIDTGate(42, halIrq10, 0x8, 0, 0, INTR32)
  halSetIDTGate(43, halIrq11, 0x8, 0, 0, INTR32)
  halSetIDTGate(44, halIrq12, 0x8, 0, 0, INTR32)
  halSetIDTGate(45, halIrq13, 0x8, 0, 0, INTR32)
  halSetIDTGate(46, halIrq14, 0x8, 0, 0, INTR32)
  halSetIDTGate(47, halIrq15, 0x8, 0, 0, INTR32)
}

/* Each of the IRQ ISRs point to this function, rather than
*  the 'HalFaultHandler' in 'isrs.c'. The IRQ Controllers need
*  to be told when you are done servicing them, so you need
*  to send them an "End of Interrupt" command (0x20). There
*  are two 8259 chips: The first exists at 0x20, the second
*  exists at 0xA0. If the second controller (an IRQ from 8 to
*  15) gets an interrupt, you need to acknowledge the
*  interrupt at BOTH controllers, otherwise, you only send
*  an EOI command to the first controller. If you don't send
*  an EOI, you won't raise any more IRQs */
halIrqHandler: func (regs: Registers*) {
  /* This is a blank function pointer */
  handler: Func (Registers*)

  /* Find out if we have a custom handler to run for this
  *  IRQ, and then finally, run it */
  handler = irqRoutines[regs@ interruptNumber - 32]
  if (handler) { handler(regs) }

  /* We need to send an EOI to the
  *  interrupt controllers too */
  if (regs@ interruptNumber > 8) { /* Only send EOI to slave controller if it's involved (irqs 9 and up) */
    halOutPort(0xA0, 0x20)
  }
  halOutPort(0x20, 0x20)
}

