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

;;; switchAddressSpace: func (addressSpace: UInt32)
global switchAddressSpace
switchAddressSpace:
   ;; FIXME: Can I just mov cr3, [esp+4]?
   mov   eax, [esp+4]           ; addressSpace
   mov   cr3, eax
   ret
