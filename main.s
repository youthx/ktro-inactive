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
  sub rsp, 16
  mov DWORD PTR [rbp-4], edi
  mov QWORD PTR [rbp-16], rsi

  cmp DWORD PTR [rbp-4], 1
  jg .main0
    mov rax, QWORD PTR [rbp-16]
    mov rax, QWORD PTR [rax]
    mov rsi, rax
    mov edi, OFFSET FLAT:.usage_str
    call fmw

    mov eax, 0
    jmp .main1

.main0:
  mov eax, 0
  
.main1:
  leave
  ret
  
# gives a weird error w/o this
.section .note.GNU-stack, ""
