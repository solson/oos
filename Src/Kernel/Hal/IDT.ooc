include IDT

// These covers wouldn't have to be from C if we could do GCC's
// __attribute__((packed)) from ooc somehow
IDTDescriptor: cover from IDTD {
    size: extern UInt16
    offset: extern UInt32
} // __attribute__((packed))

IDTGate: cover from IDTG {
    offset_1: extern UInt16 // offset bits 0..15
    selector: extern UInt16 // code segment selector in GDT
    zero: extern UInt8      // unused, set to 0
    type_attr: extern UInt8 // type and attributes
    offset_2: extern UInt16 // offset bits 16..31
} // __attribute__((packed))

IDT: class {
    TASK   := static 0x5
    INTR16 := static 0x6
    INTR32 := static 0xe
    TRAP16 := static 0x7
    TRAP32 := static 0xf

//    idt: static IDTGate[256]
    idt: static IDTGate*

    // defined in IDT.asm
    load: extern(loadIDT) proto static func (IDTDescriptor*)

    setup: static func {
        idt = gc_malloc(IDTGate size * 256)

        idtd: IDTDescriptor
        idtd offset = idt as UInt32
        idtd size = IDTGate size * 256 - 1

        zeroMemory(idt, idtd size)

        load(idtd&)
    }

    setGate: static func (n: SizeT, offset: Pointer, selector: UInt16, priv, sys, gatetype: UInt8) {
        idt[n] offset_1 = offset as UInt32 & 0xffff       // offset bits 0..15
        idt[n] offset_2 = offset as UInt32 >> 16 & 0xffff // offset bits 16..31

        idt[n] selector = selector
        idt[n] zero = 0 // unused

        idt[n] type_attr = (1 << 7) | // first bit must be set for all valid descriptors
               ((priv & 0b11) << 5) | // two bits for the ring level
               ((sys & 0b1) << 4)   | // one bit for system segment
               (gatetype & 0b1111)    // four bits for gate type
    }
}
