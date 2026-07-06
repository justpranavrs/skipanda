; -----------------------------------------------------------------------------
; @file     config.inc
; @title    Boot Configuration
; @author   Pranav R S
; -----------------------------------------------------------------------------

; Master Boot Record (MBR)
BOOT_ORIGIN equ 0x7c00
READ_ORIGIN equ 0x7e00
READ_SECTOR_COUNT equ 8 ; number of sectors to read
READ_LBA equ 1

; Extended Bootloader (Stage 2 Bootloader)
ESP_ADDR equ 0x90000

; System Memory Map
SMAP_SIGNATURE equ 0x534d4150
MMAP_ADDR equ 0x0500 ; above BDA
LIST_ENTRY_SIZE equ 24 ; size of map entry in bytes
