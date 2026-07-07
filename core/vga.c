/* -----------------------------------------------------------------------------
 * @file     vga.c
 * @title    Video Graphics Array (VGA)
 * @desc     Implementation of the VGA driver which handles printing, clearing
 *           and cursor handling for colored-text characters.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#include "vga.h"
#include "pmio.h"
#include <stddef.h>
#include <stdint.h>

static vga_display vga;

/* Clears the VGA screen and resets the cursor */
void vga_clear() {
  uint16_t clear_word = (vga.bg_color << 12) | 0x20;
  for (size_t i = 0; i < vga.rows * vga.cols; i++) {
    vga.address[i] = clear_word;
  }
  vga_set_cursor(0);
}

/* Details of the VGA display */
vga_display vga_get() { return vga; }

/* Initialises the VGA with the given configuration and sets the cursor to 0 */
void vga_initialize() {
  vga.address = (uint16_t *)VGA_ADDRESS;
  vga.rows = VGA_ROWS;
  vga.cols = VGA_COLS;
  vga.bg_color = VGA_COLOR_BLACK;
  vga_set_cursor(0); /* start of the screen */
}

/* Moves the cursor to the next line */
void vga_nextln() {
  vga_set_cursor(vga.cursor + vga.cols - (vga.cursor % vga.cols));

  if (vga.cursor >= vga.rows * vga.cols) {
    vga_scroll(1);
  }
}

/* Prints the text on the screen */
void vga_print(const char *text) {
  for (const char *c = text; *c != '\0'; c++) {
    vga_printchar(*c);
  }
}

/* Prints a character on the screen */
void vga_printchar(const char c) {
  uint16_t *ptr = vga.address + vga.cursor;
  *ptr = (vga.bg_color << 12) | (vga.fg_color << 8) | c;
  vga_set_cursor(vga.cursor+1);

  if (vga.cursor >= vga.rows * vga.cols) {
    vga_scroll(1);
  }
}

/* Prints the text on the screen and moves the cursor to the next line */
void vga_println(const char *text) {
  vga_print(text);
  vga_nextln();
}

/* Scrolls the display with the given number of rows */
void vga_scroll(uint8_t rows) {
  if (rows == 0)
    return;

  uint16_t *prev = vga.address; /* start of screen */
  uint16_t *curr =
      vga.address + (rows * vga.cols); /* after scroll start of screen */
  for (size_t i = rows; i < vga.rows; i++) {
    for (size_t c = 0; c < vga.cols; c++) {
      *prev = *curr; /* copy the value */

      prev++;
      curr++;
    }
  }
  vga_set_cursor(prev - vga.address); /* set the new cursor */

  uint16_t *display_end =
      vga.address + (vga.rows * vga.cols); /* end of screen */
  uint16_t clear_word = (vga.bg_color << 12) | 0x20;
  for (; prev < display_end; prev++) {
    *prev = clear_word;
  }
}

/* Sets the foreground and background color for the display */
void vga_set(vga_color fg, vga_color bg) {
  vga.fg_color = fg;
  vga.bg_color = bg;
}

/* Sets the cursor from the beginning of the screen */
void vga_set_cursor(uint16_t position) { 
    vga.cursor = position;
    
    outb(0x3D4, 0x0F);
    outb(0x3D5, (uint8_t)(position & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (uint8_t)((position >> 8) & 0xFF));
}

/* Prints the text buffer on the screen upto the given length */
void vga_write(const char *buf, size_t len) {
  const char *c = buf;
  for (size_t i = 0; i < len; i++) {
    vga_printchar(*c);
    c++;
  }
}
