; file.asm - использование файлов в NASM
extern printf
extern fprintf

extern ToRealComplexNumber
extern ToRealFraction
extern ToRealCoordinates
extern ToRealNumber

extern COMPLEXNUMBER
extern FRACTION
extern COORDINATES


global OutComplexNumber
OutComplexNumber:
section .data
    .outfmt db "Complex number (%d, %d) - %g",10,0
section .bss
    .pcomp  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.pcomp], rdi       
    mov     [.FILE], rsi          ; сохраняется указатель на файл


    sub rdi, 4
    call    ToRealNumber
    add rdi, 4
    movsd   [.p], xmm0         


    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.pcomp]       
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; y
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret



global OutFraction
OutFraction:
section .data
    .outfmt db "Fraction %d/%d - %g",10,0
section .bss
    .frac  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.frac], rdi          
    mov     [.FILE], rsi          ; сохраняется указатель на файл


    call    ToRealFraction
    movsd   [.p], xmm0         


    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.frac]        ; адрес 
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; y
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret


global OutCoordinates
OutCoordinates:
section .data
    .outfmt db "Coorinates (%d, %d) - %g",10,0
section .bss
    .pcoord  resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1       
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.pcoord], rdi          ; сохраняется адрес
    mov     [.FILE], rsi          ; сохраняется указатель на файл


    call    ToRealCoordinates
    movsd   [.p], xmm0          
    

    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.pcoord]        ; адрес 
    mov     edx, [rax]          ; x
    mov     ecx, [rax+4]        ; y
    movsd   xmm0, [.p]
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret


global OutNumber
OutNumber:
section .data
    .erShape db "Incorrect number!",10,0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [COMPLEXNUMBER]
    je compOut
    cmp eax, [FRACTION]
    je fracOut
    cmp eax, [COORDINATES]
    je cordOut
    mov rdi, .erShape
    mov rax, 0
    call fprintf
    jmp     return
compOut:
    add     rdi, 4
    call    OutComplexNumber
    jmp     return
fracOut:
    add     rdi, 4
    call    OutFraction
    jmp     return
cordOut:
    add     rdi, 4
    call    OutCoordinates
    jmp     return
return:
leave
ret


global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число чисел
    xor ecx, ecx            ; счетчик  = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все числа

    push rbx
    push rcx


    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода 
    mov     edx, ecx        ; индекс текущего числа
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf


    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutNumber     ; Получение соответствующего действительного числа

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующего числа

    mov     rax, [.pcont]
    add     rax, 16         ; адрес следующего числа
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret

