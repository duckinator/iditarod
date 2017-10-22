; TODO: Actually implement. Currently copypasta from load_stage2_hdd.asm.

load_stage2_cdd:
  mov si, cdd_data_address_packet
  mov ah, 0x42  ; ?
  mov dl, 0x80  ; Drive number. (?)
  int 0x13

  ret

cdd_data_address_packet:
  db  16        ; Length in bytes.
  db  0         ; Always zero.
  dw  16        ; Number of blocks to read. (I think?)
  dw  0x7E00    ; Memory buffer destination address (0:7e00).
                ; Needs to match load_stage2_floppy.asm and loader.asm.
  dw  0         ; Memory page.
  dd  1, 0      ; LBA to be read.
