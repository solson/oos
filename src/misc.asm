bits 32

section .text

;;;
;;; Miscellaneous
;;; 

;;; stackDump: func
extern stackDumpHex
global stackDump
stackDump:
   push  ebp
   mov   ebp, esp
   call  stackDumpHex
   pop   ebp
   ret
