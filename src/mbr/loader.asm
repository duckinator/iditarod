bits 16
org 0x7c00

global _start

section .text

jmp 0x0:_start

%include 'src/mbr/bios_parameter_block.asm'

%include 'src/mbr/print.asm'
%include 'src/mbr/a20_enable.asm'
%include 'src/mbr/load_stage2_hdd.asm'
%include 'src/mbr/load_stage2_floppy.asm'

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

  print Stage2LoadFDD

  call load_stage2_floppy       ; Attempt to load stage2 from floppy disk.
  jc  .stage2_load_error_floppy ; Go to error handler if load failed.
  jmp .run_stage2               ; Run stage2 if load succeeded.

  .stage2_load_error_floppy:
    print Stage2LoadHDD
    call load_stage2_hdd        ; Attempt to load stage2 from hard disk.
    jc  .stage2_load_error      ; Go to error handler if load failed.
    jmp .run_stage2             ; Run stage2 if load succeeded.

  .stage2_load_error:
    print Stage2LoadFail
    jmp _halt

  .run_stage2:
    cli

    ; Load a GDT
    xor ax, ax
    mov ds, ax
    lgdt [gdt_desc]

    ; Switch to protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ; TODO: Figure out how to store 0x7e00 somewhere.
    jmp 0x08:0x7e00   ; 0x7e00 needs to match load_stage2_*.asm.

    jmp _halt

IDString        db `Semplice Stage 1\r\n`, 0
A20Enabling     db 'Enabling A20... ', 0
Stage2LoadFDD   db `Loading Stage 2 from floppy disk... `, 0
Stage2LoadHDD   db `Failed.\r\nLoading Stage 2 from hard disk... `, 0
Stage2LoadFail  db `\r\nERROR: Could not load Stage 2.\r\n`, 0
Done            db `Done.\r\n`, 0

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
