// The magic number passed by a Multiboot-compliant boot loader
MULTIBOOT_BOOTLOADER_MAGIC := 0x2BADB002

// The Multiboot header
MultibootHeader: cover {
  magic,
  flags,
  checksum,
  headerAddr,
  loadAddr,
  loadEndAddr,
  bssEndAddr,
  entryAddr: ULong
}

// The symbol table for a.out.
AoutSymbolTable: cover {
  tabsize,
  strsize,
  addr,
  reserved: ULong
}

// The section header table for ELF.
ElfSectionHeaderTable: cover {
  num,
  size,
  addr,
  shndx: ULong
}

// The Multiboot information.
MultibootInfo: cover {
  // required
  flags,

  // present if flags[0] is set
  memLower,
  memUpper,

  // flags[1]
  bootDevice,

  // flags[2]
  cmdline,

  // flags[3]
  modsCount,
  modsAddr: ULong

  // normally, flags[4] means this would be AoutSymbolTable, and flags[5]
  // would mean it's ElfSectionHeaderTable, but ooc can't do unions so we just
  // drop the aout part, because oos uses an ELF kernel anyways
  elfSec: ElfSectionHeaderTable

  // flags[6]
  mmapLength,
  mmapAddr,

  // flags[7]
  drivesLength,
  drivesAddr,

  // flags[8]
  configTable,

  // flags[9]
  bootLoaderName,

  // flags[10]
  apmTable,

  // flags[11]
  vbeControlInfo,
  vbeModeInfo,
  vbeMode,
  vbeInterfaceSeg,
  vbeInterfaceOff,
  vbeInterfaceLen: ULong
}

// The module structure.
MultibootModule: cover {
  modStart,
  modEnd,
  string,
  reserved: ULong
}

// The memory map. Be careful that the offset 0 is base_addr_low
// but no size.
MemoryMap: cover {
  size,
  baseAddrLow,
  baseAddrHigh,
  lengthLow,
  lengthHigh,
  type: ULong
}

