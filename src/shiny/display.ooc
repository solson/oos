WHITE_TEXT: const Int = 0x07

clearScreen: func {
        vidmem := 0xb8000 as Char*
        i := 0
        while(i < (80*25*2)) { // That's 80 columns and 25 rows, 2 bytes each
                vidmem[i] = ' ' // set to space (blank)
                i += 1
                vidmem[i] = WHITE_TEXT
                i += 1
        }
}

printString: func (message: Char*, line: UInt) -> UInt {
        vidmem := 0xb8000 as Char*
        i := line * 80 * 2

        while(message@ != 0) {
                vidmem[i] = message@
                message += 1
                i += 1
                vidmem[i] = WHITE_TEXT
                i += 1
        }

        return 1
}
