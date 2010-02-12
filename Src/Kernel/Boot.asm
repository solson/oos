bits 32

global boot  ; making entry point visible to linker
extern kmain ; kmain is defined in Main.ooc


;;; Multiboot header. See GRUB docs for details
MODULEALIGN equ 1<<0                  ; align loaded modules on page boundaries
MEMINFO     equ 1<<1                  ; provide memory map
FLAGS       equ MODULEALIGN | MEMINFO ; this is the Multiboot 'flag' field
MAGIC       equ 0x1BADB002            ; 'magic number' lets bootloader find the header
CHECKSUM    equ -(MAGIC + FLAGS)      ; checksum required


section .text
align 4

MultiBootHeader:
    dd MAGIC
    dd FLAGS
    dd CHECKSUM

;;; The OS gains control right here
boot:
    mov esp, stacktop ; set up the stack

    push eax          ; pass Multiboot magic number
    push ebx          ; pass Multiboot info structure

    call kmain        ; call kernel proper

    cli               ; disable interupts if kmain returns
hang:
    hlt               ; halt machine if kmain returns
    jmp hang


section .bss
align 4

stack:
    resb 0x4000 ; reserve 16k for the stack on a doubleword boundary
stacktop:       ; the top of the stack is the bottom because the stack counts down
