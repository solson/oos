import devices/Ports

Bochs: cover {
    // Bochs uses this port to let us print to the bochs console.
    PORT_E9 := static 0xE9

    // Read http://bochs.sourceforge.net/doc/docbook/development/iodebug.html
    // iodebug command port.
    IODEBUG_COMMAND := static 0x8A00
    // iodebug enable command.
    IODEBUG_ENABLE := static 0x8A00
    // iodebug breakpoint command.
    IODEBUG_BREAKPOINT := static 0x8AE0

    // This function drops to the debugger in bochs. It only works if
    // you compile bochs with --enable-iodebug and --enable-debugger,
    // which is incompatible with --enable-gdb-stub.
    breakpoint: static func {
        // Enable the bochs iodebug module.
        Ports outWord(IODEBUG_COMMAND, IODEBUG_ENABLE)
        // Drop to debugger prompt.
        Ports outWord(IODEBUG_COMMAND, IODEBUG_BREAKPOINT)
    }

    print: static func ~char (chr: Char) {
        Ports outByte(PORT_E9, chr as UInt8)
    }

    print: static func ~string (str: String) {
        for(i in 0..str length()) {
            print(str[i])
        }
    }

    println: static func (str: String) {
        print(str)
        print('\n')
    }

    debug: static func (str: String) {
        print("[DEBUG] ")
        println(str)
    }

    warn: static func (str: String) {
        print("[WARNING] ")
        println(str)
    }

    error: static func (str: String) {
        print("[ERROR] ")
        println(str)
    }
}
