import Kernel

VMM: class {
    placementAddress := static kernelEnd& as Pointer

    alloc: static func (size: SizeT) -> Pointer {
        mem := placementAddress
        placementAddress += size
        return mem
    }
}
