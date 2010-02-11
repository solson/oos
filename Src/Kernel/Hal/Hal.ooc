import GDT into GDT
import IDT into IDT
import ISR into ISR
import IRQ into IRQ
import Interrupts into Interrupts
import SysCall into SysCall
import Display into Display
import Printf

init: func {
  GDT init()
  Display init()

  runInitializer("IDT", IDT init)
  runInitializer("ISRs", ISR init)
  runInitializer("IRQs", IRQ init)
  runInitializer("syscalls", SysCall init)

  printf("Enabling interrupts... ")
  Interrupts enable()
  printf("Done.\n\n")
}

runInitializer: func (name: String, f: Func) {
  printf("Initializing %s... ", name)
  f()
  printf("Done.\n")
}
