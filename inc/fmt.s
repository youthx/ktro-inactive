
.fmr_LC0:
  .asciz "error: could not read from stdin\n"
  
# format write to stdout
# available args: [edi-...] (OFFSET FLAT)
fmw:
  push rbp
  mov rbp, rsp
  mov eax, 0
  call printf
  
  xor eax, eax
  pop rbp
  ret

# format read to stdin
# edi -> buf size
fmr:
  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov DWORD PTR [rbp-20], edi
  mov eax, DWORD PTR [rbp-20]
  cdqe
  mov rdi, rax
  call malloc
  mov QWORD PTR [rbp-8], rax
  mov rdx, QWORD PTR stdin[rip]
  mov ecx, DWORD PTR [rbp-20]
  mov rax, QWORD PTR [rbp-8]
  mov esi, ecx
  mov rdi, rax
  call fgets
  test rax, rax
  je .fmr2
  mov rax, QWORD PTR [rbp-8]
  jmp .fmr3

  .fmr2:
    mov edi, OFFSET FLAT:.fmr_LC0
    call fmw
    mov edi, 1
    call exit

  .fmr3:
    leave
    ret
  
