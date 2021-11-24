; file.asm - использование файлов в NASM
extern printf
extern fscanf

extern COMPLEXNUMBER
extern FRACTION
extern COORDINATES

;----------------------------------------------
; // Ввод параметров комплексного числа из файла
; void InCompexNumber(void *r, FILE *ifst) {
;     fscanf(ifst, "%d%d", (int*)r, (int*)(r+intSize));
; }
global InComplexNumber
InComplexNumber:
section .data
    .infmt db "%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .pcomp  resq    1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pcomp], rdi          ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.pcomp]       ; &x
    mov     rcx, [.pcomp]
    add     rcx, 4              ; &y = &x + 4
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

; // Ввод параметров треугольника из файла
; void InTriangle(void *t, FILE *ifst) {
;     fscanf(ifst, "%d%d%d", (int*)t,
;            (int*)(t+intSize), (int*)(t+2*intSize));
; }
global InFraction
InFraction:
section .data
    .infmt db "%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .pfrac  resq    1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pfrac], rdi          ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.pfrac]       ; &x
    mov     rcx, [.pfrac]
    add     rcx, 4              ; &y = &x + 4
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf
leave
ret


global InCoordinates
InCoordinates:
section .data
    .infmt db "%d%d",0
section .bss
    .FILE   resq    1   ; временное хранение указателя на файл
    .pcoord  resq    1   ; адрес прямоугольника
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pcoord], rdi          ; сохраняется адрес прямоугольника
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Ввод прямоугольника из файла
    mov     rdi, [.FILE]
    mov     rsi, .infmt         ; Формат - 1-й аргумент
    mov     rdx, [.pcoord]       ; &x
    mov     rcx, [.pcoord]
    add     rcx, 4              ; &y = &x + 4
    mov     rax, 0              ; нет чисел с плавающей точкой
    call    fscanf
leave
ret

; // Ввод параметров обобщенной фигуры из файла
; int InShape(void *s, FILE *ifst) {
;     int k;
;     fscanf(ifst, "%d", &k);
;     switch(k) {
;         case 1:
;             *((int*)s) = RECTANGLE;
;             InRectangle(s+intSize, ifst);
;             return 1;
;         case 2:
;             *((int*)s) = TRIANGLE;
;             InTriangle(s+intSize, ifst);
;             return 1;
;         default:
;             return 0;
;     }
; }
global InNumber
InNumber:
section .data
    .tagFormat   db      "%d",0
    .tagOutFmt   db     "Tag is: %d",10,0
section .bss
    .FILE       resq    1   ; временное хранение указателя на файл
    .pnum     resq    1   ; адрес фигуры
    .shapeTag   resd    1   ; признак фигуры
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pnum], rdi          ; сохраняется адрес фигуры
    mov     [.FILE], rsi            ; сохраняется указатель на файл

    ; чтение признака фигуры и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pnum]      ; адрес начала фигуры (ее признак)
    xor     rax, rax            ; нет чисел с плавающей точкой
    call    fscanf

    ; Тестовый вывод признака фигуры
;     mov     rdi, .tagOutFmt
;     mov     rax, [.pshape]
;     mov     esi, [rax]
;     call    printf

    mov rcx, [.pnum]          ; загрузка адреса начала фигуры
    mov eax, [rcx]              ; и получение прочитанного признака
    cmp eax, [COMPLEXNUMBER]
    je .compIn
    cmp eax, [FRACTION]
    je .fracIn
    cmp eax, [COORDINATES]
    je .coordIn
    xor eax, eax    ; Некорректный признак - обнуление кода возврата
    jmp     .return
.compIn:
    ; Ввод прямоугольника
    mov     rdi, [.pnum]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InComplexNumber
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.fracIn:
    ; Ввод треугольника
    mov     rdi, [.pnum]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InFraction
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.coordIn:
    ; Ввод треугольника
    mov     rdi, [.pnum]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InCoordinates
    mov     rax, 1  ; Код возврата - true
    jmp     .return
.return:

leave
ret

; // Ввод содержимого контейнера из указанного файла
; void InContainer(void *c, int *len, FILE *ifst) {
;     void *tmp = c;
;     while(!feof(ifst)) {
;         if(InShape(tmp, ifst)) {
;             tmp = tmp + shapeSize;
;             (*len)++;
;         }
;     }
; }
global InContainer
InContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.plen], rsi    ; сохраняется указатель на длину
    mov [.FILE], rdx    ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx        ; число фигур = 0
    mov rsi, rdx        ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0      ; нет чисел с плавающей точкой
    call    InNumber     ; ввод фигуры
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

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

