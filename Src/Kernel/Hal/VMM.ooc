import Kernel

VMM: cover {
    placementAddress := static kernelEnd& as Pointer

    alloc: static func (size: SizeT) -> Pointer {
        mem := placementAddress
        placementAddress += size
        return mem
    }
}
