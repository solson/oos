import IDT, Ports, Registers

IRQ: class {
    irqRoutines: static Pointer[16] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    // from exceptions.asm
    irq0: extern proto static func
    irq1: extern proto static func
    irq2: extern proto static func
    irq3: extern proto static func
    irq4: extern proto static func
    irq5: extern proto static func
    irq6: extern proto static func
    irq7: extern proto static func
    irq8: extern proto static func
    irq9: extern proto static func
    irq10: extern proto static func
    irq11: extern proto static func
    irq12: extern proto static func
    irq13: extern proto static func
    irq14: extern proto static func
    irq15: extern proto static func

    handlerInstall: static func (irq: Int, handler: Func (Registers@)) {
        irqRoutines[irq] = handler
    }

    handlerUninstall: static func (irq: Int) {
        irqRoutines[irq] = 0
    }

    /* Normally, IRQs 0 to 7 are mapped to entries 8 to 15. This
    *  is a problem in protected mode, because IDT entry 8 is a
    *  Double Fault! Without remapping, every time irq0 fires,
    *  you get a Double Fault Exception, which is NOT actually
    *  what's happening. We send commands to the Programmable
    *  Interrupt Controller (PICs - also called the 8259's) in
    *  order to make irq0 to 15 be remapped to IDT entries 32 to
    *  47 */
    remap: func {
        Ports outByte(0x20, 0x11)
        Ports outByte(0xA0, 0x11)
        Ports outByte(0x21, 0x20)
        Ports outByte(0xA1, 0x28)
        Ports outByte(0x21, 0x04)
        Ports outByte(0xA1, 0x02)
        Ports outByte(0x21, 0x01)
        Ports outByte(0xA1, 0x01)
        Ports outByte(0x21, 0x00)
        Ports outByte(0xA1, 0x00)
    }

    /* We first remap the interrupt controllers, and then we install
    *  the appropriate ISRs to the correct entries in the IDT. This
    *  is just like installing the exception handlers */
    init: func {
        remap()

        IDT setGate(32, irq0, 0x8, 0, 0, IDT INTR32)
        IDT setGate(33, irq1, 0x8, 0, 0, IDT INTR32)
        IDT setGate(34, irq2, 0x8, 0, 0, IDT INTR32)
        IDT setGate(35, irq3, 0x8, 0, 0, IDT INTR32)
        IDT setGate(36, irq4, 0x8, 0, 0, IDT INTR32)
        IDT setGate(37, irq5, 0x8, 0, 0, IDT INTR32)
        IDT setGate(38, irq6, 0x8, 0, 0, IDT INTR32)
        IDT setGate(39, irq7, 0x8, 0, 0, IDT INTR32)
        IDT setGate(40, irq8, 0x8, 0, 0, IDT INTR32)
        IDT setGate(41, irq9, 0x8, 0, 0, IDT INTR32)
        IDT setGate(42, irq10, 0x8, 0, 0, IDT INTR32)
        IDT setGate(43, irq11, 0x8, 0, 0, IDT INTR32)
        IDT setGate(44, irq12, 0x8, 0, 0, IDT INTR32)
        IDT setGate(45, irq13, 0x8, 0, 0, IDT INTR32)
        IDT setGate(46, irq14, 0x8, 0, 0, IDT INTR32)
        IDT setGate(47, irq15, 0x8, 0, 0, IDT INTR32)
    }

    /* Each of the IRQ ISRs point to this function. The IRQ Controllers
    *  need to be told when you are done servicing them, so you need to
    *  send them an "End of Interrupt" command (0x20). There are two 8259
    *  chips: The first exists at 0x20, the second exists at 0xA0. If the
    *  second controller (an IRQ from 8 to 15) gets an interrupt, you need
    *  to acknowledge the interrupt at BOTH controllers, otherwise, you
    *  only send an EOI command to the first controller. If you don't send
    *  an EOI, you won't raise any more IRQs */
    irqHandler: unmangled func (regs: Registers*) {
        /* This is a blank function pointer */
        handler: Func (Registers*)

        /* Find out if we have a custom handler to run for this
        *  IRQ, and then finally, run it */
        handler = irqRoutines[regs@ interruptNumber - 32]
        if(handler) {
            handler(regs)
        }

        /* We need to send an EOI to the
        *  interrupt controllers too */
        if(regs interruptNumber > 8) { /* Only send EOI to slave controller if it's involved (irqs 9 and up) */
            Ports outByte(0xA0, 0x20)
        }
        Ports outByte(0x20, 0x20)
  }
}
