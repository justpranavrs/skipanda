; -----------------------------------------------------------------------------
; @file     mmap.asm
; @requires utils.asm
; @title    System Memory Map
; @desc    Stores the Memory Map using BIOS 0x15.
; @author   Pranav R S
; -----------------------------------------------------------------------------
store_memory_map:
    mov di, MMAP_ADDR ; above BDA
    
    xor ebx, ebx ; clear ebx
    mov edx, SMAP_SIGNATURE ; SMAP

initial_e820:
    mov eax, 0xe820
    mov ecx, LIST_ENTRY_SIZE
    int 0x15 ; initial e820 call
    jc memory_map_fail

    cmp eax, SMAP_SIGNATURE ; check SMAP
    jne memory_map_fail
.e820:
    add di, LIST_ENTRY_SIZE
    
    test ebx, ebx ; check if ebx is 0
    jz memory_map_success ; end of list
    
    mov eax, 0xe820
    mov ecx, LIST_ENTRY_SIZE
    int 0x15
    jnc .e820

memory_map_success:
    mov si, memory_map_success_msg
    call display_16

    mov ax, 1
    ret
    
memory_map_fail:
    mov si, memory_map_err_msg
    call display_16

    mov ax, 0
    ret

memory_map_err_msg db "MEMORY MAP FAILED TO LOAD", 0x0d, 0x0a, 0
memory_map_success_msg db "MEMORY MAP LOADED", 0x0d, 0x0a, 0