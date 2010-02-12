outByte: extern proto func (port: UInt16, val: UInt8)
inByte:  extern proto func (port: UInt16) -> UInt8

outWord: extern proto func (port: UInt16, val: UInt16)
inWord:  extern proto func (port: UInt16) -> UInt16

outLong: extern proto func (port: UInt16, val: UInt32)
inLong:  extern proto func (port: UInt16) -> UInt32
