.include "./lib/lexer.s"

/*
    usage: ktro [file]
*/

ktro_compile: # (char* src) -> void*
  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov QWORD PTR [rbp-24], rdi

  mov rax, QWORD PTR [rbp-24]
  mov rdi, rax
  call init_lexer
  mov QWORD PTR [rbp-8], rax
  
  
  nop
  pop rbp
  ret
  