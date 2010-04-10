import Multiboot, Panic

Bitmap: cover from UInt32* {
    size: UInt

    new: static func (=size) -> This {
        bm := gc_malloc(sizeof(UInt32) * size) as This
        memset(bm, 0 as UInt32, sizeof(UInt32) * size)
        return bm
    }

    set: func (index, bit: UInt) {
        this[index] |= (1 << bit)
    }

    isSet: func (index, bit: UInt) -> Bool {
        this[index] & (1 << bit)
    }

    // This is a quick way to check if all the bits in an element are set.
    allSet: func (index: UInt) -> Bool {
        this[index] == 0xFFFFFFFF
    }

    clear: func (index, bit: UInt) {
        this[index] &= ~(1 << bit)
    }
}

PMM: class {
    FRAME_SIZE := static 4096 // 4kB

    memorySize: static UInt
    lastElement: static UInt
    bitmap: static Bitmap

    setup: static func {
        // memUpper is given in kB, but we want B
        memorySize = multiboot memUpper * 1024

        frameCount := memorySize / FRAME_SIZE

        // 4 bytes equals 32 bits, use 1 bit per frame.
        elementCount := frameCount / 32

        // Add an extra element for the remainder of the frames if not aligned
        if(frameCount % 32) {
            elementCount += 1
        }

        bitmap = Bitmap new(elementCount)

        // If the last element used less than 32 bits, set the other bits to
        // make sure the allocator doesn't try to use them.
        for(i in (frameCount % 32)..32) {
            bitmap set(bitmap size - 1, i)
        }
    }

    allocFrame: func -> UInt {
        for(elem in lastElement..Bitmap size) {
            if(bitmap allSet(elem)) continue

            for(bit in 0..32) {
                if(bitmap isSet(elem, bit)) {
                    // We've found ourselves a free bit, allocate and return it.
                    bitmap set(elem, bit)
                    lastElement = elem
                    return elem * 32 + bit
                }
            }

            lastElement += 1
        }

        // If still nothing was found, the entire bitmap is set, and there is
        // no free memory!
        panic("The physical memory manager did not find any free physical frames!");
        return 0
    }

    allocFrame: func ~address (address: UInt) {
        address /= FRAME_SIZE
        bitmap set(address / 32, address % 32)
    }

    freeFrame: func (address: UInt) {
        address /= FRAME_SIZE
        bitmap clear(address / 32, address % 32)
    }
}
