bits 16
org 0x7c00

section .text

jmp 0x0:_start

%include 'src/mbr/bios_parameter_block.asm'
%include 'src/eltorito/load_stage2_cdd.asm'

_start:
  cli

  mov ax, 0x0
  mov ds, ax

  mov si, StartMessage
  call print

  ; Try to load from the hard drive.
  call load_stage2_cdd    ; Attempt to load stage2 from hard disk.
  jc fail                 ; Bail if loading stage2 failed.

  ; TODO: Figure out how to store 0x7e00 somewhere.
  jmp 0x7e00   ; 0x7e00 needs to match load_stage2_*.asm.

fail:
  mov si, FailureMessage
  call print
  jmp halt


halt:
  cli
  hlt
  jmp halt

print:
  mov ah, 0xe
  mov bh, 0
  .type:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .type
  .done:
    ret

StartMessage    db `Loading Semplice Stage 2 from hard disk... `, 0
FailureMessage  db `Failed to load Stage 2.\r\n`, 0


times 510-($-$$) db 0x0
dw 0xaa55
