OUTPUT_FORMAT(binary)
ENTRY(_start)

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
    ASSERT((boot_end - boot_start) <= 510, "boot.asm exceeds 510 bytes")

    . = boot_start + 510;
    .sig : { SHORT(0xaa55) }

    . = 0x7e00;
    .bridge :
    {
        *bridge.o(.text)
        *bridge.o(.data)
        *bridge.o(.rodata)
    }
}
