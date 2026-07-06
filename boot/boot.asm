; -----------------------------------------------------------------------------
; @file     boot.asm
; @title    Master Boot Record (MBR)
; @desc    Initialises the CPU and loads the extended bootloader from disk.
; @author   Pranav R S
; -----------------------------------------------------------------------------
global _start
global boot_drive

bits 16 ; 16-bit real mode

_start:
    cli ; disable hardware interrupts
    xor ax, ax ; declare registers
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, BOOT_ORIGIN
    sti ; enable hardware interrupts

    mov [boot_drive], dl ; load the drive number

    mov si, boot_msg
    call display_16

    call read_sectors ; load boot_ext onto ram

    cmp ax, 0
    je halt_cpu ; check edd failed

    jmp READ_ORIGIN ; move to extended bootloader

%include "boot/edd.asm" ; load bootloaders onto ram
%include "boot/utils.asm"

boot_drive db 0
boot_msg db "SKIPANDA BOOTING...", 0x0d, 0x0a, 0
