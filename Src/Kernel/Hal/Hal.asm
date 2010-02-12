bits 32

section .text

;; loadGDT: func (GDTDescriptor*)
global loadGDT
loadGDT:
    push eax
    mov eax, [esp+0x8] ; get the struct pointer
    lgdt [eax]         ; load the GDT
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


;; loadIDT: func (IDTDescriptor*)
global loadIDT
loadIDT:
    push eax
    mov eax, [esp+0x8]  ; get the struct pointer
    lidt [eax]          ; load the IDT
    pop eax
    ret                 ; return


;; enableInterrupts: func
global enableInterrupts
enableInterrupts:
	sti
	ret


;; disableInterrupts: func
global disableInterrupts
disableInterrupts:
	cli
	ret


;; halt: func
global halt
halt:
	hlt



;;;
;;; Ports
;;;

;; outByte: func (port: UInt16, val: UInt8)
global outByte
outByte:
	mov eax, [esp+8] ; val
	mov edx, [esp+4] ; port
	out dx, al
	ret


;; inByte: func (port: UInt16) -> UInt8
global inByte
inByte:
	mov edx, [esp+4] ; port
	in al, dx
	ret


;; outWord: func (port: UInt16, val: UInt16)
global outWord
outWord:
	mov eax, [esp+8] ; val
	mov edx, [esp+4] ; port
	out dx, ax
	ret


;; inWord: func (port: UInt16) -> UInt16
global inWord
inWord:
	mov edx, [esp+4] ; port
	in ax, dx
	ret


;; outLong: func (port: UInt16, val: UInt32)
global outLong
outLong:
	mov eax, [esp+8] ; val
	mov edx, [esp+4] ; port
	out dx, eax
	ret


;; inLong: func (port: UInt16) -> UInt32
global inLong
inLong:
	mov edx, [esp+4] ; port
	in eax, dx
	ret



;;;
;;; Exceptions, ISRs, IRQs, SysCalls
;;;

extern isrHandler
extern irqHandler

global isrSyscall
isrSyscall:
	cli
	push 0
	push 0x80
	jmp isrCommon
	iret

%macro HANDLER_COMMON 1
%1Common:
	pusha
	push ds
	push es
	push fs
	push gs
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov eax, esp
	push eax
	mov eax, %1Handler
	call eax
	pop eax
	pop gs
	pop fs
	pop es
	pop ds
	popa
	add esp, 8
	iret
%endmacro

; ISRs!

%macro ISR_COMMON 1
global isr%1
isr%1:
	cli
	push byte 0
	push byte %1
	jmp isrCommon
	iret
%endmacro

%macro ISR_ABORT 1
	ISR_COMMON %1
%endmacro

%macro ISR_FAULT 1
	ISR_COMMON %1
%endmacro

%macro ISR_INTR 1
	ISR_COMMON %1
%endmacro

%macro ISR_RESV 1
	ISR_COMMON %1
%endmacro

%macro ISR_TRAP 1
	ISR_COMMON %1
%endmacro

section .text

ISR_FAULT 0
ISR_FAULT 1
ISR_INTR 2
ISR_TRAP 3
ISR_TRAP 4
ISR_FAULT 5
ISR_FAULT 6
ISR_FAULT 7
ISR_ABORT 8
ISR_FAULT 9
ISR_FAULT 10
ISR_FAULT 11
ISR_FAULT 12
ISR_FAULT 13
ISR_FAULT 14
ISR_FAULT 15
ISR_FAULT 16
ISR_FAULT 17
ISR_ABORT 18
ISR_FAULT 19
ISR_RESV 20
ISR_RESV 21
ISR_RESV 22
ISR_RESV 23
ISR_RESV 24
ISR_RESV 25
ISR_RESV 26
ISR_RESV 27
ISR_RESV 28
ISR_RESV 29
ISR_RESV 30
ISR_RESV 31

HANDLER_COMMON isr

; IRQs!

%macro IRQ_COMMON 2
global irq%1
irq%1:
	cli
	push byte 0
	push byte %2
	jmp irqCommon
	iret
%endmacro

IRQ_COMMON 0,  32
IRQ_COMMON 1,  33
IRQ_COMMON 2,  34
IRQ_COMMON 3,  35
IRQ_COMMON 4,  36
IRQ_COMMON 5,  37
IRQ_COMMON 6,  38
IRQ_COMMON 7,  39
IRQ_COMMON 8,  40
IRQ_COMMON 9,  41
IRQ_COMMON 10, 42
IRQ_COMMON 11, 43
IRQ_COMMON 12, 44
IRQ_COMMON 13, 45
IRQ_COMMON 14, 46
IRQ_COMMON 15, 47

HANDLER_COMMON irq
