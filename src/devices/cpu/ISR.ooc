import IDT, SysCall, Registers, Panic

exceptionMessages: const String* // [32]

ISR: cover {
    // from exceptions.asm
    isr0: extern proto static func
    isr1: extern proto static func
    isr2: extern proto static func
    isr3: extern proto static func
    isr4: extern proto static func
    isr5: extern proto static func
    isr6: extern proto static func
    isr7: extern proto static func
    isr8: extern proto static func
    isr9: extern proto static func
    isr10: extern proto static func
    isr11: extern proto static func
    isr12: extern proto static func
    isr13: extern proto static func
    isr14: extern proto static func
    isr15: extern proto static func
    isr16: extern proto static func
    isr17: extern proto static func
    isr18: extern proto static func
    isr19: extern proto static func
    isr20: extern proto static func
    isr21: extern proto static func
    isr22: extern proto static func
    isr23: extern proto static func
    isr24: extern proto static func
    isr25: extern proto static func
    isr26: extern proto static func
    isr27: extern proto static func
    isr28: extern proto static func
    isr29: extern proto static func
    isr30: extern proto static func
    isr31: extern proto static func

    handler: unmangled(isrHandler) static func (regs: Registers@) {
        if(regs interruptNumber == 0x80) {
            SysCall handler(regs&)
        } else if(regs interruptNumber == 3) {
            // Handle breakpoints here
            panic(exceptionMessages[3])
        } else if(regs interruptNumber < 32) {
            // panic with appropriate message
            panic(exceptionMessages[regs interruptNumber])
        }
    }

    setup: static func {
	    exceptionMessages = gc_malloc(String size * 32)
	    exceptionMessages[0] = "0 #DE Divide Error"
	    exceptionMessages[1] = "1 #DB RESERVED"
	    exceptionMessages[2] = "2 - NMI Interrupt"
	    exceptionMessages[3] = "3 #BP Breakpoint"
	    exceptionMessages[4] = "4 #OF Overflow"
	    exceptionMessages[5] = "5 #BR BOUND Range Exceeded"
	    exceptionMessages[6] = "6 #UD Invalid Opcode (Undefined Opcode)"
	    exceptionMessages[7] = "7 #NM Device Not Available (No Math Coprocessor)"
	    exceptionMessages[8] = "8 #DF Double Fault"
	    exceptionMessages[9] = "9   Coprocessor Segment Overrun (reserved)"
	    exceptionMessages[10] = "10 #TS Invalid TSS"
	    exceptionMessages[11] = "11 #NP Segment Not Present"
	    exceptionMessages[12] = "12 #SS Stack-Segment Fault"
	    exceptionMessages[13] = "13 #GP General Protection"
	    exceptionMessages[14] = "14 #PF Page Fault"
	    exceptionMessages[15] = "15 - (Intel reserved. Do not use.)"
	    exceptionMessages[16] = "16 #MF x87 FPU Floating-Point Error (Math Fault)"
	    exceptionMessages[17] = "17 #AC Alignment Check"
	    exceptionMessages[18] = "18 #MC Machine Check"
	    exceptionMessages[19] = "19 #XM SIMD Floating-Point Exception"
	    exceptionMessages[20] = "20 - Intel reserved. Do not use."
	    exceptionMessages[21] = "21 - Intel reserved. Do not use."
	    exceptionMessages[22] = "22 - Intel reserved. Do not use."
	    exceptionMessages[23] = "23 - Intel reserved. Do not use."
	    exceptionMessages[24] = "24 - Intel reserved. Do not use."
	    exceptionMessages[25] = "25 - Intel reserved. Do not use."
	    exceptionMessages[26] = "26 - Intel reserved. Do not use."
	    exceptionMessages[27] = "27 - Intel reserved. Do not use."
	    exceptionMessages[28] = "28 - Intel reserved. Do not use."
	    exceptionMessages[29] = "29 - Intel reserved. Do not use."
	    exceptionMessages[30] = "30 - Intel reserved. Do not use."
	    exceptionMessages[31] = "31 - Intel reserved. Do not use."
	    
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
}
