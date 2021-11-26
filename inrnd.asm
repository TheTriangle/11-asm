; file.asm - использование файлов в NASM
extern printf
extern rand

extern COMPLEXNUMBER
extern FRACTION
extern COORDINATES


global Random
Random:
section .data
    .i20     dq      1000
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


global InRndComplexNumber
InRndComplexNumber:
section .bss
    .pcomp  resq 1   ; адрес 
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес 
    mov     [.pcomp], rdi

    call    Random
    mov     rbx, [.pcomp]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.pcomp]
    mov     [rbx+4], eax

leave
ret


global InRndFraction
InRndFraction:
section .bss
    .pfrac  resq 1   ; адрес 
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес 
    mov     [.pfrac], rdi
    
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
    .pcord  resq 1   ; адрес 
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес 
    mov     [.pcord], rdi
    
    call    Random
    mov     rbx, [.pcord]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.pcord]
    mov     [rbx+4], eax

leave
ret


global InRndNumber
InRndNumber:
section .data
    .i3     dq      2
    .rndNumFmt       db "Random number = %d",10,0
section .bss
    .pnumber     resq    1   ; адрес 
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес 
    mov [.pnumber], rdi
    
    xor     rdx, rdx    ;
    call    rand        ; запуск генератора случайных чисел
    xor     edx, edx    ; обнуление перед делением
    idiv    qword[.i3]       ; (/%) -> остаток в rdx
    mov     eax, edx
    inc     eax         ; должно сформироваться случайное число


    mov     rdi, [.pnumber]
    mov     [rdi], eax      ; запись ключа
    cmp eax, [COMPLEXNUMBER] ; 1
    je .compInRnd
    cmp eax, [FRACTION] ; 3
    je .fracInRnd
    cmp eax, [COORDINATES] ; 2
    je .coordInRnd
    xor eax, eax        ; код возврата = 0
    jmp     .return
.compInRnd:
    add     rdi, 4
    call    InRndComplexNumber
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.fracInRnd:
    add     rdi, 4
    call    InRndFraction
    mov     eax, 1      ;код возврата = 1
    jmp .return
.coordInRnd:
    add     rdi, 4
    call    InRndCoordinates
    mov     eax, 1      ;код возврата = 1
.return:
leave
ret


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

    call    InRndNumber     ; ввод
    cmp rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 16            

    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
