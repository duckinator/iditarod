bits 16
org 0x7c00

section .text

jmp 0x0:_start

%include 'src/mbr/bios_parameter_block.asm'

%include 'src/mbr/print.asm'
%include 'src/eltorito/load_stage2_cdd.asm'

_start:
  cli

  mov ax, 0x0
  mov ds, ax

  print IDString

  ; Try to load from the hard drive.
  print Stage2LoadCDD
  call load_stage2_cdd    ; Attempt to load stage2 from hard disk.
  jc fail                 ; Bail if loading stage2 failed.

  ; TODO: Figure out how to store 0x7e00 somewhere.
  jmp 0x7e00   ; 0x7e00 needs to match load_stage2_*.asm.

fail:
  print Stage2LoadFail
  jmp halt


halt:
  cli
  hlt
  jmp halt

IDString        db `Semplice Stage 1\r\n`, 0
A20Enabling     db 'Enabling A20... ', 0
Stage2LoadCDD   db `Loading Stage 2 from CD... `, 0
Stage2LoadFail  db `\r\nERROR: Could not load Stage 2.\r\n`, 0
Failed          db `Failed.\r\n`, 0
Done            db `Done.\r\n`, 0

times 510-($-$$) db 0x0
dw 0xaa55
