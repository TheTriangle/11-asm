global BubbleSort
BubbleSort:
	mov rdi,array						;pointer to starting of array
	mov byte[ptr],00h					; set this variable to 00
	mov cl,byte[lenn]					;set cl with array length
	mov byte[cntr],cl					;set this variable with array length
	
	up1 :
	mov rdi,array						;Points to start
	mov al,byte[cntr]					;
	mov bl,byte[ptr]
	sub al,bl						; n-i (Rather to increase i, Decrements n)
	mov byte[cntr2],al					; j pointer in bubble sort
	up2:
		mov al,byte[rdi]				;Get [j] in al
		mov bl,byte[rdi+1]				;Get [j+1]in bl
		cmp al,bl
		jb skip						;Compares
		mov [rdi+1],al					;If larger swapped
		mov [rdi],bl
		skip:
		   inc rdi					;Else continues to next number
		   dec byte[cntr2]
		   jnz up2
			
	dec byte[cntr]						;Decrements n (Rather to increase i)
	jnz up1
	ret