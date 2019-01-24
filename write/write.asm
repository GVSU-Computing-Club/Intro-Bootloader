[bits 16]
[org 0x7c00]

start:
    mov ah, 0x03
    mov [variable], dword 0xefbe
    mov al, 1
    mov cl, 1
    mov ch, 0
    mov dh, 0
    xor bx, bx
    mov es, bx
    mov bx, writefrom
    int 0x13

cli
hlt

times 200-($-$$) db 0

variable: dw 0xffff

times 510-($-$$) db 0
dw 0xaa55
