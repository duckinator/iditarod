bits 16

_print:
  mov ah, 0xe
  mov bh, 0
  .type:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .type
  .done:
    ret

%macro print 1
  mov si, %1
  call _print
%endmacro
