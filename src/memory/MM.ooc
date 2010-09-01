import Kernel, Multiboot, Panic, Bochs
import structs/Bitmap

MM: cover {
    /// Memory region covered by one frame. (4kB)
    FRAME_SIZE := static 4096

    /// Amount of memory (in bytes) in the computer.
    memorySize: static SizeT

    /// Total amount of memory in use.
    usedMemory: static SizeT
   
    /// Amount of free memory (in bytes).
    freeMemory: static SizeT {
        get {
            if(usedMemory > memorySize) {
                Bochs warn("The amount of allocated memory is higher than the amount of available memory!")
                return 0
            }
            memorySize - usedMemory
        }
    }

    /** Bitmap frames (each frame is a 4 kB memory area). If a bit is
        set, the corresponding frame is used. */
    bitmap: static Bitmap

    /// The last-used index in the Bitmap array.
    lastElement: static UInt
    
    /// Address used for pre-heap memory allocation.
    placementAddress := static Kernel end as SizeT

    /// Address space containing shared memory between processes.
    sharedSpace: static UInt*

    alloc: static func ~defaultAlignment (size: SizeT) -> Pointer {
        alloc(size, 1)
    }

    alloc: static func (size: SizeT, alignment: UInt16) -> Pointer {
        mem := null

        if(size == 0 || alignment == 0) {
            Bochs warn("Someone was smart enough to specify a length or alignment of 0!")
            return null
        }

        if(freeMemory < size) {
            Bochs warn("Not enough memory to allocate!")
            return null
        }

        // Placement allocation only allowed for the kernel when
        // dynamic memory is not available yet.
        if(alignment > 1)
            placementAddress = placementAddress align(alignment)
        
        mem = placementAddress as Pointer
        placementAddress += size
        usedMemory += size
        
        mem
    }

    free: static func (ptr: Pointer) {
    }

    allocFrame: static func -> UInt {
        // If we can't find a free frame, we will try again from the
        // beginning if the lastElement wasn't already 0.
        tryAgain := lastElement != 0
        
        for(elem in lastElement..bitmap size) {
            if(bitmap allSet?(elem))
                continue

            for(bit in 0..32) {
                if(bitmap clear?(elem, bit)) {
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
            return allocFrame()
        }
        
        // If still nothing was found, the entire bitmap is set, and there is
        // no free memory!
        panic("The physical memory manager did not find any free physical frames!")
        return 0
    }

    allocFrame: static func ~address (address: SizeT) {
        address /= FRAME_SIZE
        bitmap set(address / 32, address % 32)
    }

    freeFrame: static func (address: SizeT) {
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

        // Map the shared virtual address space to itself.
        sharedSpace = alloc(FRAME_SIZE, FRAME_SIZE)
        memset(sharedSpace, 0 as UInt8, FRAME_SIZE)

        sharedSpace[1023] = (sharedSpace as SizeT) | 4 | 2 | 1

        placementAddress = placementAddress align(FRAME_SIZE)
        
        pageTable := null as UInt*
        physAddr := placementAddress

        i := 0 as SizeT
        while(i < placementAddress) {
            // Need to move to the next page table?
            if((i / FRAME_SIZE) % 1024 == 0) {
                // Allocate a frame for this page table and map it.
                allocFrame(physAddr)
                sharedSpace[i / FRAME_SIZE / 1024] = physAddr | 4 | 2 | 1

                pageTable = physAddr as UInt*
                memset(pageTable, 0 as UInt8, FRAME_SIZE)

                physAddr += FRAME_SIZE
            }

            // Identity map this region.
            allocFrame(i)
            pageTable[i / FRAME_SIZE] = i | 4 | 2 | 1
            
            i += FRAME_SIZE
        }

        // NOTE: All memory up until the page table containing physAddr is seen as allocated.
        placementAddress = physAddr align(0x400000)
        usedMemory = placementAddress
        
        // Parse the memory map from GRUB.
        parseMemoryMap()

        Bochs debug("Taking the plunge...")
        // Switch and activate paging.
        switchAddressSpace(sharedSpace)
        Bochs debug("Swan dive!")

//        activatePaging()
//        Bochs debug("A perfect entry!")
    }

    parseMemoryMap: static func {
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

    activatePaging: static func {
        setCR0(getCR0() bitSet(31))
    }

    switchAddressSpace: static extern proto func (addressSpace: UInt*)
    getCR0: static extern proto func -> SizeT
    setCR0: static extern proto func (cr0: SizeT)
}