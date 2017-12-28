; asmsyntax=nasm

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

DriveNumber              resb  1    ; Reserve space for the drive number.
DiskPacket               resb  32   ; Reserve space to shove bullshit in.
BytesPerSector           resw  1    ; Reserve space for bytes per sector.

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

  ; Set up segment registers.
  mov ax, cs ; what the actual fuck am I doing?
  mov ax, ds
  mov ax, 0
  mov es, ax
  mov ss, ax
  mov sp, 0x7c00

  ; Save the boot disk number.
  mov [DriveNumber], dl

  ; Get the number of bytes in a sector.
  ; Usually 2048 bytes.
  mov word [DiskPacket], 0x1a
  mov ah, 0x48
  mov al, 0
  mov si, DiskPacket
  mov dl, DriveNumber
  int 0x13
  jc assume_2k_sector

  mov ax, DiskPacket + 0x18 ; ??? what the fuck?
  mov [BytesPerSector], ax
  jmp load_sector

assume_2k_sector:
  ; Assume 2KB sector.
  ; Should probably print an error, but I don't really care right now.
  mov word [BytesPerSector], 0x0800

load_sector:
  ; stage2 is in the root directory of the disk.
  ; I have no idea what I'm doing.
  ; Good luck.

fail:
  ; If we get here, we've failed to load stage2, so print the failure message.
  mov si, FailureMessage
  call print

halt:
  cli
  hlt
  jmp halt

print:
  ; Usage:
  ;     mov si, LocationOfString
  ;     call print
  mov ah, 0xe
  mov bh, 0
  .print_character:
    lodsb
    cmp al, 0
    jz .return
    int 0x10
    jmp .print_character
  .return:
    ret

FailureMessage  db `Can't load Iditarod Stage 2.\r\n`, 0

times 510-($-$$) db 0x0
dw 0xaa55
