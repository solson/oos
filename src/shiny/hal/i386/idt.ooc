include shiny/hal/idt

IDTDescriptor: cover from IDTD {
  size: extern UInt16
  offset: extern UInt32
}

IDTGate: cover from IDTG {
  offset_1: extern UInt16
  selector: extern UInt16
  zero: extern UInt8
  type: extern UInt8
  offset_2: extern UInt16
}

idt: IDTGate[256]

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
