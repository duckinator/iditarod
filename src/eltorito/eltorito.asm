bits 16
org 0x7c00

section .text

jmp 0x0:_start

%include 'src/eltorito/boot_information_table.asm'
%include 'src/eltorito/load_stage2.asm'

_start:
  cli

  ; Attempt to load stage2 from CD.
  call load_stage2

  ; Jump to stage2 if it's been loaded successfully.
  ; 0x7e00 needs to match load_stage2_hdd.asm.
;  jnc 0x7e00

  ; If we get here, we've failed to load stage2, so print the failure message.
  mov ax, 0x0
  mov ds, ax

  mov si, FailureMessage

  mov ah, 0xe
  mov bh, 0
  .print_character:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .print_character
  .done:

halt:
  cli
  hlt
  jmp halt

FailureMessage  db `Failed to load Semplice Stage 2.\r\n`, 0

times 510-($-$$) db 0x0
dw 0xaa55
