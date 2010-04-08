include GDT

// See http://wiki.osdev.org/GDT, or none of this will make any sense

// These covers wouldn't have to be from C if we could do GCC's
// __attribute__((packed)) from ooc somehow
GDTDescriptor: cover from GDTD {
    size: extern UInt16
    offset: extern UInt32
} // __attribute__((packed))

GDTEntry: cover from GDTE {
    limit_1: extern UInt16       // limit bits 0..15
    base_1: extern UInt16        // base bits 0..15
    base_2: extern UInt8         // base bits 16..23
    access_byte: extern UInt8    // access: Pr, Privl (2), 1, Ex, DC, RW, Ac
    flags__limit_2: extern UInt8 // flags: Gr, Sz, 0, 0
                                 // limit bits 16..19
    base_3: extern UInt8         // base bits 24..31
} // __attribute__((packed))

GDT: cover {
    gdt: static GDTEntry[3]

    // defined in GDT.asm
    load: extern(loadGDT) proto static func (GDTDescriptor*)

    init: static func {
        gdtd: GDTDescriptor
        gdtd offset = gdt as UInt32
        gdtd size = sizeof(GDTEntry) * 3 - 1

        zeroMemory(gdt, gdtd size)

        // Leave one null GDT entry at 0 because the CPU wants it
        setEntry(1, 0x00000000, 0xFFFFF, 0b00, true,  false, true, true, true)
        setEntry(2, 0x00000000, 0xFFFFF, 0b00, false, false, true, true, true)

        load(gdtd&)
    }

    setEntry: static func (n: SizeT, base, limit: UInt32, privl: UInt, ex, dc, rw, gr, sz: Bool) {
        gdt[n] base_1 = base & 0xFFFF     // base bits 0..15
        gdt[n] base_2 = base >> 16 & 0xFF // base bits 16..23
        gdt[n] base_3 = base >> 24 & 0xFF // base bits 24..31

        gdt[n] limit_1 = limit & 0xFFFF // limit bits 0..15
        gdt[n] flags__limit_2 = ((gr & 1) << 7)     | // granularity bit
                                ((sz & 1) << 6)     | // size bit
                                                      // ends with two dummy bits (00)
                                (limit >> 16 & 0xF) // limit bits 16..19

        gdt[n] access_byte = (1 << 7)              | // first bit must be set for all valid GDT selectors
                             ((privl & 0b11) << 5) | // two bits for the ring level
                             (1 << 4)              | // dummy bit, must be 1
                             ((ex & 1) << 3)       | // executable bit
                             ((dc & 1) << 2)       | // Direction bit/Conforming bit
                             ((rw & 1) << 1)         // Readable bit/Writable bit
                                                     // Accessed bit (left as 0)
    }
}
