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

static vga_display vga;

/* Sets the provided cell with the given value */
static void vga_set_cell(uint16_t *ptr, uint8_t c) {
  *ptr = (vga.bg_color << 12) | (vga.fg_color << 8) | c;
}

/* Clears the VGA screen and resets the cursor */
void vga_clear(void) {
  for (size_t i = 0; i < vga.rows * vga.cols; i++) {
    vga_set_cell(&vga.address[i], VGA_CLEAR);
  }
  vga_set_cursor(0);
}

/* Details of the VGA display */
vga_display vga_get(void) { return vga; }

/* Initialises the VGA display and sets the cursor to 0 */
void vga_init(void) {
  vga.address = (uint16_t *)VGA_ADDRESS;
  vga.rows = VGA_ROWS;
  vga.cols = VGA_COLS;
  vga.bg_color = VGA_COLOR_BLACK;
  vga_set_cursor(0); /* start of the screen */

  vga_set(VGA_COLOR_WHITE, VGA_COLOR_BLACK);
}

/* Moves the cursor to the next line */
void vga_nextln(void) {
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
void vga_printchar(const uint8_t c) {
  uint16_t *ptr = vga.address + vga.cursor;
  switch (c) {
  case '\0':
    return;
  case '\b':
    if (vga.cursor % vga.cols != 0) {
      vga_set_cell(ptr - 1, VGA_CLEAR);
      vga_set_cursor(vga.cursor - 1);
    }
    break;
  case '\n':
    vga_nextln();
    break;
  default:
    vga_set_cell(ptr, c);
    vga_set_cursor(vga.cursor + 1);
  }
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
  for (; prev < display_end; prev++) {
    vga_set_cell(prev, VGA_CLEAR);
  }
}

/* Sets the foreground and background color for the display */
void vga_set(vga_color fg, vga_color bg) {
  vga.fg_color = fg;
  vga.bg_color = bg;
}

/* Sets the cursor using the position from the beginning of the screen */
void vga_set_cursor(uint16_t position) {
  vga.cursor = position;

  outb(0x3D4, 0x0F);
  outb(0x3D5, (uint8_t)(position & 0xFF));
  outb(0x3D4, 0x0E);
  outb(0x3D5, (uint8_t)((position >> 8) & 0xFF));
}

/* Prints the text buffer on the screen upto the given length */
void vga_write(const uint8_t *buf, size_t len) {
  const uint8_t *c = buf;
  for (size_t i = 0; i < len; i++) {
    vga_printchar(*c);
    c++;
  }
}
