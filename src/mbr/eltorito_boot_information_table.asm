section .text

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
