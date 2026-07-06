; Extended Bootloader (Stage 2 Bootloader)
%include "src/config.asm"

bits 16 ; 16-bit real mode

boot_ext_start:
    call enable_a20 ; enable a20 address line
    cmp ax, 0
    je halt_cpu

    call setup_gdt ; setup GDT

    call store_memory_map
    cmp ax, 0
    je halt_cpu ; memory map failed to load

    cli ; disable hardware interrupts
    mov eax, cr0
    or al, 1 ; set PE
    mov cr0, eax

    jmp CODE_SEG_32:protected_mode ; far jump to protected_mode

%include ASM_A20
%include ASM_GDT
%include ASM_MMAP

global cursor_offset
bits 32 ; 32 bit protected mode
protected_mode:
    mov eax, DATA_SEG_32
    mov ds, eax
    mov es, eax
    mov fs, eax
    mov gs, eax
    mov ss, eax
    mov esp, ESP_ADDR ; extended stack pointer for 32-bit

    call clear_display_32
    
    mov ebx, pm_msg
    call display_32

    cld ; clear direction flag
    
run:
    jmp $

%include ASM_UTILS

pm_msg db "SWITCHED TO 32-BIT PROTECTED MODE.. LOADING STAGE_C BOOTLOADER", 0

times 1024-($-$$) db 0
