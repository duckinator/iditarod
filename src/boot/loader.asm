; Yay http://www.osdever.net/tutorials/ch01.php and 
; http://wiki.osdev.org/A20

global _start

jmp _start

[bits 16]

[section .data]
MA20Enabling:       db   'Enabling A20.            '
MA20EnablingEnd:
MA20AlreadyEnabled: db   'A20 Previously enabled.  '
MA20AlreadyEnabledEnd:

[section .text]
%include "src/boot/print.asm"
%include "src/boot/a20_test.asm"
%include "src/boot/a20_enable.asm"

_start:
  cli

	mov bx, 000Fh			; Page 0, color attribute 15 (white) for the int 10 calls below
	mov cx, 1			; We will write 1 char
	xor dx, dx			; Start at top-left corner
	mov ds, dx			; Ensure ds = 0 (to let us load the message)
	cld				; Ensure direction flag is cleared for LODSB

  ; Test if a20 has been set up
  call check_a20

  cmp ax, 1         ; Check if ax was set to 1 by check_a20 (see a20_test.asm)
  je a20_enabled    ; Don't enable a20 if it was already done


a20_not_enabled:
  ; Enable a20 if need be
  call enable_A20
  jmp a20_enabled 

a20_enabled:
  push MA20EnablingEnd
  push MA20Enabling
  call print
  add esp, 8
  ;mov ax, 0xb800
  ;mov ds, ax
  ;mov byte [ds:0x0], 'a'
  ;mov byte [ds:0x1], 0x1f

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
