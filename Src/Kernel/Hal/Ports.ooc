Ports: class {
    outByte: extern proto static func (port: UInt16, val: UInt8)
    inByte:  extern proto static func (port: UInt16) -> UInt8

    outWord: extern proto static func (port: UInt16, val: UInt16)
    inWord:  extern proto static func (port: UInt16) -> UInt16

    outLong: extern proto static func (port: UInt16, val: UInt32)
    inLong:  extern proto static func (port: UInt16) -> UInt32
}
