extern ToRealNumber
extern stdout
extern OutNumber
extern OutComplexNumber
extern ToRealComplexNumber
%include "printmacros.mac" 
; макросы для отладки

; вызывается макросом SortContainer2 (macros.mac) из main.asm
global BubbleSortContainer2
BubbleSortContainer2:
section .data
    numFmt  db  "%d: ",0
    real1 dq 0.0
    outfmt db "Coorinates (%d, %d) - %g",10,0
section .bss
    pcont  resq    1   ; адрес контейнера
    len    resd    1   ; адрес для сохранения числа введенных элементов
    FILE   resq    1   ; указатель на файл (поток)
    cntr   resd    1   ; вспомогательный счетчик
    cntr2   resd    1   ; вспомогательный счетчик
    lptr    resd    1   ; вспомогательный счетчик
    i: resd 1
    j: resd 1

section .text
push rbp
mov rbp, rsp

    mov [pcont], rdi   ; сохраняется указатель на контейнер
    ; PrintInt2 rdi, [stdout]
    
    mov [len],   esi     ; сохраняется число элементов
    mov [FILE],  rdx    ; сохраняется указатель на файл (поток)
	;mov cl, [len]					;set cl with array length
	;mov [cntr], cl					;set this variable with array length
    ;mov rbx, rsi            ; число фигур
    ;xor ecx, ecx            ; счетчик фигур = 0
    ;mov rsi, rdx            ; перенос указателя на файл

    ;mov dword[rdi], 2
    ;sub rdi, 16
    ;PrintStr2 "hey, Jude", [FILE]

    ;xor     edx, edx    
    ; mov [pcont], [rdi + 16]     
    ;mov     rdi, [pcont]
    ;mov     rsi, [FILE]
    ;call OutNumber     ; Получение периметра первой фигуры

    ;mov rdi, [pcont]
    ;call ToRealNumber     ; Получение периметра первой фигуры
    ;movsd [real], xmm0

    ;mov rdi, [pcont]
    ;mov [pcont], rdi
    ;PrintStr2 "don't make it bad", [FILE]

    ;mov     rdi, [FILE]
    ;mov     rsi, outfmt        ; Формат - 2-й аргумент
    ;mov     rax, [pcont]        ; адрес прямоугольника
    ;mov     edx, [rax+4]          ; x
    ;mov     ecx, [rax+8]        ; y
    ;movsd   xmm0, [real]
    ;mov     rax, 1              ; есть числа с плавающей точкой
    ;call    fprintf
    ;PrintStr2 "take a sad song", [FILE]

    ; здесь начинается скопипащенный алгоритм сортировки, который я так и не проверил
    
    ; PrintStr2 "and make it better", [FILE]  
   
    ; movzx ecx, byte[len]
    mov ebx, pcont

    mov dword[i], 0
    i_loop:
    ; PrintStr2 "remember", [FILE]
    mov dword[j], 0
    j_loop:
        mov ebx, [pcont] ; ebx - указатель на начало контейнера
        mov eax, dword[j] ; eax - j
        mov r11d, 16 ; r11d - 16
        mul r11d ; eax - 16j
        add ebx, eax ; ebx - указатель на j-тый элемент контейнера 
        mov eax, ebx ; eax - указатель на j-тый элемент контейнера
        add eax, 16 ; eax - указатель на j+1-ый элемент контейнера
        mov edx, dword[ebx] ; edx - j-тый элемент контейнера (тип числа)
        mov r9d, dword[eax] ; r9d - j+1-ый элемент контейнера (тип числа)
        cmp r9d, edx ; сравниваем j и j+1 типы
        jl swap ; свопаем
        jmp no_swap ; не свопаем
    
        swap:
        mov dword[ebx], r9d ; помещаем j+1-ый элемент по указателю на j
        mov dword[eax], edx ; помещаем j-ый элемент по указателю на j+1-ый
        add ebx, 4
        add eax, 4
        mov r9d, dword[eax]
        mov edx, dword[ebx]
        mov dword[ebx], r9d ; помещаем j+1-ый элемент по указателю на j
        mov dword[eax], edx ; помещаем j-ый элемент по указателю на j+1-ый
        add ebx, 4
        add eax, 4
        mov r9d, dword[eax]
        mov edx, dword[ebx]
        mov dword[ebx], r9d ; помещаем j+1-ый элемент по указателю на j
        mov dword[eax], edx ; помещаем j-ый элемент по указателю на j+1-ый


    no_swap:
        inc dword[j] ; увеличиваем j
        mov r10d, dword[len] ; r10d - длина массива
        sub r10d, dword[i] ; r10d - длина массива - i
        sub r10d, 1 ; r10d - длина массива - i - 1
        cmp dword[j], r10d ; если j < длины - i - 1, продолжаем
        jl j_loop

    inc dword[i] ; увеличиваем i
    mov r10d, dword[len] ; r10d - длина массива
    cmp dword[i], r10d
    jl i_loop

    leave
	ret