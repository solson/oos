include idt

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

idt: IDTGate[256]

// defined in idt.c because it uses GCC inline ASM :(
halLoadIDT: extern func (IDTDescriptor)

halInitIDT: func {
  idtd: IDTDescriptor
  idtd offset = idt as UInt32
  idtd size = sizeof(IDTGate) * 256 - 1

  zeroMemory(idt, idtd size)

  halLoadIDT(idtd)
}

halSetIDTGate: func (n: SizeT, offset: Pointer, selector: UInt16, priv, sys, gatetype: UInt8) {
  idt[n] offset_1 = offset as UInt32 & 0xffff       // offset bits 0..15
  idt[n] offset_2 = offset as UInt32 >> 16 & 0xffff // offset bits 16..31
  idt[n] selector = selector
  idt[n] zero = 0 // unused
  idt[n] type_attr = (1 << 7) | // first bit must be set for all valid descriptors
                ((priv & 0b11) << 5) | // two bits for the ring level
                ((sys & 0b1) << 4) |   // one bit for system segment
                (gatetype & 0b1111)    // four bits for gate type
}

zeroMemory: func (ptr: Pointer, size: UInt32) -> Pointer {
  mem: UInt8* = ptr

  for (i in 0..size) {
    mem[i] = 0
  }

  return mem
}

