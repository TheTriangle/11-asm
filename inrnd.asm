; file.asm - использование файлов в NASM
extern printf
extern rand

extern COMPLEXNUMBER
extern FRACTION
extern COORDINATES


;----------------------------------------------
; // rnd.c - содержит генератор случайных чисел в диапазоне от 1 до 20
; int Random() {
;     return rand() % 20 + 1;
; }
global Random
Random:
section .data
    .i20     dq      20
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     rdx, rdx    ; обнуление перед делением
    idiv    qword[.i20]       ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf
leave
ret

;----------------------------------------------
;// Случайный ввод параметров прямоугольника
;void InRndComplexNumber(void *r) {
    ;int x = Random();
    ;*((int*)r) = x;
    ;int y = Random();
    ;*((int*)(r+intSize)) = y;
;//     printf("    Rectangle %d %d\n", *((int*)r), *((int*)r+1));
;}
global InRndComplexNumber
InRndComplexNumber:
section .bss
    .pcomp  resq 1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес прямоугольника
    mov     [.pcomp], rdi
    ; Генерация сторон прямоугольника
    call    Random
    mov     rbx, [.pcomp]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.pcomp]
    mov     [rbx+4], eax

leave
ret

;----------------------------------------------
;// Случайный ввод параметров треугольника
;void InRndTriangle(void *t) {
    ;int a, b, c;
    ;a = *((int*)t) = Random();
    ;b = *((int*)(t+intSize)) = Random();
    ;do {
        ;c = *((int*)(t+2*intSize)) = Random();
    ;} while((c >= a + b) || (a >= c + b) || (b >= c + a));
;//     printf("    Triangle %d %d %d\n", *((int*)t), *((int*)t+1), *((int*)t+2));
;}
global InRndFraction
InRndFraction:
section .bss
    .pfrac  resq 1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov     [.pfrac], rdi
    ; Генерация сторон треугольника
    call    Random
    mov     rbx, [.pfrac]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.pfrac]
    mov     [rbx+4], eax

leave
ret

global InRndCoordinates
InRndCoordinates:
section .bss
    .pcord  resq 1   ; адрес треугольника
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес треугольника
    mov     [.pcord], rdi
    ; Генерация сторон треугольника
    call    Random
    mov     rbx, [.pcord]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.pcord]
    mov     [rbx+4], eax

leave
ret
;----------------------------------------------
;// Случайный ввод обобщенной фигуры
;int InRndShape(void *s) {
    ;int k = rand() % 2 + 1;
    ;switch(k) {
        ;case 1:
            ;*((int*)s) = RECTANGLE;
            ;InRndRectangle(s+intSize);
            ;return 1;
        ;case 2:
            ;*((int*)s) = TRIANGLE;
            ;InRndTriangle(s+intSize);
            ;return 1;
        ;default:
            ;return 0;
    ;}
;}
global InRndNumber
InRndNumber:
section .data
    .i3     dq      3
    .rndNumFmt       db "Random number = %d",10,0
section .bss
    .pnumber     resq    1   ; адрес фигуры
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov [.pnumber], rdi

    ; Формирование признака фигуры
    
    xor     eax, eax    ;
    call    rand        ; запуск генератора случайных чисел
    xor     edx, edx    ; обнуление перед делением
    idiv    qword[.i3]       ; (/%) -> остаток в rdx
    mov     eax, edx
    inc     eax         ; должно сформироваться случайное число

    ;mov     [.key], eax
    ;mov     rdi, .rndNumFmt
    ;mov     esi, [.key]
    ;xor     rax, rax
    ;call    printf
    ;mov     eax, [.key]

    mov     rdi, [.pnumber]
    mov     [rdi], eax      ; запись ключа в фигуру
    cmp eax, [COMPLEXNUMBER]
    je .compInRnd
    cmp eax, [FRACTION]
    je .fracInRnd
    cmp eax, [COORDINATES]
    je .coordInRnd
    xor eax, eax        ; код возврата = 0
    jmp     .return
.compInRnd:
    ; Генерация прямоугольника
    add     rdi, 4
    call    InRndComplexNumber
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.fracInRnd:
    ; Генерация треугольника
    add     rdi, 4
    call    InRndFraction
    mov     eax, 1      ;код возврата = 1
.coordInRnd:
    ; Генерация треугольника
    add     rdi, 4
    call    InRndCoordinates
    mov     eax, 1      ;код возврата = 1
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера
;void InRndContainer(void *c, int *len, int size) {
    ;void *tmp = c;
    ;while(*len < size) {
        ;if(InRndShape(tmp)) {
            ;tmp = tmp + shapeSize;
            ;(*len)++;
        ;}
    ;}
;}
global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.psize], edx    ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx        ; число фигур = 0
.loop:
    cmp ebx, edx
    jge     .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx

    call    InRndNumber     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 16             ; адрес следующей фигуры

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
