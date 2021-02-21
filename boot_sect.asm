;;;
;;; A simple boot sector program that loops forever.
;;; 

	[org 0x7c00]		; BIOS loads us at an offset of 0x7c00 bytes

	mov bx, boot_string
	call print_function

	mov dx, 0x1fb6
	call print_hex
	
loop:				; infinite loop
	jmp loop
	
	;; Functions
print_function:
	pusha			; Store all registers on the 
	mov ah, 0x0e		; prepare printing to tty

	.start:
	mov al, [bx]		; Move the current bx into al -> get ready for printing
	cmp al, 0		; check for null-terminator // end of string
	je .end			; if so, jump to the end of the function
	int 0x10		; PRINT
	add bx, 1		; increment bx by 1, so we get the next character in the next iteration
	jmp .start		; so it all over again
	
	.end:
	popa			; Restore all registers from the stack
	ret

	;; Arguments: dx - hex value we want to print
print_hex:
	;; TODO: manipulate chars at hex_out to reflect dx
	pusha
	mov cx, 0		; initialize the loop counter

	.start:
	cmp cx, 4		; we print 4 hex chars, because we ar in 16 bit
	je .end			; if we are at the end of the loop, jump to the end

	mov ax, dx		
	and ax, 0x000F		; Null everything, except the last Byte
	add al, 0x30		; add 0x30 to get in the relevant printabl ascii
	cmp al, 0x39		; are we in 0-9 or A-F?
	jle .move_into_bx	
	add al, 0x07		; Add 0x07 to get into A-F Range
	
	.move_into_bx:
	mov bx, hex_out + 5	; add length of string
	sub bx, cx		; subtract the loop counter
	mov [bx], al		
	ror dx, 4		; rotate right by 4 bits

	add cx, 4		; Increment the loop counter
	jmp .start		; do it all over again
	
	.end:			; In the end: 
	mov bx, hex_out		; print the
	call print_function	; resulted string
	
	popa
	ret


	
	;; Data
boot_string:	db 'Booting OS', 0xA, 0xD, 0
hex_out:	db '0x0000', 0

	;; End of Program
    times 510 - ($-$$) db 0	; fill the file up, up up 510 bytes with 0x00

    dw 0xaa55			; fill the BIOS-Magic number
