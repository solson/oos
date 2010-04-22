import Kernel, PMM, Multiboot

VMM: class {
    placementAddress := static kernelEnd& as Pointer

    setup: static func {

        // Parse the memory map from GRUB
        i := multiboot mmapAddr

        while(i < multiboot mmapAddr + multiboot mmapLength) {
            mmapEntry := i as MMapEntry*

            "%s0x%08x-0x%08x (%i kB)" format(
                (mmapEntry@ type == 1 ? "Available: " : "Reserved:  "),
                mmapEntry@ baseAddrLow,
                mmapEntry@ baseAddrLow + mmapEntry@ lengthLow - 1,
                mmapEntry@ lengthLow / 1024) println()

            // Anything other than 1 means reserved. We set reserved memory to
            // allocated in the physical memory manager.
            if(mmapEntry@ type != 1) {
                for(j in (mmapEntry@ baseAddrLow)..(mmapEntry@ baseAddrLow + mmapEntry@ lengthLow)) {
                    PMM allocFrame(j)
                }
            }

            i += mmapEntry@ size + sizeof(mmapEntry@ size)
        }
    }

    alloc: static func (size: SizeT) -> Pointer {
        mem := placementAddress
        placementAddress += size
        return mem
    }
}
