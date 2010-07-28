import Printf, Hal/[Interrupts, System]

panic: func(fmt: String, ...) {
	args: VaList

	va_start(args, fmt)

	"Panic: " print()
	vprintf(fmt, args)

    "\n\nStack trace:" println()
    stackDump()

	Interrupts disable()
	System halt()
}

stackDump: extern proto func

stackDumpHex: unmangled func (stack: UInt*) {
    originalStack := stack as UInt
    while(stack as UInt < originalStack align(0x1000)) {
        "\t%p: %p" printfln(stack, stack@)
        if(stack@ == 0x0)
            break
        stack += 1
    }
}
