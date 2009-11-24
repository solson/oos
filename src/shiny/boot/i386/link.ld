ENTRY(_start)

SECTIONS {
	. = 0x100000;

	.text : ALIGN (0x1000) {
		*(.mboot)
		*(.text)
	}

	.rodata ALIGN (0x1000) : {
		*(.rodata)
	}

	.data ALIGN (0x1000) : {
		*(.data)
	}

	.bss ALIGN (0x1000) : {
		sbss = .;
		*(COMMON)
		*(.bss)
		ebss = .;
	}

	end = .;
}

