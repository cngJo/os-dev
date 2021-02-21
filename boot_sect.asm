;;;
;;; A simple boot sector program that loops forever.
;;; 

	[org 0x7c00]		; BIOS loads us at an offset of 0x7c00 bytes

	mov bx, boot_string
	call print_function

	
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
	
	;; Data
boot_string:	db 'Booting OS', 0

	;; End of Program
    times 510 - ($-$$) db 0	; fill the file up, up up 510 bytes with 0x00

    dw 0xaa55			; fill the BIOS-Magic number
