import Printf, Hal/[Interrupts, System]

panic: func(fmt: String, ...) {
	args: VaList

	va_start(args, fmt)

	"PANIC:" println()
	vprintf(fmt, args)

	Interrupts disable()
	System halt()
}
