cpu TARGET

load_stage2_floppy:
  ; Reset drives
  mov ah, 0x0
  mov dl, 0x0
  int 0x13

  ; Read from drive
  mov ax, 0x0
  mov es, ax
  mov bx, 0x7e00    ; Memory buffer destination address (0:7e00).
                    ; Needs to match load_stage2_hdd.asm and loader.asm.
  mov ah, 0x02
  mov al, 0x1
  mov ch, 0x0
  mov cl, 0x2
  mov dh, 0x0
  mov dl, 0x0
  int 0x13
  
  ; Reset drives
  mov ah, 0x0
  mov dl, 0x0
  int 0x13

  ; Read from drive
  mov ax, 0x2000
  mov es, ax
  mov bx, 0x0
  mov ah, 0x02
%ifidn FDDSIZE, 360
  mov al, 0x06
%else
  mov al, 0x9
%endif
  mov ch, 0x0
  mov cl, 0x3
  mov dh, 0x0
  mov dl, 0x0
  int 0x13

  ret
