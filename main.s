.intel_syntax noprefix
.include "./inc/lexer.s"
.global main

.success_msg:
  .asciz "Compiled successfully! :)\n"
  
FM_READ: .asciz "r"

.fo_error:
  .asciz "error: couldn't open file at %s\n"

.fgetpos_error: 
  .asciz "error: couldn't get file position.\n"

.fsetpos_error:
  .asciz "error: couldn't set file position.\n"
  
.usage_str: 
  .asciz "usage: %s [file]\n"

.SL0:
  .asciz "contents of %s:\n---\n%s\n---\n"
  
file_size: #(FILE* file) -> fpos_t
  push rbp
  mov rbp, rsp
  sub rsp, 64
  mov QWORD PTR [rbp-56], rdi # FILE* file
  
  lea rdx, [rbp-48] # fpos_t &out
  mov rax, QWORD PTR [rbp-56] # FILE* file
  mov rsi, rdx
  mov rdi, rax
  call fgetpos
  mov DWORD PTR [rbp-4], eax # int res

  # res != 0 ?
  cmp DWORD PTR [rbp-4], 0
  je .file_size0
    mov edi, OFFSET FLAT:.fgetpos_error
    call fmw

    mov eax, DWORD PTR [rbp-4]
    mov edi, eax
    call exit
.file_size0:
  mov rax, [rbp-56] # FILE* file
  mov edx, 2
  mov esi, 0
  mov rdi, rax
  call fseek

  mov rax, QWORD PTR [rbp-56]
  mov rdi, rax
  call ftell
  mov QWORD PTR [rbp-16], rax # long fsize

  lea rdx, [rbp-48] # fpos_t &out
  mov rax, QWORD PTR [rbp-56] # FILE* file
  mov rsi, rdx
  mov rdi, rax
  call fsetpos
  mov DWORD PTR [rbp-20], eax # int res2
  
  # res2 != 0 ?
  cmp DWORD PTR [rbp-20], 0
  je .file_size1
    mov edi, OFFSET FLAT:.fsetpos_error
    call fmw

    mov eax, DWORD PTR [rbp-20] # res2
    mov edi, eax
    call exit
.file_size1:
  mov rax, QWORD PTR [rbp-16]
  leave
  ret

file_contents: #(char* path) -> char* 
  push rbp
  mov rbp, rsp
  sub rsp, 48
  mov QWORD PTR [rbp-40], rdi # char* path

  mov rax, QWORD PTR [rbp-40]
  mov esi, OFFSET FLAT:FM_READ
  mov rdi, rax
  call fopen
  mov QWORD PTR [rbp-8], rax # FILE* f

  # f == NULL ?
  mov QWORD PTR [rbp-8], rax
  cmp QWORD PTR [rbp-8], 0
  jne .file_contents0
    mov rax, QWORD PTR [rbp-40]
    mov esi, OFFSET FLAT:.fo_error
    mov rdi, rax
    call fmw
  
    mov edi, 1
    call exit
.file_contents0:
  mov rax, QWORD PTR [rbp-8] # FILE* file
  mov rdi, rax
  call file_size
  mov QWORD PTR [rbp-16], rax # long fsize

  mov rax, QWORD PTR [rbp-16] # long fsize
  add rax, 1
  mov rdi, rax
  call malloc
  mov QWORD PTR [rbp-24], rax # char* buf

  mov rdx, QWORD PTR [rbp-16]
  mov rcx, QWORD PTR [rbp-8]
  mov rax, QWORD PTR [rbp-24]
  mov esi, 1
  mov rdi, rax
  call fread

  mov rdx, QWORD PTR [rbp-16]
  mov rax, QWORD PTR [rbp-24]
  add rax, rdx
  mov BYTE PTR [rax], 0
  mov rax, QWORD PTR [rbp-24]
  leave
  ret

print_usage: #(char** argv) -> void
  push rbp
  mov rbp, rsp
  sub rsp, 16
  mov QWORD PTR [rbp-8], rdi # char** argv

  # prints usage
  mov rax, QWORD PTR [rbp-8]
  mov rax, QWORD PTR [rax] # argv[0]
  mov rsi, rax
  mov edi, OFFSET FLAT:.usage_str
  call fmw
  
  mov eax, 0
  leave
  ret

main: #(int argc, char** argv) -> int
  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov DWORD PTR [rbp-20], edi # int argc
  mov QWORD PTR [rbp-32], rsi # char** argv

  # argc < 2?
  cmp DWORD PTR [rbp-20], 1
  jg .main1
    mov rax, QWORD PTR [rbp-32]
    mov rdi, rax
    call print_usage
    
    mov edi, 0
    call exit
.main1:
  mov rax, QWORD PTR [rbp-32] # char** argv
  mov rax, QWORD PTR [rax+8] # argv[1]
  mov QWORD PTR [rbp-8], rax # char* path

  mov rax, QWORD PTR [rbp-8]
  mov rdi, rax
  call file_contents
  mov QWORD PTR [rbp-16], rax # char* contents

  mov edi, OFFSET FLAT:.success_msg
  call fmw
  
  mov rax, QWORD PTR [rbp-16] # char* contents
  mov rdi, rax
  call free
  
  mov eax, 0
  leave
  ret
  
.section .note.GNU-stack, ""
