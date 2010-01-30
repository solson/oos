import Multiboot
import Hal/[Hal, Display]
import Printf

// from the Linker.ld linker script
kernelEnd: extern proto Int
kernelStart: extern proto Int

kmain: func (mb: MultibootInfo@, magic: UInt32) {
  halInit()

  printf("This kernel is written in ")
  halDisplaySetAttr(COLOR_LGREEN, COLOR_BLACK)
  printf("ooc")
  halDisplaySetAttr(COLOR_LGREY, COLOR_BLACK)
  printf("!\n\n")

  printf("Boot Loader: ")
  halDisplaySetAttr(COLOR_LBLUE, COLOR_BLACK)
  printf("%s\n", mb bootLoaderName)
  halDisplaySetAttr(COLOR_LGREY, COLOR_BLACK)

  printf("Command Line: ")
  halDisplaySetAttr(COLOR_LBLUE, COLOR_BLACK)
  printf("%s\n\n", mb cmdline)
  halDisplaySetAttr(COLOR_LGREY, COLOR_BLACK)

  printf("Kernel Start: 0x%x\n", kernelStart&)
  printf("Kernel End:   0x%x\n", kernelEnd&)

  while(1){}
}
