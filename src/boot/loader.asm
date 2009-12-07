global _start

jmp _start

%include "src/boot/a20_test.asm"

[bits 32]

[section .text]

_start:
%include "src/boot/a20_enable.asm"

TIMES 510-($-$$) DB 0
SIGNATURE DW 0xAA55
