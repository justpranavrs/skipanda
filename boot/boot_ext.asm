; -----------------------------------------------------------------------------
; @file     boot_ext.asm
; @title    Extended Bootloader (Stage 2 Bootloader)
; @desc     Enables A20 Line, Loads GDT, Stores the Memory Map and switches
;           to 32-bit Protected Mode.
; @author   Pranav R S
; -----------------------------------------------------------------------------
bits 16 ; 16-bit real mode

boot_ext_start:
    call enable_a20 ; enable a20 address line
    cmp ax, 0
    je halt_cpu

    call setup_gdt ; setup GDT

    call store_memory_map
    cmp ax, 0
    je halt_cpu ; memory map failed to load

    mov ah, 0x00 ; set video mode
    mov al, 0x03
    int 0x10 ; set vga color mode

    cli ; disable hardware interrupts
    mov eax, cr0
    or al, 1 ; set PE
    mov cr0, eax

    jmp CODE_SEG_32:protected_mode ; far jump to protected_mode

%include "boot/a20.asm"
%include "boot/gdt.asm"
%include "boot/mmap.asm"

global cursor_offset
extern boot_main
bits 32 ; 32 bit protected mode
protected_mode:
    mov eax, DATA_SEG_32
    mov ds, eax
    mov es, eax
    mov fs, eax
    mov gs, eax
    mov ss, eax
    mov esp, ESP_ADDR ; extended stack pointer for 32-bit

    cld ; clear direction flag

    push mmap_info ; memory map arguments
    call boot_main ; call the stage c bootloader

%include "boot/utils.asm"

mmap_info:
    dd MMAP_ADDR
    dd LIST_ENTRY_SIZE
