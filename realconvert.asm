;------------------------------------------------------------------------------
; perimeter.asm - единица компиляции, вбирающая функции вычисления периметра
;------------------------------------------------------------------------------
%include "printmacros.mac"
extern COMPLEXNUMBER
extern FRACTION
extern COORDINATES
extern stdout 

;----------------------------------------------
; Вычисление периметра прямоугольника
;double PerimeterRectangle(void *r) {
;    return 2.0 * (*((int*)r)
;           + *((int*)(r+intSize)));
;}

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

    ; В rdi адрес прямоугольника
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

;----------------------------------------------
; double PerimeterTriangle(void *t) {
;    return (double)(*((int*)t)
;       + *((int*)(t+intSize))
;       + *((int*)(t+2*intSize)));
;}
global ToRealFraction
ToRealFraction:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov eax, [rdi]
    mov ebx, [rdi+4]
    div ebx
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

    ; В rdi адрес треугольника
    mov eax, [rdi+4]
    cvtsi2sd    xmm0, eax
    add rdi, 8
    mov dword[rdi], eax
    sub rdi, 8

leave
ret
;----------------------------------------------
; Вычисление периметра фигуры
;double PerimeterShape(void *s) {
;    int k = *((int*)s);
;    if(k == RECTANGLE) {
;        return PerimeterRectangle(s+intSize);
;    }
;    else if(k == TRIANGLE) {
;        return PerimeterTriangle(s+intSize);
;    }
;    else {
;        return 0.0;
;    }
;}
global ToRealNumber
ToRealNumber:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
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
    ; Вычисление периметра прямоугольника
    ;  PrintStr2 "complex:", stdout
    add     rdi, 4
    call    ToRealComplexNumber
    jmp     return
fracToReal:
    ; PrintStr2 "fraction:", stdout
    ; Вычисление периметра прямоугольника
    add     rdi, 4
    call    ToRealFraction
    jmp     return
cordToReal:
    ; PrintStr2 "coordinates:", stdout
    ; Вычисление периметра прямоугольника
    add     rdi, 4
    call    ToRealCoordinates
    jmp     return

return:
leave
ret

;----------------------------------------------
;// Вычисление суммы периметров всех фигур в контейнере
;double PerimeterSumContainer(void *c, int len) {
;    double sum = 0.0;
;    void *tmp = c;
;    for(int i = 0; i < len; i++) {
;        sum += PerimeterShape(tmp);
;        tmp = tmp + shapeSize;
;    }
;    return sum;
;}