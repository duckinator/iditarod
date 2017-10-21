section .text

BytesPerSector      equ    0x000B
SectorsPerCluster   equ    0x000D
ReservedSectors     equ    0x000E
FatCopies           equ    0x0010
RootDirEntries      equ    0x0011
NumSectors          equ    0x0013
MediaType           equ    0x0015
SectorsPerFAT       equ    0x0016
SectorsPerTrack     equ    0x0018
NumberOfHeads       equ    0x001A
HiddenSectors       equ    0x001C
SectorsBig          equ    0x0020

BIOSParameterBlock:
  dw BytesPerSector
  db SectorsPerCluster
  dw ReservedSectors
  db FatCopies
  dw RootDirEntries
  dw NumSectors
  db MediaType
  dw SectorsPerFAT
  dw SectorsPerTrack
  dw NumberOfHeads
  dd HiddenSectors
  dd SectorsBig
