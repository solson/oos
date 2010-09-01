bits 32

section .text

;;;
;;; Paging
;;;

;;; Stolen from OSDynamix:
;;; #define INVLPG(virt)             ASMV("invlpg (%%eax)" : : "a" (virt))
;;; #define SWITCH_ADDRESS_SPACE(x)  ASMV("mov %0, %%CR3" : : "r" ((dword) (x)))

;;; invalidatePage: func (virt: Pointer)
global invalidatePage
invalidatePage:
   mov   eax, [esp+4]           ; virt
   invlpg [eax]                 
   ret

;;; switchAddressSpace: func (addressSpace: UInt*)
global switchAddressSpace
switchAddressSpace:
   mov   eax, [esp+4]           ; addressSpace
   mov   cr3, eax
   ret

;;; getCR0: func -> SizeT
global getCR0
getCR0:
   mov   eax, cr0               ; return value
   ret

;;; setCR0: func (cr0: SizeT)
global setCR0
setCR0:
   mov   eax, [esp+4]           ; cr0
   mov   cr0, eax
   ret
