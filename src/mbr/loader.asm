%define INFORMATION_BLOCK_FILE 'src/mbr/bios_parameter_block.asm'
%define STAGE2_LOADER_FILE 'src/stage1-common/load_stage2_hdd.asm'

%macro LOAD_STAGE2 0
  ; Try to load from the hard drive.
  print Stage2LoadHDD         ; Defined in stage1-common/loader.asm
  call load_stage2_hdd        ; Attempt to load stage2 from hard disk.
  jnc run_stage2              ; Run stage2 if it was loaded successfully.
%endmacro

%include "src/stage1-common/loader.asm"
