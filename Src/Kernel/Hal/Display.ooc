import Ports

print: func (str: String) {
    Display printString(str)
}

println: func (str: String) {
    Display printString(str)
    Display printChar('\n')
}

Color: class {
    black        := static 0x0
    blue         := static 0x1
    green        := static 0x2
    cyan         := static 0x3
    red          := static 0x4
    magenta      := static 0x5
    brown        := static 0x6
    lightGrey    := static 0x7
    darkGrey     := static 0x8
    lightBlue    := static 0x9
    lightGreen   := static 0xa
    lightCyan    := static 0xb
    lightRed     := static 0xc
    lightMagenta := static 0xd
    yellow       := static 0xe
    white        := static 0xf
}

Display: class {
    VIDEO_MEMORY := static 0xb8000 as UInt16*

    INDEX_PORT := static 0x3d4
    DATA_PORT  := static 0x3d5

    CURSOR_LOW_PORT  := static 0xE
    CURSOR_HIGH_PORT := static 0xF

    attr: static UInt8
    foreground: static Int
    background: static Int
    cursor_x: static Int
    cursor_y: static Int

    setup: static func {
      // default to light grey on black like the BIOS
      setAttr(Color lightGrey, Color black)
      clearScreen()
    }

    setAttr: static func (fg, bg: Int) {
      foreground = fg
      background = bg
      attr = (fg & 0xf) | bg << 4
    }

    setForeground: static func (fg: Int) {
      setAttr(fg, background)
    }

    setBackground: static func (bg: Int) {
      setAttr(foreground, bg)
    }

    clearScreen: static func {
      for (row in 0..25) {
        for (col in 0..80) {
          VIDEO_MEMORY[row * 80 + col] = ' ' | attr << 8
        }
      }
      cursor_x = 0
      cursor_y = 0
      updateCursor()
    }

    updateCursor: static func {
      position := cursor_y * 80 + cursor_x

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
        cursor_x = (cursor_x + 8) & ~(8 - 1)
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
        i := cursor_y * 80 + cursor_x
        VIDEO_MEMORY[i] = chr | attr << 8
        cursor_x += 1
      }

      // If the cursor has reached the edge of the screen's width, we
      // insert a new line in there
      if(cursor_x >= 80) {
        cursor_x = 0
        cursor_y += 1
      }

      updateCursor()
    }

    printString: static func (str: String) {
      for(i in 0..str length()) {
        printChar(str[i])
      }
    }
}
