// The magic number passed by a Multiboot-compliant boot loader
MULTIBOOT_BOOTLOADER_MAGIC := 0x2BADB002

// Multiboot Flags
MULTIBOOT_FLAG_MEM     := 1 << 0
MULTIBOOT_FLAG_DEVICE  := 1 << 1
MULTIBOOT_FLAG_CMDLINE := 1 << 2
MULTIBOOT_FLAG_MODS    := 1 << 3
MULTIBOOT_FLAG_AOUT    := 1 << 4
MULTIBOOT_FLAG_ELF     := 1 << 5
MULTIBOOT_FLAG_MMAP    := 1 << 6
MULTIBOOT_FLAG_CONFIG  := 1 << 7
MULTIBOOT_FLAG_LOADER  := 1 << 8
MULTIBOOT_FLAG_APM     := 1 << 9
MULTIBOOT_FLAG_VBE     := 1 << 10

// Global variable for multiboot info so it can be accessed everywhere.
multiboot: MultibootInfo

// Structure containing information received from GRUB (or any
// other Multiboot-compliant bootloader).
MultibootInfo: cover {
  flags, // Determines which fields below are present.

  memLower, // Amount of lower memory in the computer (in kB).
  memUpper, // Amount of higher memory in the computer (in kB).

  bootDevice, // The boot device which is used to boot the kernel.

  cmdline, // The command line passed to the OS by GRUB. Example: /System/oos.exe

  modsCount, // Amount of modules loaded (e.g. ramdisks).
  modsAddr,  // Address of the modules.

  // ELF stuff.
  elfNumber,
  elfSize,
  elfAddress,
  elfShndx,

  mmapLength, // Memory map length.
  mmapAddr,   // Memory map starting address.

  // Example: root (fd0)
  drivesLength, // Amount of drives available.
  drivesAddr,   // Starting address of the drives.

  configTable,

  bootLoaderName, // Name of the bootloader. Example: GNU GRUB 0.97

  apmTable, // APM (Advanced Power Management) table.

  vbeControlInfo,
  vbeModeInfo,
  vbeMode,
  vbeInterfaceSegment,
  vbeInterfaceOffset,
  vbeInterfaceLength: UInt32
}

// The module structure.
MultibootModule: cover {
  moduleStart,
  moduleEnd,
  string,
  reserved: UInt32
}

// Memory map entry.
MMapEntry: cover {
  size,         // Size of the structure (not counting this variable).
  baseAddrLow,  // Memory region starting address.
  baseAddrHigh, // Upper 32-bits of the previous value (for 64-bits systems).
  lengthLow,    // Memory region length.
  lengthHigh,   // Upper 32-bits of the previous value (for 64-bits systems).
  type: UInt32  // Type (1 = available RAM, 0 = reserved).
}
