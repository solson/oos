global _start           ; making entry point visible to linker
extern kmain            ; kmain is defined elsewhere

;;; setting up the Multiboot header - see GRUB docs for details
MODULEALIGN equ  1<<0                   ; align loaded modules on page boundaries
MEMINFO     equ  1<<1                   ; provide memory map
FLAGS       equ  MODULEALIGN | MEMINFO  ; this is the Multiboot 'flag' field
MAGIC       equ    0x1BADB002           ; 'magic number' lets bootloader find the header
CHECKSUM    equ -(MAGIC + FLAGS)        ; checksum required
 
section .text
align 4
MultiBootHeader:
   dd MAGIC
   dd FLAGS
   dd CHECKSUM

;;; the Global Descriptor Table
gdt:

gdt_null:
        dq 0

gdt_code:
        dw 0xFFFF    ; first 16 bits of segment limiter
	dw 0         ; first 16 bits of base address
	db 0         ; next 8 bits of base address
	db 10011010b ; code segment, readable, nonconforming
	db 11001111b ; ganular, last 3 bits of segment limiter
	db 0         ; final 8 bits of base address

gdt_data:
	dw 0xFFFF       ; first 16 bits of segment limiter
        dw 0            ; first 16 bits of base address
        db 0            ; next 8 bits of base address
        db 10010010b    ; data segment, writable, extends downwards
        db 11001111b    ; big
        db 0            ; final 8 bits of base address
 
gdt_end:

;; GDT descriptor for LGDT instruction
gdt_desc:
        dw gdt_end - gdt - 1    ; GDT size - 1
        dd gdt                  ; address of the GDT

;;; control starts here
_start:
        mov esp, stacktop       ; set up the stack

        lgdt [gdt_desc]         ; load the GDT
        
reload_segments:
        ;; Reload CS register containing code selector:
        jmp 0x08:.reload_CS      ; 0x08 points at the new code selector
.reload_CS:
        ;; Reload data segment registers:
        mov ax, 0x10            ; 0x10 points at the new data selector
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax
        jmp 0x08:kernel_start
        
kernel_start: 
        push eax                ; pass Multiboot magic number
        push ebx                ; pass Multiboot info structure

        call kmain              ; call kernel proper

        cli
hang:
        hlt                     ; halt machine if the kernel returns
        jmp   hang

section .bss
align 4
stack:
   resb 0x4000                  ; reserve 16k for the stack on a doubleword boundary
stacktop:
