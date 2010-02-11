import Multiboot
import Hal/Hal
import Hal/Display into Display
import Printf

// from the Linker.ld linker script
kernelEnd: extern proto Int
kernelStart: extern proto Int

kmain: func (mb: MultibootInfo@, magic: UInt32) {
  initHal()

  printf("This kernel is written in ")
  Display setAttr(Display LIGHT_GREEN, Display BLACK)
  printf("ooc")
  Display setAttr(Display LIGHT_GREY, Display BLACK)
  printf("!\n\n")

  printf("Boot Loader: ")
  Display setAttr(Display LIGHT_BLUE, Display BLACK)
  printf("%s\n", mb bootLoaderName)
  Display setAttr(Display LIGHT_GREY, Display BLACK)

  printf("Command Line: ")
  Display setAttr(Display LIGHT_BLUE, Display BLACK)
  printf("%s\n\n", mb cmdline)
  Display setAttr(Display LIGHT_GREY, Display BLACK)

  printf("Kernel Start: 0x%x\n", kernelStart&)
  printf("Kernel End:   0x%x\n", kernelEnd&)

  while(1){}
}
