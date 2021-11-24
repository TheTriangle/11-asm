extern ToRealNumber
extern stdout
extern OutNumber
extern OutComplexNumber
extern ToRealComplexNumber
%include "printmacros.mac"

global BubbleSortContainer2
BubbleSortContainer2:
section .data
    numFmt  db  "%d: ",0
    real dq 0.0
    outfmt db "Complex number (%d, %d) - %g",10,0
section .bss
    pcont  resq    1   ; адрес контейнера
    len    resd    1   ; адрес для сохранения числа введенных элементов
    FILE   resq    1   ; указатель на файл
    cntr   resd    1   ; вспомогательный счетчик
    cntr2   resd    1   ; вспомогательный счетчик
    lptr    resd    1   ; вспомогательный счетчик
    firstad resq 1
    first resq 1
    second resq 1
    .p      resq  1       ; вычисленный периметр прямоугольника

section .text
push rbp
mov rbp, rsp

    mov [pcont], rdi   ; сохраняется указатель на контейнер
    mov [len],   esi     ; сохраняется число элементов
    mov [FILE],  rdx    ; сохраняется указатель на файл
	mov cl, [len]					;set cl with array length
	mov [cntr], cl					;set this variable with array length

    PrintStr2 "real0:", [FILE]
    
    mov     rdi, [pcont]
    add rdi, 4
    mov     rsi, [FILE]
    mov [firstad], rdi
    call    OutComplexNumber

    up1 :
	mov rdi, [pcont]						;Points to start
	mov al, [cntr]					;
	mov bl, [lptr]
	sub al, bl						; n-i (Rather to increase i, Decrements n)
	mov [cntr2], al					; j pointer in bubble sort

    PrintStr2 "entered 2", [FILE]
    PrintContainer2 [pcont], [len], [FILE]

	up2:
        ; PrintStr2 "entered 3", [FILE]
        ; PrintContainer2 [pcont], [len], [FILE]
        ; PrintInt2 [pcont], [FILE]
        ; PrintInt2 [pcont+1], [FILE]

        add rdi, 4
        mov [first], rdi
		mov r8, [rdi]				;Get [j] in r8
		add rdi, 16
        mov r9, [rdi]			;Get [j+1]in bl
		cmp r8, r9
		jb skip		 				;Compares
        PrintStr2 "didnt enter skip", [FILE]

        sub rdi, 20
        mov r8, [rdi + 16]					;If larger swapped
		mov [rdi + 16], rdi
        mov [rdi], r8
        add rdi, 4
        mov r8, [rdi + 16]					;If larger swapped
		mov [rdi + 16], rdi
        mov [rdi], r8
        add rdi, 4
        mov r8, [rdi + 16]					;If larger swapped
		mov [rdi + 16], rdi
        mov [rdi], r8
        add rdi, 4

        skip:
            PrintStr2 "entered skip", [FILE]
            ; sub rdi, 4
		    add rdi, 16			;Else continues to next number
		    sub byte[cntr2], 1
		    jnz up2
			
	sub byte[cntr], 1						;Decrements n (Rather to increase i)
	jnz up1
	ret