import Hal/Ports

// read http://bochs.sourceforge.net/doc/docbook/development/iodebug.html

// this function drops to the debugger in bochs, like a breakpoint
bochsBreak: func {
  halOutPortWord(0x8A00,0x8A00) // enable the bochs iodebug module
  halOutPortWord(0x8A00,0x8AE0) // drop to debugger prompt
}

