;------------------------------------------------------------------------------
; perimeter.asm - единица компиляции, вбирающая функции вычисления периметра
;------------------------------------------------------------------------------
%include "printmacros.mac"
extern COMPLEXNUMBER
extern FRACTION
extern COORDINATES
extern stdout 


global sqrti
sqrti:
    mov rbx, r9
    xor rax, rax

    .while:
    cmp rax, rbx
    jnb .endwhile

    add rbx, rax
    shr rbx, 1

    mov rax, r9
    xor rdx, rdx
    div rbx

    jmp .while

    .endwhile:
    mov rax, rbx
    ret


global ToRealComplexNumber
ToRealComplexNumber:
section .data
X dd 25
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес 
    xor rax, rax
    mov eax, [rdi]
    mov ebx, [rdi+4]
    imul eax, eax
    imul ebx, ebx
    add eax, ebx 
    mov ebx, 2 ; TODO take square root
    div ebx
breakpoint:
    xor r9, r9
    mov r9d, eax
    call sqrti
    mov rax, rbx
    
    ;call sqrti
    cvtsi2sd    xmm0, eax
    
    add rdi, 8
    mov dword[rdi], eax
    sub rdi, 8

leave
ret


global ToRealFraction
ToRealFraction:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес 
    mov eax, [rdi]
    mov ebx, [rdi+4]
    
    cmp ebx, 0
    je zerodenom
    div ebx

    zerodenom:

    ; mov eax, [rdi+4]
    cvtsi2sd    xmm0, eax
    add rdi, 8
    mov dword[rdi], eax
    sub rdi, 8
    
leave
ret

global ToRealCoordinates
ToRealCoordinates:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес 
    mov eax, [rdi+4]
    cvtsi2sd    xmm0, eax
    add rdi, 8
    mov dword[rdi], eax
    sub rdi, 8

leave
ret


global ToRealNumber
ToRealNumber:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес 
    ; PrintStr2 "toreall:", [stdout]
    mov eax, [rdi]
    cmp eax, [COMPLEXNUMBER]
    je compToReal
    cmp eax, [FRACTION]
    je fracToReal
    cmp eax, [COORDINATES]
    je cordToReal
    xor eax, eax
    cvtsi2sd    xmm0, eax
    jmp     return
compToReal:
    ;  PrintStr2 "complex:", stdout
    add     rdi, 4
    call    ToRealComplexNumber
    jmp     return
fracToReal:
    ; PrintStr2 "fraction:", stdout
    add     rdi, 4
    call    ToRealFraction
    jmp     return
cordToReal:
    ; PrintStr2 "coordinates:", stdout
    add     rdi, 4
    call    ToRealCoordinates
    jmp     return

return:
leave
ret
