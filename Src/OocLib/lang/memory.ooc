import Hal/MM

// Memory allocation functions
gc_malloc: func (size: SizeT) -> Pointer {
    MM alloc(size)
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
zeroMemory: func (ptr: Pointer, count: SizeT) -> Pointer {
    memset(ptr, 0 as UInt8, count)
}

memset: func <T> (dest: Pointer, val: T, count: SizeT) -> Pointer {
    destination := dest as T*

    for(i in 0..count) {
      destination[i] = val
    }

    return destination
}

memcpy: func (dest, src: Pointer, count: SizeT) -> Pointer {
    destination := dest as UInt8*
    source := src as UInt8*

    for(i in 0..count) {
      destination[i] = source[i]
    }

    return destination
}
