; -----------------------------------------------------------------------------
; @file     edd.asm
; @requires utils.asm
; @title    Read Sectors
; @desc     Loads the Extended and the Stage C Bootloader.
; @author   Pranav R S
; -----------------------------------------------------------------------------
extern boot_drive
read_sectors:
    mov ah, 0x41 ; check extended support for lba
    mov bx, 0x55aa
    mov dl, [boot_drive]

    int 0x13
    jc no_edd

    cmp bx, 0xaa55 ; verify swap of bx register
    jne no_edd

    test cx, 1 ; check support for fixed disk access support
    jz no_edd

edd: ; enhanced disk drive with lba
    mov cx, 3
.lba_read:
    mov si, .dap ; load the disk address packet
    mov ah, 0x42 ; extended read sectors
    mov dl, [boot_drive]
    int 0x13
    jnc read_success

    xor ax, ax ; reset disk drives
    int 0x13

    loop .lba_read
.error:
    jmp no_edd
.dap: ; disk address packet
    db 0x10
    db 0

    dw READ_SECTOR_COUNT ; number of sectors to transfer
    dw READ_ORIGIN ; transfer destination buffer
    dw 0

    dd READ_LBA ; logical block address
    dd 0

no_edd: ; use chs
    mov di, 3
.drive_parameters: ; get drive parameters
    mov ah, 0x08
    mov dl, [boot_drive]
    int 0x13
    jnc lba_to_chs

    xor ax, ax ; reset disk drives
    int 0x13

    dec di
    jnz .drive_parameters
.error:
    mov si, geometry_err_msg
    call display_16
    jmp read_fail

lba_to_chs: ; convert lba to chs
    mov ax, READ_LBA

    inc dh ; number of heads
    mov bh, dh
    mov bl, cl
    and bl, 0x3f ; sectors per track

    xor dx, dx
    xor cx, cx
    mov cl, bl
    div cx

    inc dx ; sector = (lba % (sectors per track)) + 1
    push dx

    xor dx, dx
    mov cl, bh
    div cx

    pop cx ; sector from stack
    ; ax (cylinder)
    ; dx (head)
    ; cx (sector)
chs_read: ; read sectors from chs
    mov ch, al ; move cylinder to ch (low 8 bits)

    shl ah, 6
    or cl, ah ; sector | ((cylinder >> 2) & 0xc0)

    mov dh, dl ; head
    mov dl, [boot_drive]
    mov bx, READ_ORIGIN

    mov di, 3
.retry:
    mov ah, 0x02 ; read sectors
    mov al, READ_SECTOR_COUNT
    int 0x13
    jnc read_success

    xor ax, ax
    int 0x13

    dec di
    jnz .retry
.error:
    mov si, chs_read_err_msg
    call display_16
    jmp read_fail

read_success:
    mov si, read_success_msg
    call display_16

    mov ax, 1
    ret
read_fail:
    mov ax, 0
    ret

chs_read_err_msg db "BOOT_EXT ERR: READ", 0x0d, 0x0a, 0
geometry_err_msg db "BOOT_EXT ERR: GEOM", 0x0d, 0x0a, 0
read_success_msg db "BOOT_EXT LOADED", 0x0d, 0x0a, 0
