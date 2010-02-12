bits 32

global loadIDT

section .text

loadIDT:
    push eax
    mov eax, [esp+0x8]  ; get the struct pointer
    lidt [eax]          ; load the IDT
    pop eax
    ret                 ; return
