/* -----------------------------------------------------------------------------
* @file     linker.ld
* @desc     Links the MBR, Extended Bootloader and Stage C Bootloader
* @author   Pranav R S
* -----------------------------------------------------------------------------
*/
OUTPUT_FORMAT(binary)
ENTRY(start)

SECTIONS
{
    boot_start = 0x7c00;
    . = boot_start;
    .boot :
    {
        *boot.o(.text)
        *boot.o(.data)
        *boot.o(.rodata)
    }
    boot_end = .;
    ASSERT((boot_end - boot_start) == 512, "boot.asm must be exactly 512 bytes")

    . = 0x7e00;
    .boot_ext :
    {
        *boot_ext.o(.text)
        *boot_ext.o(.data)
        *boot_ext.o(.rodata)
    }

    . = 0x7e00 + 1024;
    .text :
    {
        *(.text)
    }

    .data :
    {
        *(.data)
    }

    .rodata :
    {
        *(.rodata)
    }

    .bss :
    {
        *(.bss)
        *(COMMON)
    }
}
