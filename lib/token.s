.include "./lib/fmt.s"

/*

Token Types:  */
.equ TOKEN_ID,                0
.equ TOKEN_EQUALS,            1
.equ TOKEN_LPAREN,            2
.equ TOKEN_RPAREN,            3
.equ TOKEN_LBRAC,             4
.equ TOKEN_RBRAC,             5
.equ TOKEN_COLON,             6 
.equ TOKEN_COMMA,             7
.equ TOKEN_INT,               8
.equ TOKEN_LT,                9
.equ TOKEN_GT,               10
.equ TOKEN_BIG_RIGHT_ARROW,  11
.equ TOKEN_LOW_RIGHT_ARROW,  12
.equ TOKEN_SEMICOLON,        13

/*
STRUCTURE token {
  QWORD PTR lexeme;
  DWORD type
}

----------------------------|
Token Implementation         
|----------------------------*/

init_token: # (char* lexeme, int type) -> token*
  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov QWORD PTR [rbp-24], rdi
  mov DWORD PTR [rbp-28], esi

  mov edi, 16
  call malloc
  mov QWORD PTR [rbp-8], rax

  mov rax, QWORD PTR [rbp-8]
  mov rdx, QWORD PTR [rbp-24]
  mov QWORD PTR [rax], rdx

  mov rax, QWORD PTR [rbp-8]
  mov edx, DWORD PTR [rbp-28]
  mov DWORD PTR [rax+8], eax
  
  mov rax, QWORD PTR [rbp-8]
  leave
  ret
