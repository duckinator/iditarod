section .data
column db 2

section .text

print:
  mov dh, [column]

  push ebp
  mov ebp, esp
  mov si, [ebp+6]     ; Pops the beginning of the string into si
  mov di, [ebp+8]     ; Pop end of string into eax

print_char:
  mov ah, 2           ; PC BIOS Interrupt 10 Subfunction 2 - Set cursor position
                      ; AH = 2
                      ; BH = page, DH = row, DL = column
  int 10h
  lodsb               ; Loads a byte of the message into AL.
                      ; DS is 0 and SI holds the offset of one of the bytes of the message

  mov ah, 9           ; PC BIOS Interrupt 10 subfunction 9 - write character and color
                      ; AH = 9
                      ; BH = page, AL = character, BL = attribute, CX = character count
  int 10h

  inc dl              ; Advance cursor

  cmp dl, 80          ; Wrap around edge of screen if necessary (word-wrap)
  jne print_char.skip
  xor dl, dl          ; Back to the first char of the line
  inc dh              ; Next line!

  cmp dh, 25          ; Wrap around bottom of the screen if necessary
  jne print_char.skip
  xor dh, dh

  .skip:
    cmp si, di        ; If we're not at end of message
    jne print_char    ; continue loading characters
    mov esp, ebp
    pop ebp
    ret
