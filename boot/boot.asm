; -----------------------------------------------------------------------------
; @file     boot.asm
; @title    Master Boot Record (MBR)
; @desc     Initialises the CPU and loads the extended bootloader from disk.
; @author   Pranav R S
; -----------------------------------------------------------------------------
global start
global boot_drive

bits 16 ; 16-bit real mode

start:
    jmp 0x0000:.boot ; set cs to 0x0000
.boot:
    cli ; disable hardware interrupts
    xor ax, ax ; declare registers
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, BOOT_ORIGIN
    sti ; enable hardware interrupts

    mov [boot_drive], dl ; load the drive number

    mov si, boot_msg
    call display_16 ; display the boot message

    call read_sectors ; load sectors onto ram

    cmp ax, 0
    je halt_cpu ; check edd failed

    jmp READ_ORIGIN ; move to extended bootloader

%include "boot/edd.asm" ; load bootloaders onto ram
%include "boot/utils.asm"

boot_drive db 0
boot_msg db "MBR LOADED", 0x0d, 0x0a, 0

times (0x1B8-($-$$)) db 0 ; fill 0 upto 440 bytes

UID dw "P-RS" ; unique signature
dw 0x0000 ; (optional) reserved 0x0000

times (16*4) db 0 ; partition table entries

dw 0xAA55