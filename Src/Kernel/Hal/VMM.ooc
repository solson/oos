import Kernel

placementAddress := kernelEnd& as Pointer

alloc: func (size: SizeT) -> Pointer {
    mem := placementAddress
    placementAddress += size
    return mem
}
