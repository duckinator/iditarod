bits 32
org 0x7e00

mov eax, 0x10
mov ds, eax
mov es, eax
mov fs, eax
mov gs, eax
mov ss, eax

mov ax, 0xb800
mov ds, ax
mov byte [ds:0x0], 'a'
mov byte [ds:0x1], 0x2f

mov esp, 0x90000

mov byte [ds:0xb8000], 'b'