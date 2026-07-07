/* -----------------------------------------------------------------------------
 * @file     main.c
 * @title    Entry Point of Stage C Bootloader
 * @desc     Initialises the 32-Bit Protected-Mode execution environment.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#include "keyboard.h"
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
  vga_init();

  vga_println("SKIPANDA Bootloader v0.1.0");
  vga_nextln();

  while(1) {
      vga_printchar(kb_process());
  }

  while (1) {
  } /* boot_main never returns */
}
