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
  Display setForeground(Display LIGHT_GREEN)
  printf("ooc")
  Display setForeground(Display LIGHT_GREY)
  printf("!\n\n")

  printf("Boot Loader: ")
  Display setForeground(Display LIGHT_BLUE)
  printf("%s\n", mb bootLoaderName)
  Display setForeground(Display LIGHT_GREY)

  printf("Command Line: ")
  Display setForeground(Display LIGHT_BLUE)
  printf("%s\n\n", mb cmdline)
  Display setForeground(Display LIGHT_GREY)

  printf("Kernel Start: 0x%x\n", kernelStart&)
  printf("Kernel End:   0x%x\n", kernelEnd&)

  while(1){}
}
