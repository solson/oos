include shiny/hal/idt

// These covers wouldn't have to be from C if we could do GCC's
// __attribute__((packed)) from ooc somehow
IDTDescriptor: cover from IDTD {
  size: extern UInt16
  offset: extern UInt32
} // __attribute__((packed))

IDTGate: cover from IDTG {
  offset_1: extern UInt16
  selector: extern UInt16
  zero: extern UInt8
  type: extern UInt8
  offset_2: extern UInt16
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

zeroMemory: func (ptr: Pointer, size: UInt32) -> Pointer {
  mem: UInt8* = ptr

  for (i in 0..size) {
    mem[i] = 0
  }

  return mem
}

