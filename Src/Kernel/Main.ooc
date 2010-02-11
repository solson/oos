import Multiboot
import Hal/Hal into Hal
import Hal/Display into Display
import Printf

// from the Linker.ld linker script
kernelEnd: extern proto Int
kernelStart: extern proto Int

kmain: func (mb: MultibootInfo@, magic: UInt32) {
  Hal init()

  printf("This kernel is written in ")
  Display setAttr(COLOR_LGREEN, COLOR_BLACK)
  printf("ooc")
  Display setAttr(COLOR_LGREY, COLOR_BLACK)
  printf("!\n\n")

  printf("Boot Loader: ")
  Display setAttr(COLOR_LBLUE, COLOR_BLACK)
  printf("%s\n", mb bootLoaderName)
  Display setAttr(COLOR_LGREY, COLOR_BLACK)

  printf("Command Line: ")
  Display setAttr(COLOR_LBLUE, COLOR_BLACK)
  printf("%s\n\n", mb cmdline)
  Display setAttr(COLOR_LGREY, COLOR_BLACK)

  printf("Kernel Start: 0x%x\n", kernelStart&)
  printf("Kernel End:   0x%x\n", kernelEnd&)

  while(1){}
}
