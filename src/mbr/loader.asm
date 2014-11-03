bits 16
org 0x7c00

global _start

section .text

jmp 0x0:_start

%include 'src/mbr/bios_parameter_block.asm'

%include 'src/mbr/print.asm'
%include "src/mbr/a20_enable.asm"

_halt:
  cli
  .halt:
    hlt
    jmp .halt

_start:
  cli

  mov ax, 0x0
  mov ds, ax

  print IDString

  print A20Enabling
  call enable_a20
  print Done

  print Stage2Loading

  ; Reset drives
  mov ah, 0x0
  mov dl, 0x0
  int 0x13

  ; Read from drive
  mov ax, 0x0
  mov es, ax
  mov bx, 0x7e00
  mov ah, 0x02
  mov al, 0x1
  mov ch, 0x0
  mov cl, 0x2
  mov dh, 0x0
  mov dl, 0x0
  int 0x13
  
  ; Reset drives
  mov ah, 0x0
  mov dl, 0x0
  int 0x13

  ; Read from drive
  mov ax, 0x2000
  mov es, ax
  mov bx, 0x0
  mov ah, 0x02
  mov al, 0x9
  mov ch, 0x0
  mov cl, 0x3
  mov dh, 0x0
  mov dl, 0x0
  int 0x13

  cli

  ; Load a GDT
  xor ax, ax
  mov ds, ax
  lgdt [gdt_desc]

  ; Switch to protected mode
  mov eax, cr0
  or eax, 1
  mov cr0, eax

  jmp 0x08:0x7e00

  jmp _halt

IDString      db `Semplice Stage 1\r\n`, 0
A20Enabling   db 'Enabling A20... ', 0
Stage2Loading db `Loading Stage 2...`, 0
Done          db `Done.\r\n`, 0

gdt:

gdt_null:
  dd 0
  dd 0

gdt_code:
  dw 0xffff
  dw 0
  db 0
  db 10011010b
  db 11001111b
  db 0

gdt_data:
  dw 0xffff
  dw 0
  db 0
  db 10010010b
  db 11001111b
  db 0

gdt_end:

gdt_desc:
  dw gdt_end - gdt - 1
  dd gdt

times 510-($-$$) db 0x0
dw 0xaa55
