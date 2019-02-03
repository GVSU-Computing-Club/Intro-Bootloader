[bits 16]                       ; real mode is 16 bits
[org 0x7c00]                    ; we always start at address 0x7c00

start:
    mov ah, 0x0e                ; of the int 0x10 functions use "teletype output" / 0xe
                                ; https://en.wikipedia.org/wiki/INT_10H

    mov bh, 0                   ; use page 0
    mov bx, hello               ; address of characters we want to write
.loop:
    mov al, byte [bx]           ; get the a (byte) character from address in bx
    cmp al, 0                   ; see if that (byte) character is zero
    je .end                     ; if it's zero, we are done, otherwise continue
    int 0x10                    ; execute int 0x10, write the character to screen
    inc bx                      ; increment the address by 1 byte so we move to the next character
    jmp .loop                   ; do it all again
.end:
    cli                         ; clear interrupts
    hlt                         ; halt the cpu

hello: db "hello world",0       ; characters we want to write, null terminated

times 510-($-$$) db 0           ; offset to boot signature
dw 0xaa55                       ; boot signature
