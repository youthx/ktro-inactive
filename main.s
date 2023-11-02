.intel_syntax noprefix
.include "./lib/ktro.s"
.global main

.success_msg:
  .asciz "Compiled Successfully!\n"
  
.usage_str: 
  .asciz "usage: %s [file]\n"

main:
  push rbp
  mov rbp, rsp

  mov edi, OFFSET FLAT:.success_msg
  call fmw
  
  mov eax, 0
  leave
  ret
  

# gives a weird error w/o this
.section .note.GNU-stack, ""
