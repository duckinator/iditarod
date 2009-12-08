bits 16

mov ax, 0xb800
mov ds, ax
mov byte [ds:0x0], 'a'
mov byte [ds:0x1], 0x2f
jmp $
