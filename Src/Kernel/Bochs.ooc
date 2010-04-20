import Hal/Ports

Bochs: cover {
  // bochs uses this port to let us print to the bochs console
  PORT_E9 := const static 0xE9

  // read http://bochs.sourceforge.net/doc/docbook/development/iodebug.html
  // iodebug command port
  IODEBUG_COMMAND := const static 0x8A00

  // this function drops to the debugger in bochs, like a breakpoint
  // only works if you compile bochs with --enable-iodebug and
  // --enable-debugger, which is incompatible with --enable-gdb-stub
  breakpoint: static func {
    Ports outWord(IODEBUG_COMMAND, 0x8A00) // enable the bochs iodebug module
    Ports outWord(IODEBUG_COMMAND, 0x8AE0) // drop to debugger prompt
  }

  printChar: static func (chr: Char) {
    Ports outByte(PORT_E9, chr)
  }

  print: static func (str: String) {
    for(i in 0..str length()) {
      printChar(str[i])
    }
  }

  println: static func (str: String) {
    print(str)
    printChar('\n')
  }
}
