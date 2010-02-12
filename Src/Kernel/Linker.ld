ENTRY(boot)

SECTIONS {
    /* 0x100000 = 1 MB. The kernel must be above 1 MB in order for GRUB to be able to load it. */
    . = 0x100000;
    kernelStart = .;

    .text ALIGN (0x1000) : {
        *(.text)
    }

    .rodata ALIGN (0x1000) : {
        *(.rodata)
    }

    .data ALIGN (0x1000) : {
        *(.data)
    }

    .bss ALIGN (0x1000) : {
        *(COMMON)
        *(.bss)
    }

    kernelEnd = .;
}
