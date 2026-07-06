; Master Boot Record (MBR)
BOOT_ORIGIN equ 0x7c00

; Bridge (Stage 2 Bootloader)
BRIDGE_ORIGIN equ 0x7e00
BRIDGE_SECTOR_COUNT equ 4
BRIDGE_LBA equ 1

; Files
%define ASM_SRC "src/"
%strcat ASM_A20    ASM_SRC, "a20.asm"
%strcat ASM_EDD    ASM_SRC, "edd.asm"
%strcat ASM_GDT    ASM_SRC, "gdt.asm"
%strcat ASM_UTILS  ASM_SRC, "utils.asm"
