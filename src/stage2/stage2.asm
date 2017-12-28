; asmsyntax=nasm

bits 16
org 0x7e00

jmp _start
%include "src/stage2/a20_enable.asm"

_start:

call enable_a20

cli

; Load a GDT
xor ax, ax
mov ds, ax
lgdt [gdt_desc]

; Switch to protected mode
mov eax, cr0
or eax, 1
mov cr0, eax

jmp 0x08:_pmode

_pmode:

bits 32

mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

mov byte [ds:0xb8000], 'a'
mov byte [ds:0xb8001], 0x2f

mov esp, 0x90000

mov byte [ds:0xb8000], 'b'

hlt

%include "src/stage2/gdt.asm"
