bits 32

global loadGDT

section .text

loadGDT:
    push eax
    mov eax, [esp+0x8]
    lgdt [eax]     ; load the GDT
    pop eax

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

    ;; return from loadGDT
    ret
