bits 16
cpu TARGET

enable_a20:
  cli

  call .a20wait
  mov al, 0xad
  out 0x64, al

  call .a20wait
  mov al, 0xd0
  out 0x64, al

  call .a20wait2
  in al, 0x60
  %ifidni TARGET, 286
    push ax
  %else
    push eax
  %endif

  call .a20wait
  mov al, 0xd1
  out 0x64, al

  call .a20wait
  %ifidni TARGET, 286
    pop ax
  %else
    pop eax
  %endif
  or al, 2
  out 0x60, al

  call .a20wait
  mov al, 0xae
  out 0x64, al

  call .a20wait
  sti
  ret

.a20wait:
  in al, 0x64
  test al, 2
  jnz .a20wait
  ret

 
.a20wait2:
  in al, 0x64
  test al, 1
  jz .a20wait2
  ret
