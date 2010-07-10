import Kernel, PMM, Multiboot

VMM: class {
    placementAddress := static kernelEnd& as Pointer

    setup: static func {

        // Parse the memory map from GRUB
        i := multiboot mmapAddr

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
                    PMM allocFrame(j)
                    j += PMM FRAME_SIZE
                }
            }

            i += mmapEntry@ size + mmapEntry@ size class size
        }
    }

    alloc: static func (size: SizeT) -> Pointer {
        mem := placementAddress
        placementAddress += size
        return mem
    }
}
