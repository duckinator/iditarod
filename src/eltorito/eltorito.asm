bits 16
org 0x7c00

section .text

jmp 0x0:_start

; Boot Information Table is always at offset 8.
; This line causes an assembler error if all of the code preceding this line
; generates more than 8 bytes of machine code.
times 8-($-$$) db 0

; Boot Information Table.
; I think this is automagically populated, but I'm not sure.
PrimaryVolumeDescriptor  dd    0    ; Space for LBA of Primary Volume Descriptor
BootFileLocation         dd    0    ; Space for LBA of the Boot File
BootFileLength           dd    0    ; Space for length of the boot file in bytes
Checksum                 dd    0    ; Space for 32 bit checksum
Reserved                 times 40 db 0 ; Reserved 'for future standardization'

; Things that need to be manually populated.

DriveNumber              resb  1    ; Reserve space for the drive number.
DiskPacket               resb  32   ; Reserve space to shove bullshit in.
BytesPerSector           times 1  dw 0    ; Reserve space for bytes per sector.
SectorDescriptor         times 32 db 0  ; Reserve space for sector location.

LoadingMessage          db `Attempting to load Stage 2...\r\n`, 0
SectorReadErrorMessage  db `Failed to read sector.\r\n`, 0
GenericFailureMessage   db `Can't load Stage 2.\r\n`, 0

CDSignature     db `CD001`

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

  mov ax, DiskPacket + 0x18 ; ??? what the fuck?
  mov [BytesPerSector], ax

  ; stage2 is in /boot on the disk. Information about the root directory
  ; provided by PrimaryVolumeDescriptor.
  ; I think that should include information about subdirectories?
  ; Look at that for a directory named "BOOT", then look in that.
  ;
  ; I have no idea what I'm doing.

  ; Build data packet to request the BIOS load a sector.
    mov byte [DiskPacket], 0x10

    mov word [DiskPacket + 2], 1 ; i don't know

    ; Write the destination address
    mov word [DiskPacket + 4], bx
    mov word [DiskPacket + 6], es

    ; Write the logical sector to load
    mov long [DiskPacket + 8], eax
    mov long [DiskPacket + 12], 0

.read_sector:
  ; Read a single sector into memory.
  mov ah, 0x42
  mov al, 0
  mov si, DiskPacket
  mov dl, DriveNumber
  int 0x13
  jnc .read_sector_success

  mov si, SectorReadErrorMessage
  call print
  jmp halt

.read_sector_success:
  ; Update the sector to load.
  inc long [DiskPacket + 8]

  ; Update destination address.
  ; Instead of incrementing the offset, we increase the segment.
  ; Honestly, I'm just copypasta-ing this bullshit.
  mov word ax, BytesPerSector
  shr word ax, 4
  add word [DiskPacket + 6], ax
  loop .read_sector

  ret

print:
  mov ah, 0xe
  .print_character:
    lodsb
    cmp al, 0
    jz .done
    int 0x10
    jmp .print_character
  .done:
    ret

fail:
  ; If we get here, we've failed to load stage2, but don't know why,
  ; so print a generic failure message.
  mov si, GenericFailureMessage
  call print

halt:
  cli
  hlt
  jmp halt

times 510-($-$$) db 0x0
dw 0xaa55
