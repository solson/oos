import Ports

print: func (str: String) {
    Display printString(str)
}

println: func (str: String) {
    Display printString(str)
    Display printChar('\n')
}

Color: enum {
    black = 0
    blue
    green
    cyan
    red
    magenta
    brown
    lightGrey
    darkGrey
    lightBlue
    lightGreen
    lightCyan
    lightRed
    lightMagenta
    yellow
    white
}

Display: cover {
    VIDEO_MEMORY := static 0xb8000 as UInt16*

    INDEX_PORT := static 0x3d4
    DATA_PORT  := static 0x3d5

    CURSOR_LOW_PORT  := static 0xE
    CURSOR_HIGH_PORT := static 0xF

    CONSOLE_WIDTH  := static 80
    CONSOLE_HEIGHT := static 25

    color: static UInt8
    fg: static Color
    bg: static Color
    cursor_x: static Int
    cursor_y: static Int

    setup: static func {
        // Default to light grey on black like the BIOS.
        setColor(Color lightGrey, Color black)
        clearScreen()
    }

    setColor: static func (fg, bg: Color) {
        This fg = fg
        This bg = bg
        This color = ((fg & 0xf) | bg << 4) as UInt8
    }

    setColor: static func ~withFn (fg, bg: Color, fn: Func) {
        oldFg := This fg
        oldBg := This bg
        setColor(fg, bg)
        fn()
        setColor(oldFg, oldBg)
    }

    setFgColor: static func (fg: Color) {
        setColor(fg, This bg)
    }

    setFgColor: static func ~withFn (fg: Color, fn: Func) {
        oldFg := This fg
        setFgColor(fg)
        fn()
        setFgColor(oldFg)
    }

    setBgColor: static func (bg: Color) {
        setColor(This fg, bg)
    }

    setBgColor: static func ~withFn (bg: Color, fn: Func) {
        oldBg := This bg
        setBgColor(bg)
        fn()
        setBgColor(oldBg)
    }

    clearScreen: static func {
        for(i in 0..(CONSOLE_HEIGHT * CONSOLE_WIDTH)) {
            VIDEO_MEMORY[i] = (' ' | color << 8) as UInt16
        }
        cursor_x = 0
        cursor_y = 0
        updateCursor()
    }

    updateCursor: static func {
        position := cursor_y * CONSOLE_WIDTH + cursor_x

        Ports outByte(INDEX_PORT, CURSOR_LOW_PORT)
        Ports outByte(DATA_PORT, position >> 8)

        Ports outByte(INDEX_PORT, CURSOR_HIGH_PORT)
        Ports outByte(DATA_PORT, position)
    }

    printChar: static func (chr: Char) {
        // Handle a backspace, by moving the cursor back one space
        if(chr == '\b') {
            if (cursor_x != 0) cursor_x -= 1
        }

        // Handles a tab by incrementing the cursor's x, but only
        // to a point that will make it divisible by 8
        else if(chr == '\t') {
            cursor_x = cursor_x align(8)
        }

        // Handles a 'Carriage Return', which simply brings the
        // cursor back to the margin
        else if(chr == '\r') {
            cursor_x = 0
        }

        // We handle our newlines the way DOS and the BIOS do: we
        // treat it as if a 'CR' was also there, so we bring the
        // cursor to the margin and we increment the 'y' value
        else if(chr == '\n') {
            cursor_x = 0
            cursor_y += 1
        }

        // Any character greater than and including a space, is a
        // printable character. The equation for finding the index
        // in a linear chunk of memory can be represented by:
        // Index = [(y * width) + x]
        else if(chr >= ' ') {
            i := cursor_y * CONSOLE_WIDTH + cursor_x
            VIDEO_MEMORY[i] = (chr | color << 8) as UInt16
            cursor_x += 1
        }

        // If the cursor has reached the edge of the screen's width, we
        // insert a new line in there
        if(cursor_x >= CONSOLE_WIDTH) {
            cursor_x = 0
            cursor_y += 1
        }

        // If the cursor has gone below the bottom of the screen, we
        // scroll the screen
        if(cursor_y >= CONSOLE_HEIGHT) {
            cursor_y -= 1
            scroll()
        }

        updateCursor()
    }

    scroll: static func {
        for(row in 1..CONSOLE_HEIGHT) {
            for(col in 0..CONSOLE_WIDTH) {
                VIDEO_MEMORY[(row - 1) * CONSOLE_WIDTH + col] = VIDEO_MEMORY[row * CONSOLE_WIDTH + col]
            }
        }

        for(col in 0..CONSOLE_WIDTH) {
            VIDEO_MEMORY[(CONSOLE_HEIGHT - 1) * CONSOLE_WIDTH + col] = (' ' | color << 8) as UInt16
        }
    }

    printString: static func (str: String) {
        for(i in 0..str length()) {
            printChar(str[i])
        }
    }
}
