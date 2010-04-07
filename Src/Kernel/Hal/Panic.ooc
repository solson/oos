import Printf, Hal/[Interrupts, Halt]

panic: func(fmt: String, ...) {
	args: VaList
	va_start(args, fmt)
	"PANIC:" println()
	vprintf(fmt, args)
	disableInterrupts()
	halt()
}
