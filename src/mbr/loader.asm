; asmsyntax=nasm

bits 16
org 0x7c00

%define STAGE2_ADDR 0x7e00

section .text

jmp 0x0:_start

BIOSParameterBlock:
  dw 0x000B ; BytesPerSector
  db 0x000D ; SectorsPerCluster
  dw 0x000E ; ReservedSectors
  db 0x0010 ; FatCopies
  dw 0x0011 ; RootDirEntries
  dw 0x0013 ; NumSectors
  db 0x0015 ; MediaType
  dw 0x0016 ; SectorsPerFAT
  dw 0x0018 ; SectorsPerTrack
  dw 0x001A ; NumberOfHeads
  dd 0x001C ; HiddenSectors
  dd 0x0020 ; SectorsBig

data_address_packet:
  db  16            ; Length in bytes.
  db  0             ; Always zero.
  dw  16            ; Number of blocks to read. (I think?)
  dw  STAGE2_ADDR   ; Memory buffer destination address.
  dw  0             ; Memory page.
  dd  1, 0          ; LBA to be read.

_start:
  cli

  ; Attempt to load stage2 from hard drive.
  mov si, data_address_packet
  mov ah, 0x42  ; Tell it we want to read sectors.
  mov dl, 0x80  ; Tell it to read them from the first hard drive.
  int 0x13      ; Request hard disk read from BIOS using the above information.

  ; Jump to stage2 if it's been loaded successfully.
  jnc STAGE2_ADDR

halt:
  cli
  hlt
  jmp halt

times 510-($-$$) db 0x0
dw 0xaa55
