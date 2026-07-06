; Global Descriptor Table (GDT)
gdt:
    dq 0 ; null descriptor
code_segment_32:
    dw 0xffff ; limit (0-15)
    dw 0x0000 ; base (0-15)
    db 0x00 ; base (16-23)
    db 0x9A ; access (E = 1)
    db 0xCF ; flags, limit(16-19)
    db 0x00 ; base (24-31)
data_segment_32:
    dw 0xffff ; limit (0-15)
    dw 0x0000 ; base (0-15)
    db 0x00 ; base (16-23)
    db 0x92 ; access (E = 0)
    db 0xCF ; flags, limit(16-19)
    db 0x00 ; base (24-31)
code_segment_64:
    dw 0x0000 ; limit (0-15)
    dw 0x0000 ; base (0-15)
    db 0x00 ; base (16-23)
    db 0x9A ; access (E = 1)
    db 0x20 ; flags, limit(16-19)
    db 0x00 ; base (24-31)
data_segment_64:
    dw 0x0000 ; limit (0-15)
    dw 0x0000 ; base (0-15)
    db 0x00 ; base (16-23)
    db 0x92 ; access (E = 0)
    db 0x00 ; flags, limit(16-19)
    db 0x00 ; base (24-31)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt - 1
    dq gdt ; 64 bit gdt address

setup_gdt:
    lgdt [gdt_descriptor]

    mov si, gdt_success_msg
    call display

    ret

CODE_SEG_32 equ code_segment_32 - gdt
DATA_SEG_32 equ data_segment_32 - gdt
CODE_SEG_64 equ code_segment_64 - gdt
DATA_SEG_64 equ data_segment_64 - gdt

gdt_success_msg db "GDT LOADED", 0x0d, 0x0a, 0
