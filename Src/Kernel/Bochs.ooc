import Hal/Ports

// read http://bochs.sourceforge.net/doc/docbook/development/iodebug.html

Bochs: cover {
  // this function drops to the debugger in bochs, like a breakpoint
  // only works if you compile bochs with --enable-iodebug and
  // --enable-debugger, which is incompatible with --enable-gdb-stub
  breakpoint: static func {
    Ports outWord(0x8A00,0x8A00) // enable the bochs iodebug module
    Ports outWord(0x8A00,0x8AE0) // drop to debugger prompt
  }

  printChar: static func (chr: Char) {
    Ports outByte(0xE9, chr)
  }

  printString: static func (str: String) {
    for(i in 0..str length()) {
      printChar(str[i])
    }
  }
}
