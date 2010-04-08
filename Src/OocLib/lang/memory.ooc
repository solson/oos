import Hal/VMM

// Memory allocation functions
gc_malloc: func (size: SizeT) -> Pointer {
    alloc(size)
}

gc_malloc_atomic: func (size: SizeT) -> Pointer {
    gc_malloc(size)
}

gc_realloc: func (ptr: Pointer, size: SizeT) -> Pointer {
    null
}

gc_calloc: func (nmemb: SizeT, size: SizeT) -> Pointer {
    gc_malloc(nmemb * size)
}

free: func (ptr: Pointer) {
}

// Memory setting/copying functions
zeroMemory: func (ptr: Pointer, size: UInt32) -> Pointer {
    mem: UInt8* = ptr

    for (i in 0..size) {
        mem[i] = 0
    }

    return mem
}
