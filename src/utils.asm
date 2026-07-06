; Common Utilities
display_16: ; display on the screen
    mov ah, 0x0e ; write character in tty mode
.print:
    lodsb
    or al, al
    jz .done
    int 0x10 ; invoke interrupt
    jmp .print
.done:
    ret

clear_display_32:
    mov edi, VIDEO_MEMORY
    mov ecx, 2000
    mov ax, 0x0720 ; space + attr
.loop:
    mov [edi], ax
    add edi, 2
    loop .loop
.done:
    ret
    
display_32:
    pusha ; push general purpose registers
    mov edx, VIDEO_MEMORY
    add edx, [cursor_offset] ; add cursor offset
.loop:
    mov al, [ebx] ; address of the character
    mov ah, DISPLAY_ATTR

    or al, al
    jz .set_cursor

    mov [edx], ax ; store character with attribute in video memory
    add ebx, 1
    add edx, 2
    jmp .loop
.set_cursor:
    sub edx, VIDEO_MEMORY ; obtain offset

    mov ebx, edx
    mov eax, edx
    xor edx, edx ; clear edx for unsigned division

    mov ecx, DISPLAY_ROW_SIZE
    div ecx ; edx contains remainder

    test edx, edx
    jz .done ; at start of row

    mov eax, DISPLAY_ROW_SIZE
    sub eax, edx
    add ebx, eax ; move to start of row
.done:
    mov [cursor_offset], ebx ; set new offset

    popa ; restore general purpose registers
    ret

cursor_offset dd 0

halt_cpu: ; halt the cpu
    cli
    hlt
    jmp $
