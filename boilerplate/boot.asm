[bits 16]
[org 0x7c00]


; this is a comment, it leads with a semi-colon

; put assembly code here

times 510-($-$$) db 0
dw 0xaa55
