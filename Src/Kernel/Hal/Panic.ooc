import Printf, Hal/[Interrupts, Halt]
 
panic: func(fmt: String, ...) {
	args: VaList
	va_start(args, fmt)
	printf("PANIC:\n")
	vprintf(fmt, args)
	disableInterrupts()
	halt()
}
