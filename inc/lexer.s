.include "./inc/err.s"
.include "./inc/fmt.s"

STRING_FORMAT: .asciz "%s"
  
.emsg_no_src: 
  .asciz "error: no source provided.\n"

fmw_err: #(err e) -> void
  push rbp
  mov rbp, rsp
  sub rsp, 16
  mov rax, rdi
  mov rcx, rsi
  mov rdx, rcx
  mov QWORD PTR [rbp-16], rax
  mov QWORD PTR [rbp-8], rdx
  mov eax, DWORD PTR [rbp-8]
  test eax, eax
  je .fmw_err0
    mov rax, QWORD PTR [rbp-16]
    mov rsi, rax
    mov edi, OFFSET FLAT:STRING_FORMAT
    call fmw
    jmp .fmw_errF
.fmw_err0:
  nop
.fmw_errF:
  leave
  ret
    
lex: #(char* src, char** beg, char** end) -> err
  push rbp
  mov rbp, rsp
  mov QWORD PTR [rbp-24], rdi # char* src
  mov QWORD PTR [rbp-32], rsi # char** beg
  mov QWORD PTR [rbp-40], rdx # char** end
  
  # !src ?
  cmp QWORD PTR [rbp-24], 0
  jne .lex0
    mov QWORD PTR [rbp-16], OFFSET FLAT:.emsg_no_src
    mov DWORD PTR [rbp-8], 5 # err type 
    mov rax, QWORD PTR [rbp-16]
    mov rdx, QWORD PTR [rbp-8]
    jmp .lexF
.lex0:
  # return: OK (no errors present)
  mov rax, QWORD PTR ERR_OK[rip]
  mov rdx, QWORD PTR ERR_OK[rip+8]
.lexF:
  pop rbp
  ret
  