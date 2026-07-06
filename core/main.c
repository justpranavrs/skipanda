/* -----------------------------------------------------------------------------
 * @file     main.c
 * @title    Entry Point of Stage C Bootloader
 * @desc     Initialises the 32-Bit Protected-Mode execution environment.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#include <stdint.h>
#include "vga.h"

/* Memory Map */
typedef struct {
  uint32_t address;    /* physical address of the system memory map */
  uint32_t entry_size; /* size of an entry in the map */
} __attribute__((packed)) mmap_config_t;

/*
 * Main entry point for the Stage C bootloader.
 */
void __attribute__((cdecl, noreturn)) boot_main(
    mmap_config_t *mmap_cfg, 
    vga_config_t  *vga_cfg,
    uint32_t esp_address
) {
    
    vga_initialize(vga_cfg);
    vga_clear_screen(VGA_COLOR_LIGHT_BLUE);

    char *c_bootloader_message = "(32-BIT PROTECTED MODE) STAGE C BOOTED...";
    vga_println(c_bootloader_message, VGA_COLOR_WHITE);
    
    while (1) {
    } /* boot_main never returns */
}
