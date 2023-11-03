.include "./lib/token.s"


/*
STRUCTURE lexer {
  QWORD PTR src;
  BYTE c;
  DWORD src_size;
  DWORD i;
}

----------------------------|
Lexer Utils         
|----------------------------*/
is_alpha: # (int c) -> int
  push rbp
  mov rbp, rsp
  mov DWORD PTR [rbp-4], edi

  cmp DWORD PTR [rbp-4], 96
  jg .is_alpha0
  cmp DWORD PTR [rbp-4], 122
  jle .is_alpha0
  cmp DWORD PTR [rbp-4], 64
  jg .is_alpha0
  cmp DWORD PTR [rbp-4], 90
  jle .is_alpha0
  cmp DWORD PTR [rbp-4], 95
  jne .is_alpha1

.is_alpha0:
  mov eax, 1
  jmp .is_alpha2

.is_alpha1:
  mov eax, 0

.is_alpha2:
  pop rbp
  ret


is_alpha_numeric: # (char c) -> int
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov DWORD PTR [rbp-4], edi
  
  mov eax, DWORD PTR [rbp-4]
  mov edi, eax
  call is_alpha
  
  test eax, eax
  jne .is_alpha_numeric0
  cmp DWORD PTR [rbp-4], 47
  jg .is_alpha_numeric0
  cmp DWORD PTR [rbp-4], 57
  jg .is_alpha_numeric1

.is_alpha_numeric0:
  mov eax, 1
  jmp .is_alpha_numeric2

.is_alpha_numeric1:
  mov eax, 0

.is_alpha_numeric2:
  leave
  ret
/*---------------------------|
Lexer Implementation         
|----------------------------*/
init_lexer: # (char* src) -> lexer*
  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov QWORD PTR [rbp-24], rdi

  mov edi, 24
  call malloc
  mov QWORD PTR [rbp-8], rax

  mov rax, QWORD PTR [rbp-8]
  mov rdx, QWORD PTR [rbp-24]
  mov QWORD PTR [rax], rdx
  
  mov rax, QWORD PTR [rbp-24]
  mov rdi, rax
  call strlen
  mov edx, eax

  mov rax, QWORD PTR [rbp-8]
  mov DWORD PTR [rax+8], edx

  mov rax, QWORD PTR [rbp-8]
  mov DWORD PTR [rax+16], 0
  
  mov rax, QWORD PTR [rbp-8]
  mov rdx, QWORD PTR [rax]
  mov rax, QWORD PTR [rbp-8]
  mov eax, DWORD PTR [rax+16]
  cdqe
  add rax, rdx

  movzx edx, BYTE PTR [rax]
  mov rax, QWORD PTR [rbp-8]
  mov BYTE PTR [rax+12], dl

  mov rax, QWORD PTR [rbp-8]
  leave
  ret


lexer_advance: # (lexer* l) -> void
  push rbp
  mov rbp, rsp
  mov QWORD PTR [rbp-8], rdi

  mov rax, QWORD PTR [rbp-8]
  mov edx, DWORD PTR [rax+16]
  mov rax, QWORD PTR [rbp-8]
  mov eax, DWORD PTR [rax+8]
  cmp edx, eax
  jge .lexer_advance0
    mov rax, QWORD PTR [rbp-8]
    movzx eax, BYTE PTR [rax+12]
    test al, al
    je .lexer_advance0
    
      mov rax, QWORD PTR [rbp-8]
      mov eax, DWORD PTR [rax+16]
      lea edx, [rax+1]
      mov rax, QWORD PTR [rbp-8]
      mov DWORD PTR [rax+16], edx

      mov rax, QWORD PTR [rbp-8]
      mov rdx, QWORD PTR [rax]
      mov rax, QWORD PTR [rbp-8]
      mov eax, DWORD PTR [rax+16]
      cdqe

      add rax, rdx
      movzx edx, BYTE PTR [rax]
      mov rax, QWORD PTR [rbp-8]
      mov BYTE PTR [rax+12], dl
      
.lexer_advance0:
  nop 
  pop rbp
  ret


