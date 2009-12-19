halOutPort: extern proto func (port: UInt16, val: UInt8)
halInPort: extern proto func (port: UInt16) -> UInt8

halOutPortWord: extern proto func (port: UInt16, val: UInt16)
halInPortWord: extern proto func (port: UInt16) -> UInt16

halOutPortLong: extern proto func (port: UInt16, val: UInt32)
halInPortLong: extern proto func (port: UInt16) -> UInt32

