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
section .bss
    pcont  resq    1   ; адрес контейнера
    len    resd    1   ; адрес для сохранения числа введенных элементов
    FILE   resq    1   ; указатель на файл
    cntr   resd    1   ; вспомогательный счетчик
    cntr2   resd    1   ; вспомогательный счетчик
    lptr    resd    1   ; вспомогательный счетчик

section .text
push rbp
mov rbp, rsp

    mov [pcont], rdi   ; сохраняется указатель на контейнер
    ; PrintInt2 rdi, [stdout]
    
    mov [len],   esi     ; сохраняется число элементов
    mov [FILE],  rdx    ; сохраняется указатель на файл
	mov cl, [len]					;set cl with array length
	mov [cntr], cl					;set this variable with array length

    PrintStr2 "real0:", [FILE]
    mov rdi, [pcont]
    call ToRealNumber     ; Получение периметра первой фигуры
    
    PrintStr2 "real:", [FILE]
    movsd [real], xmm0
    PrintDouble2 xmm0, [FILE]
    PrintStr2 "rend:", [FILE]

    mov rax, [pcont + 1]
    PrintInt2 rax, [FILE]
    PrintStr2 "first:", [FILE]
    PrintInt2 [pcont + 1], [FILE]
    PrintStr2 "second:", [FILE]
    PrintInt2 [pcont + 2], [FILE]
    PrintStr2 "entered:", [FILE]
    
    up1 :
	mov rdi, [pcont + 1]						;Points to start
	mov al, [cntr]					;
	mov bl, [lptr]
	sub al, bl						; n-i (Rather to increase i, Decrements n)
	mov [cntr2], al					; j pointer in bubble sort

    PrintStr2 "entered 2", [FILE]
    PrintContainer2 [pcont], [len], [FILE]

	up2:
        PrintStr2 "entered 3", [FILE]
        PrintContainer2 [pcont], [len], [FILE]
        PrintInt2 [pcont], [FILE]
        ; PrintInt2 [pcont+1], [FILE]

		mov al, [rdi]				;Get [j] in al
		mov bl, [rdi+1]			;Get [j+1]in bl
		cmp al, bl
		jb skip						;Compares
		mov [rdi+1], al					;If larger swapped
		mov [rdi], bl
		skip:
            PrintStr2 "entered skip", [FILE]
		    add rdi, 1			;Else continues to next number
		    sub byte[cntr2], 1
		    jnz up2
			
	sub byte[cntr], 1						;Decrements n (Rather to increase i)
	jnz up1
	ret