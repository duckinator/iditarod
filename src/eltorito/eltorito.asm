bits 16
org 0x7c00

section .text

jmp 0x0:_start

; Boot Information Table is always at offset 8.
; Causes an assembler error if it's preceded by more than 8 bytes worth of
; code.
times 8-($-$$) db 0

; Boot Information Table
PrimaryVolumeDescriptor  resd  1    ; LBA of the Primary Volume Descriptor
BootFileLocation         resd  1    ; LBA of the Boot File
BootFileLength           resd  1    ; Length of the boot file in bytes
Checksum                 resd  1    ; 32 bit checksum
Reserved                 resb  40   ; Reserved 'for future standardization'

_start:
  cli

  ; TODO: Load stage2 from the CD.

  ; If we get here, we've failed to load stage2, so print the failure message.
  mov si, FailureMessage

  mov ah, 0xe
  .print_character:
    lodsb
    cmp al, 0
    jz halt
    int 0x10
    jmp .print_character

halt:
  cli
  hlt
  jmp halt

FailureMessage  db `Can't load Semplice Stage 2.\r\n`, 0

times 510-($-$$) db 0x0
dw 0xaa55
