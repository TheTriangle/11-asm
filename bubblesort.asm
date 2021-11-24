global BubbleSortContainer
BubbleSortContainer:
section .data
    numFmt  db  "%d: ",0
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
    mov [len],   esi     ; сохраняется число элементов
    mov [FILE],  rdx    ; сохраняется указатель на файл
	mov cl, [len]					;set cl with array length
	mov [cntr], cl					;set this variable with array length

    up1 :
	mov rdi, [pcont]						;Points to start
	mov al, [cntr]					;
	mov bl, [lptr]
	sub al, bl						; n-i (Rather to increase i, Decrements n)
	mov [cntr2], al					; j pointer in bubble sort
	up2:
		mov al, [rdi]				;Get [j] in al
		mov bl, [rdi+1]			;Get [j+1]in bl
		cmp al, bl
		jb skip						;Compares
		mov [rdi+1], al					;If larger swapped
		mov [rdi], bl
		skip:
		   add rdi, 1				;Else continues to next number
		   sub qword[cntr2], 1
		   jnz up2
			
	sub qword[cntr], 1						;Decrements n (Rather to increase i)
	jnz up1
	ret
leave
ret