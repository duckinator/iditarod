bits 16
org 0x7c00

global _start

section .text

	mov ax, 0x0
	mov ds, ax
	jmp 0x0:_start

%include 'src/mbr/print.asm'
%include "src/mbr/a20_test.asm"
%include "src/mbr/a20_enable.asm"

_halt:
	cli
	.halt:
		hlt
		jmp .halt

_start:
	cli

	mov si, IDString
	call print

	call check_a20
	cmp ax, 1
	je .a20_enabled

	.a20_not_enabled:
		call enable_A20

	.a20_enabled:
		mov si, A20String
		call print

	; Reset drives
	mov ah, 0x0
	mov dl, 0x0
	int 0x13

	; Read from drive
	mov ax, 0x0
	mov es, ax
	mov bx, 0x7e00
	mov ah, 0x02
	mov al, 0x1
	mov ch, 0x0
	mov cl, 0x2
	mov dh, 0x0
	mov dl, 0x0
	int 0x13

	jmp 0x7e00

	jmp _halt

A20String db 'A20',13,10,0
IDString db 'Semplice Stage 1',13,10,0

times 510-($-$$) db 0x0
dw 0xaa55
