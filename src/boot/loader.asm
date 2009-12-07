; Yay http://www.osdever.net/tutorials/ch01.php and 
; http://wiki.osdev.org/A20

global _start

jmp _start

[bits 32]

[section .text]

; Enable a20 if need be
%include "src/boot/a20_enable.asm"

; Test if a20 has been set up
%include "src/boot/a20_test.asm"
_start:
  cli

  ; Insert crap to load the kernel here
  jmp _hlt

  ; Set up the stack
  mov ax,0x100
  mov ss,ax
  mov sp,0x200

  ; Set up GDT Register
  GDTR:
    GDTsize DW 0x10 ; limit
    GDTbase DD 0x50 ; base address

  ; Load GDT
  lgdt[GDTR]

  ; Something with GDT?
NULL_SEL:
  DD 0
  DD 0
  
  ; Switch to real mode
  mov eax, cr0
  or al, 1
  mov cr0, eax
  
  ; Jump! *thud*
  ;jmp 08h:<what the heck goes here>

_start_kernel:
  ;call kmain ; Run the kernel
  jmp _hlt    ; In case the universe implodes and _hlt in fact is not next...

_hlt:
  cli
  hlt

; Enter protected mode

TIMES 510-($-$$) DB 0
SIGNATURE DW 0xAA55
