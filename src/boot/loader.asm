bits 16
org 0x7c00

global _start

section .text

	mov ax, 0x0
	mov ds, ax
	jmp 0x0:_start

%include 'src/boot/print.asm'
%include "src/boot/a20_test.asm"
%include "src/boot/a20_enable.asm"

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
		

	jmp _halt

A20String db 'A20',13,10,0
IDString db 'Semplice Stage 1',13,10,0

dw 0xaa55

