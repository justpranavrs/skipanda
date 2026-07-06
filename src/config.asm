; Master Boot Record (MBR)
BOOT_ORIGIN equ 0x7c00

; Bridge (Stage 2 Bootloader)
BRIDGE_ORIGIN equ 0x7e00
BRIDGE_SECTOR_COUNT equ 4
BRIDGE_LBA equ 1

; Files
%define ASM_UTILS "src/utils.asm"
%define ASM_EDD "src/edd.asm"
%define ASM_A20 "src/a20.asm"
