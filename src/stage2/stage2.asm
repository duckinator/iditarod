bits 32
org 0x7e00

mov ax, 0x10
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

mov byte [ds:0xb8000], 'a'
mov byte [ds:0xb8001], 0x2f

mov esp, 0x90000

mov byte [ds:0xb8000], 'b'

hlt
