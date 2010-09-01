Bitmap: class {
    size: UInt
    data: UInt32*

    init: func (=size) {
        data = gc_malloc(UInt32 size * size) as UInt32*
        memset(data, 0 as UInt32, UInt32 size * size)
    }

    set: func (index, bit: UInt) {
        data[index] |= (1 << bit)
    }

    set?: func (index, bit: UInt) -> Bool {
        (data[index] & (1 << bit)) as Bool
    }

    // This is a quick way to check if all the bits in an element are set.
    allSet?: func (index: UInt) -> Bool {
        data[index] == 0xFFFFFFFF
    }

    clear: func (index, bit: UInt) {
        data[index] &= ~(1 << bit)
    }

    clear?: func (index, bit: UInt) -> Bool {
        !(data[index] & (1 << bit))
    }
}