lexer_skip_whitespace: # (lexer* l) -> void*
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov QWORD PTR [rbp-8], rdi
  
  jmp .lexer_skip_whitespace1
  
.lexer_skip_whitespace0:
  mov rax, QWORD PTR [rbp-8]
  mov rdi, rax
  call lexer_advance
  
.lexer_skip_whitespace1:
  mov rax, QWORD PTR [rbp-8]
  movzx eax, BYTE PTR [rax+12]
  cmp al, 13
  je .lexer_skip_whitespace0

  mov rax, QWORD PTR [rbp-8]
  movzx eax, BYTE PTR [rax+12]
  cmp al, 10
  je .lexer_skip_whitespace0

  mov rax, QWORD PTR [rbp-8]
  movzx eax, BYTE PTR [rax+12]
  cmp al, 32
  je .lexer_skip_whitespace0

  mov rax, QWORD PTR [rbp-8]
  movzx eax, BYTE PTR [rax+12]
  cmp al, 9
  je .lexer_skip_whitespace0
  
  nop
  pop rbp
  ret


lexer_parse_id: # (lexer* l) -> token*
  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov QWORD PTR [rbp-24], rdi

  mov esi, 1
  mov edi, 1
  call calloc
  mov QWORD PTR [rbp-8], rax
  jmp .lexer_parse_id0
  
.lexer_parse_id0:
  mov rax, QWORD PTR [rbp-8]
  mov rdi, rax
  call strlen
  lea rdx, [rax+2]
  mov rax, QWORD PTR [rbp-8]
  mov rsi, rdx
  mov rdi, rax
  call realloc
  mov QWORD PTR [rbp-8], rax

  mov rax, QWORD PTR [rbp-24]
  movzx eax, BYTE PTR [rax+12]
  mov BYTE PTR [rbp-16], al
  mov BYTE PTR [rbp-15], 0
  lea rdx, [rbp-16]
  mov rax, QWORD PTR [rbp-8]
  mov rsi, rdx
  mov rdi, rax
  call strcat

  mov rax, QWORD PTR [rbp-24]
  mov rdi, rax
  call lexer_advance

.lexer_parse_id1:
  mov rax, QWORD PTR [rbp-24]
  movzx eax, BYTE PTR [rax+12]
  movsx eax, al
  mov edi, eax
  call is_alpha_numeric
  test eax, eax
  jne .lexer_parse_id0
    mov rax, QWORD PTR [rbp-8]
    mov esi, TOKEN_ID
    mov rdi, rax
    mov eax, 0
    call init_token
    cdqe

    leave
    ret


lexer_advance_with: # (lexer* l, token* t) -> token*
  push rbp
  mov rbp, rsp
  sub rsp, 16
  mov QWORD PTR [rbp-8], rdi
  mov QWORD PTR [rbp-16], rsi

  mov rax, QWORD PTR [rbp-8]
  mov rdi, rax
  call lexer_advance

  mov rax, QWORD PTR [rbp-16]
  leave
  ret

  
lexer_next_token: # (lexer* l) -> token*
  push rbp
  mov rbp, rsp
  sub rsp, 16
  mov QWORD PTR [rbp-8], rdi
  
  jmp .lexer_next_token0

.lexer_next_token0:
  mov rax, QWORD PTR [rbp-8]
  movzx eax, BYTE PTR [rax+12]
  movsx eax, al
  mov edi, eax
  call is_alpha
  test eax, eax
  je .lexer_next_token1

  mov rax, QWORD PTR [rbp-8]
  mov rdi, rax
  call lexer_parse_id

  mov rdx, rax
  mov rax, QWORD PTR[rbp-8]
  mov rsi, rdx
  mov rdi, rax
  call lexer_advance_with
  jmp .lexer_next_token2
  
.lexer_next_token1:
  mov rax, QWORD PTR [rbp-8]
  movzx eax, BYTE PTR [rax+12]
  test al, al
  jne .lexer_next_token0

  mov esi, TOKEN_EOF
  mov edi, 0
  mov eax, 0
  call init_token
  cdqe
  
.lexer_next_token2:
  leave
  ret

  