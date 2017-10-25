bits 16
org 0x7c00

section .text

jmp 0x0:_start

; Boot Information Table is always at offset 8.
; This line causes an assembler error if all of the code preceding this line
; generates more than 8 bytes of machine code.
times 8-($-$$) db 0

; Boot Information Table
PrimaryVolumeDescriptor  resd  1    ; LBA of the Primary Volume Descriptor
BootFileLocation         resd  1    ; LBA of the Boot File
BootFileLength           resd  1    ; Length of the boot file in bytes
Checksum                 resd  1    ; 32 bit checksum
Reserved                 resb  40   ; Reserved 'for future standardization'

_start:
  cli

  ; BIOS has loaded this code at 0000:7c00.
  ; Relocate it from 0000:7c00 to 9000:0000.
    mov ax, 0           ; Set ax to 0.

    mov ds, ax          ; DS:SI = 0000:----.
    mov si, 0x7c00      ; DS:SI = 0000:7c00.

    mov ax, 0x9000      ; ????
    mov es, ax          ; ES:DI = 9000:----.
    mov di, 0           ; ES:DI = 9000:0000.

    mov cx, 0x0800      ; 2048 bytes -- The BIOS loaded the first 2k from disk.
    rep
    movsb               ; Do the relocation

    jmp 0x9000:($ - $$ + 1) ; Jump to the instruction following this jmp.

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
