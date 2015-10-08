cpu TARGET
%ifidn TARGET, 286
    bits 16
%else
    bits 32
%endif
org 0x7e00

mov ax, 0x10
mov ds, ax
mov ss, ax
%ifidn TARGET, 386
    mov es, ax
    mov fs, ax
    mov gs, ax
%endif


%ifidn TARGET, 286
    mov ax, 0x18 ;Our shiny new video segment.
    mov es, ax
    
    mov byte [es:0x8000], 'a'
    mov byte [es:0x8001], 0x2f
    mov sp, 0x9000 ;SS == DS
    mov byte [es:0x8000], 'b'

%else
    mov byte [ds:0xb8000], 'a'
    mov byte [ds:0xb8001], 0x2f
    
    mov esp, 0x90000
    
    mov byte [ds:0xb8000], 'b'
%endif

hlt
