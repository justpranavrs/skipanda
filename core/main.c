/* -----------------------------------------------------------------------------
 * @file     main.c
 * @title    Entry Point of Stage C Bootloader
 * @desc     Initialises the 32-Bit Protected-Mode execution environment.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#include "vga.h"
#include <stdint.h>

/* Memory Map */
typedef struct {
  uint32_t address;    /* physical address of the system memory map */
  uint32_t entry_size; /* size of an entry in the map */
} __attribute__((packed)) mmap_config_t;

/*
 * Main entry point for the Stage C bootloader.
 */
void __attribute__((cdecl, noreturn)) boot_main(mmap_config_t *mmap_cfg) {

  /* initialize the vga display */
  vga_initialize();
  vga_set(VGA_COLOR_WHITE, VGA_COLOR_LIGHT_BLUE);
  vga_clear();

  vga_println("(32-BIT PROTECTED MODE) STAGE C BOOTED...");

  while (1) {
  } /* boot_main never returns */
}
