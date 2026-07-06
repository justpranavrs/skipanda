/* -----------------------------------------------------------------------------
 * @file     vga.c
 * @title    Video Graphics Array (VGA)
 * @desc     Implementation of the VGA driver which handles printing, clearing
 *           and cursor handling for colored-text characters.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#include "vga.h"
#include <stddef.h>
#include <stdint.h>

static vga_display vga;

/* Initialises the VGA with the given configuration and sets the cursor to 0 */
void vga_initialize(vga_config_t *cfg) {
    vga.address = (uint16_t*)(uintptr_t)cfg->address;
    vga.rows = cfg->rows;
    vga.cols = cfg->cols;
    vga.bg_color = VGA_COLOR_BLACK;
    vga.cursor = 0; /* start of the screen */
}

/* Clears the VGA screen, sets the background color and resets the cursor */
void vga_clear_screen(vga_color color) {
    vga.bg_color = color; /* set the background color of the display */
    
    uint16_t *display_end = vga.address + (vga.rows * vga.cols); /* end of screen */
    uint16_t clear_word = (vga.bg_color << 12) | 0x20; /* sets the background color with space */
    for (uint16_t *ptr = vga.address; ptr < display_end; ptr++) {
        *ptr = clear_word;
    }
    vga.cursor = 0;
}

/* Prints the text on the screen and moves the cursor to the next line */
void vga_println(const char *text, vga_color color) {
    uint16_t *ptr = vga.address + vga.cursor;
    for (const char *c = text; *c != '\0'; c++) {
        *ptr = (vga.bg_color << 12) | (color << 8) | *c;

        ptr++;
        vga.cursor++;
    }

    /* move the cursor to next line */
    if (vga.cursor % vga.cols != 0) {
        vga.cursor = vga.cursor + vga.cols - (vga.cursor % vga.cols);
    }
}