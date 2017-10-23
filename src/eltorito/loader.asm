%define INFORMATION_BLOCK_FILE 'src/eltorito/boot_information_table.asm'
%define STAGE2_LOADER_FILE 'src/stage1-common/load_stage2_cdd.asm'

%macro LOAD_STAGE2 0
  ; Try to load from the CD drive.
  print Stage2LoadCDD          ; Defined in stage1-common/loader.asm
  call load_stage2_cdd         ; Attempt to load stage2 from CD.
  ;jnc run_stage2              ; Run stage2 if it was loaded successfully.
%endmacro

%include "src/stage1-common/loader.asm"
