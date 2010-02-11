outByte: extern(halOutPortByte) proto func (port: UInt16, val: UInt8)
inByte:  extern(halInPortByte)  proto func (port: UInt16) -> UInt8

outWord: extern(halOutPortWord) proto func (port: UInt16, val: UInt16)
inWord:  extern(halInPortWord)  proto func (port: UInt16) -> UInt16

outLong: extern(halOutPortLong) proto func (port: UInt16, val: UInt32)
inLong:  extern(halInPortLong)  proto func (port: UInt16) -> UInt32
