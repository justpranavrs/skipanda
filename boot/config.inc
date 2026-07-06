; -----------------------------------------------------------------------------
; @file     config.inc
; @title    Boot Configuration
; @author   Pranav R S
; -----------------------------------------------------------------------------

; Master Boot Record (MBR)
BOOT_ORIGIN equ 0x7c00
READ_ORIGIN equ 0x7e00
READ_SECTOR_COUNT equ 4 ; number of sectors to read
READ_LBA equ 1

; Extended Bootloader (Stage 2 Bootloader)
ESP_ADDR equ 0x9000

; System Memory Map
SMAP_SIGNATURE equ 0x534d4150
MMAP_ADDR equ 0x0500 ; above BDA
LIST_ENTRY_SIZE equ 24 ; size of map entry in bytes

; 32-Bit Protected Mode
VIDEO_MEMORY equ 0xb8000
DISPLAY_ROW_SIZE equ 160 ; size of a row in bytes
DISPLAY_ROWS equ 25
DISPLAY_COLS equ 80
DISPLAY_ATTR equ 0x0f ; white on black
