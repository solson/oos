import Kernel, Multiboot, Panic, Bochs
import structs/Bitmap

MM: cover {
    /// Memory region covered by one frame. (4kB)
    FRAME_SIZE := static 4096

    /// Amount of memory (in bytes) in the computer.
    memorySize: static SizeT

    /// Total amount of memory in use.
    usedMemory: static SizeT

    /** Bitmap frames (each frame is a 4 kB memory area). If a bit is
        set, the corresponding frame is used. */
    bitmap: static Bitmap

    /// The last-used index in the Bitmap array.
    lastElement: static UInt
    
    /// Address used for pre-heap memory allocation.
    placementAddress := static kernelEnd& as Pointer
   
    /// Returns the amount of free memory (in bytes).
    getFreeMemory: static func -> SizeT {
        if(usedMemory > memorySize) {
            Bochs warn("For some reason, the amount of allocated memory is higher than the available memory!")
            return 0
        }

        return memorySize - usedMemory
    }

    alloc: static func (size: SizeT) -> Pointer {
        mem := placementAddress
        placementAddress += size
        usedMemory += size
        return mem
    }

    free: static func (ptr: Pointer) {
    }

    allocFrame: static func -> UInt {
        // If we can't find a free frame, we will try again from the
        // beginning if the lastElement wasn't already 0.
        tryAgain := lastElement != 0
        
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
        if(tryAgain) {
            lastElement = 0
            allocFrame()
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

        Bochs debug("Memory size: %i kB" format(multiboot memLower + multiboot memUpper))
        Bochs debug("Bitmap size: %i B" format(bitmap size * 4))

        usedMemory = placementAddress as SizeT
        
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
                    
                    // Only if it hasn't been included already.
                    if(j >= placementAddress)
                        usedMemory += FRAME_SIZE
                    
                    j += FRAME_SIZE
                }
            }

            i += mmapEntry@ size + mmapEntry@ size class size
        }

        '\n' print()
    }
}