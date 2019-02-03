; Expected output is a random character or blank space followed by an X

[bits 16]                           ; real mode is only 16 bits
[org 0x7c00]                        ; We always start at memory location 0x7c00

start:
    mov [drive_id], dl              ; This is very important. When the BIOS gives control to the bootloader it passes
                                    ; the drive id of the drive which it got the bootloader code from.
                                    ; It's good practice to save this value immediately so you don't have to worry about losing it.

    mov ah, 0x02                    ; from the int 0x13 functions, use the function "read sectors to drive": 0x02
                                    ; https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=02h:_Read_Sectors_From_Drive


    ; Attempt to write character "X" which is beyond our 512 byte range
    ; it could be anything, in fact by low chances it could be an X but that would be merely coincidence and not reliable
    ; most likely will be something else or a blank non-printable character
    mov ah, 0xe                     ; using teletype output function
    mov bh, 0                       ; use page 0
    mov al, byte [variable]         ; get the character (byte) from address "variable"
    int 0x10                        ; print the character


    ; Now lets load more sectors into memory so we can find/access our X
    mov ah, 0x02                    ; Use read sectors from drive function
    mov al, 1                       ; read only one sector (512 bytes)
    mov dl, byte [drive_id]         ; read from the drive we saved
    mov dh, 0                       ; read from head 0, starts at 0
    mov ch, 0                       ; read from cylinder 0, starts at 0
    mov cl, 2                       ; read from sector 2, starts at 1 thus we want the next sector (2) which contains our "X"
    xor bx, bx                      ; set bx to 0
    mov es, bx                      ; set es (offset) to 0, we don't need to use it
    mov bx, read_to                 ; set the location we want to read our data to, which is after our first sector defined as "read_to"
    int 0x13                        ; Execute the interrupt

    ; Try to write again
    mov ah, 0xe                     ; using teletype output function
    mov bh, 0                       ; use page 0
    mov al, byte [variable]         ; get the character (byte) from address "variable"
    int 0x10                        ; print the character

    cli                             ; clear interrupts
    hlt                             ; halt the cpu

drive_id: db 0                      ; drive id we will save

times 510-($-$$) db 0               ; offset to the boot signature
dw 0xaa55                           ; boot signature

; Without using an interrupt to read more data into memory,
; this is not loaded into memory as it's beyond the first sector / 512 bytes
read_to:
variable: db "X"
