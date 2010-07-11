import Kernel, Multiboot, Panic
import structs/Bitmap

MM: class {
    /// Memory region covered by one frame. (4kB)
    FRAME_SIZE := static 4096

    /// Amount of memory (in bytes) in the computer.
    memorySize: static SizeT
    
    /// Address used for pre-heap memory allocation.
    placementAddress := static kernelEnd& as Pointer

    /** Bitmap frames (each frame is a 4 kB memory area). If a bit is
        set, the corresponding frame is used. */
    bitmap: static Bitmap

    /// The last-used index in the Bitmap array.
    lastElement: static UInt
    
    setup: static func {
        // memUpper and memLower are given in kB, but we want B
        memorySize = (multiboot memLower + multiboot memUpper) * 1024

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

        "Memory size: %i kB" printfln(multiboot memLower + multiboot memUpper)
        "Bitmap size: %i B\n" printfln(bitmap size * 4)

        // Parse the memory map from GRUB
        i := multiboot mmapAddr

        "Memory map:" println()

        while(i < multiboot mmapAddr + multiboot mmapLength) {
            mmapEntry := i as MMapEntry*

            "0x%08x-0x%08x (%s)" printfln(
                mmapEntry@ baseAddrLow,
                mmapEntry@ baseAddrLow + mmapEntry@ lengthLow - 1,
                mmapEntry@ type == 1 ? "Available" : "Reserved")

            // Anything other than 1 means reserved. Mark every frame in this
            // region as used.
            if(mmapEntry@ type != 1) {
                j := mmapEntry@ baseAddrLow
                while(j < mmapEntry@ baseAddrLow + mmapEntry@ lengthLow) {
                    allocFrame(j)
                    j += FRAME_SIZE
                }
            }

            i += mmapEntry@ size + mmapEntry@ size class size
        }

        '\n' print()
    }

    alloc: static func (size: SizeT) -> Pointer {
        mem := placementAddress
        placementAddress += size
        return mem
    }

    allocFrame: static func -> UInt {
        for(elem in lastElement..Bitmap size) {
            if(bitmap allSet(elem)) continue

            for(bit in 0..32) {
                if(!bitmap isSet(elem, bit)) {
                    // We've found ourselves a free bit, allocate and return it.
                    bitmap set(elem, bit)
                    lastElement = elem
                    return elem * 32 + bit
                }
            }

            lastElement += 1
        }

        // Maybe some frames we've already looked through have become available
        lastElement = 0

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
        panic("The physical memory manager did not find any free physical frames!")
        return 0
    }

    allocFrame: static func ~address (address: UInt) {
        address /= FRAME_SIZE
        bitmap set(address / 32, address % 32)
    }

    freeFrame: static func (address: UInt) {
        address /= FRAME_SIZE
        bitmap clear(address / 32, address % 32)
    }
}