; Boot Information Table
PrimaryVolumeDescriptor  resd  1    ; LBA of the Primary Volume Descriptor
BootFileLocation         resd  1    ; LBA of the Boot File
BootFileLength           resd  1    ; Length of the boot file in bytes
Checksum                 resd  1    ; 32 bit checksum
Reserved                 resb  40   ; Reserved 'for future standardization'
