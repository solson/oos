import devices/[CPU, Display, Keyboard], memory/MM

Kernel: cover {
    setup: static func {
        Display setup()
        MM setup()
        CPU setup()
        Keyboard setup()
        CPU enableInterrupts()
    }

    start: static Pointer = kernelStart&
    end:   static Pointer = kernelEnd&
}

// from the linker.ld linker script
kernelStart: extern proto Int
kernelEnd:   extern proto Int
