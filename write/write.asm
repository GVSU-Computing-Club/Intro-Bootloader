; READ THIS BEFORE EXECUTING:

; After you use the command "make" to create the .bin file you will have a pre-written to "virtual" drive
; execute the command "make inspect" on the binary to see that floating in the middle of the 0's there is ffff
; that is our "variable" before we intend to change it
; now run "make qemu"
; nothing happens visually, however if you inspect the binary again you will notice it has changed the value
; if this were a real drive, the exact same thing would have happened to the real drive, thus it's important to be careful
; and use the correct drive (passed in from register dl) so you don't overwrite another drives information


[bits 16]                           ; real mode is only 16 bits
[org 0x7c00]                        ; We always start at memory location 0x7c00

write_from:                         ; a label which we will use as the address for our write, because it's before any instructions
                                    ; or data it's safe to assume this value will be 0x7c00
start:
    mov [drive_id], dl              ; This is very important. When the BIOS gives control to the bootloader it passes
                                    ; the drive id of the drive which it got the bootloader code from.
                                    ; It's good practice to save this value immediately so you don't have to worry about losing it.
                                    ; Also very important so that if you do test on a real machine you are using the correct drive to write to and from.

    mov ah, 0x03                    ; from the int 0x13 functions, use the function "write sectors to drive": 0x03
                                    ; https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=03h:_Write_Sectors_To_Drive

    mov [variable], dword 0xefbe    ; changing value in memory
                                    ; when this sector is wrote back to the drive it will be changed from 0xffff to 0xbeef

    mov al, 1                       ; write 1 sector (512 bytes)
    mov cl, 1                       ; which sector to write to on the drive, starts at 1 instead of 0
    mov ch, 0                       ; which track on disk to write to, starts at 0
    mov dh, 0                       ; which disk head to write to, starts at 0
    xor bx, bx                      ; set bx to 0. xor-ing by itself will always result in 0

    mov es, bx                      ; set segment register es to 0. This controls the offset, we don't need an offset
                                    ; es can only be changed by using another register, so we use bx

    mov bx, write_from               ; we use the label writefrom (which is a memory address at the top of our disk, we pressume 0x7c00)
                                    ; as the starting point for our write.
                                    ; So it will write from memory location 0x7c00 to 0x7c00+512 to head 0, track 0, sector 1 on the drive
                                    ; which mentioned earlier is the very start of the drive.

    int 0x13                        ; Execute the interrupt

    cli                             ; clear interrupts
    hlt                             ; halt the cpu

drive_id: db 0                      ; drive id we will save

times 200-($-$$) db 0               ; offset to the value we want to change
variable: dw 0xffff                 ; value we want to change

times 510-($-$$) db 0               ; offset to the boot signature
dw 0xaa55                           ; boot signature

