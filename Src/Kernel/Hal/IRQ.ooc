/* Taken from <http://wiki.osdev.org/IRQ>:
*
*>  An interrupt is a message from a device, such as the keyboard, to the CPU,
*>  telling it to immediately stop whatever it is currently doing and do
*>  something else. For example, the keyboard controller sends an interrupt when
*>  a key is pressed. To know what to do when a specifc interrupt arise, the CPU
*>  has a table called the IDT which is setup by the OS, and stored in memory.
*>  There are 256 interrupts, numbered from 0 to 255, but only 16 are used by
*>  devices. These are called IRQs (Interrupt ReQuest) or hardware interrupts.
*>  The 16 IRQs are numbered from 0 to 15. */

/* Imports:
*
* - IDT: So we can set gates for interrupts.
* - Ports: So we can program the PICs
* - Registers: A struct given to interrupt handlers */
import IDT, Ports, Registers

/* `IRQ` is only used as a namespace. */
IRQ: class {
    /* An array storing pointers to the interrupt handler functions. */
    irqRoutines: static Pointer[16] = [null, null, null, null, null, null,
        null, null, null, null, null, null, null, null, null, null]

    /* All of these `irq` functions are defined in Hal.asm. The `proto` keyword
    *  is used because there is no C header that declares these functions. */
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

    /* These are the Master PIC command and data port numbers. */
    PIC1_COMMAND := static 0x20
    PIC1_DATA    := static 0x21

    /* These are the Slave PIC command and data port numbers. */
    PIC2_COMMAND  := static 0xA0
    PIC2_DATA     := static 0xA1

    /* This is a command that is sent to the PICs, telling them we are finished
    *  handling the interrupt, and to resume regularily scheduled programming. */
    PIC_EOI := static 0x20

    /* Install a custom function to handle a certain IRQ number. */
    handlerInstall: static func (irq: Int, handler: Func (Registers*)) {
        irqRoutines[irq] = handler
    }

    /* Uninstall the function that handles a certain IRQ number. */
    handlerUninstall: static func (irq: Int) {
        irqRoutines[irq] = null
    }

    /* Normally, IRQs 0 to 7 are mapped to entries 8 to 15. This
    *  is a problem in protected mode, because IDT entry 8 is a
    *  Double Fault! Without remapping, every time irq0 fires,
    *  you get a Double Fault Exception, which is NOT actually
    *  what's happening. We send commands to the Programmable
    *  Interrupt Controller (PICs - also called the 8259's) in
    *  order to make irq0 to 15 be remapped to IDT entries 32 to
    *  47 */
    remapPIC: static func {
        Ports outByte(PIC1_COMMAND, 0x11)
        Ports outByte(PIC2_COMMAND, 0x11)

        Ports outByte(PIC1_DATA, 0x20)
        Ports outByte(PIC2_DATA, 0x28)

        Ports outByte(PIC1_DATA, 0x04)
        Ports outByte(PIC2_DATA, 0x02)

        Ports outByte(PIC1_DATA, 0x01)
        Ports outByte(PIC2_DATA, 0x01)

        Ports outByte(PIC1_DATA, 0x00)
        Ports outByte(PIC2_DATA, 0x00)
    }

    /* We first remap the interrupt controllers, and then we install
    *  the appropriate ISRs to the correct entries in the IDT. This
    *  is just like installing the exception handlers */
    setup: static func {
        remapPIC()

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
    handler: unmangled(irqHandler) static func (regs: Registers@) {
        // This is a blank function pointer
        fn: Func (Registers*)

        /* Find out if we have a custom handler to run for this
        *  IRQ, and then run it */
        fn = irqRoutines[regs interruptNumber - 32]
        if(fn)
            fn(regs&)

        /* We need to send an EOI to the interrupt controllers when we are done
        *  Only send EOI to slave controller if it's involved (irqs 9 and up) */
        if(regs interruptNumber > 8)
            Ports outByte(PIC2_COMMAND, PIC_EOI)
        Ports outByte(PIC1_COMMAND, PIC_EOI)
  }
}
