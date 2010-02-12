bits 32

global initGDT

section .text

initGDT:
        lgdt [gdt_desc]         ; load the GDT

reload_segments:
        ;; Reload CS register containing code selector:
        ;; We can't directly alter CS, so we far jump to change it
        jmp 0x08:.reload_CS ; 0x08 points at the new code selector (2nd in our GDT)
.reload_CS:
        ;; Reload data segment registers:
        mov ax, 0x10 ; 0x10 points at the new data selector (3rd in our GDT)
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax

        ;; return from initGDT
        ret

section .data

;;; the Global Descriptor Table
gdt:

gdt_null:
        ;; the null descriptor. intel says we need it, so we need it.
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

;;; GDT descriptor for LGDT instruction
gdt_desc:
        dw gdt_end - gdt - 1    ; size of GDT - 1 because it can go up
                                ; to 65536 and can't be 0
        dd gdt                  ; address of the GDT
