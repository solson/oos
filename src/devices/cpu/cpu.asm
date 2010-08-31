bits 32

section .text
   
;;; loadGDT: func (GDTDescriptor*)
global loadGDT
loadGDT: 
   push  eax
   mov   eax, [esp+0x8]         ; get the struct pointer
   lgdt  [eax]                  ; load the GDT
   pop   eax
   ;; Reload CS register containing code selector:
   ;; We can't directly alter CS, so we far jump to change it
   jmp   0x08:.reload_CS        ; 0x08 points at the new code selector (2nd in our GDT)
.reload_CS:
   ;; Reload data segment registers:
   mov   ax, 0x10               ; 0x10 points at the new data selector (3rd in our GDT)
   mov   ds, ax
   mov   es, ax
   mov   fs, ax
   mov   gs, ax
   mov   ss, ax
   ;; return from loadGDT
   ret   

;;; loadIDT: func (IDTDescriptor*)
global loadIDT
loadIDT:
   push  eax
   mov   eax, [esp+0x8]         ; get the struct pointer
   lidt  [eax]                  ; load the IDT
   pop   eax
   ret                          ; return

;;; enableInterrupts: func
global enableInterrupts
enableInterrupts:
   sti   
   ret   

;;; disableInterrupts: func
global disableInterrupts
disableInterrupts:
   cli   
   ret   

;;; halt: func
global halt
halt:
   hlt
