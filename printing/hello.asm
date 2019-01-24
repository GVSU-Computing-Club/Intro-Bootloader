[bits 16]
[org 0x7c00]

start:
    mov ah, 0x0e
    mov cx, 0
.loop:
    mov bx, hello
    add bx, cx
    mov al, byte [bx]
    int 0x10
    add cx, 1
    cmp cx, 11
    jl .loop
    cli
    hlt

hello: db "hello world",0

times 510-($-$$) db 0
dw 0xaa55
