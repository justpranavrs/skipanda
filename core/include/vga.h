/* -----------------------------------------------------------------------------
 * @file     vga.h
 * @title    Video Graphics Array (VGA)
 * @desc     Functions and definitions for managing the VGA display. Handles
 *           printing, clearing, scrolling, cursor handling for
 *           colored text characters.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#pragma once

#include <stddef.h>
#include <stdint.h>

#define VGA_ADDRESS ((uintptr_t)0xb8000)
#define VGA_ROWS ((size_t)25)
#define VGA_COLS ((size_t)80)

#define VGA_CLEAR (uint8_t)(0x20)

/* Hardware text mode color constants */
typedef enum {
  VGA_COLOR_BLACK = 0,
  VGA_COLOR_BLUE = 1,
  VGA_COLOR_GREEN = 2,
  VGA_COLOR_CYAN = 3,
  VGA_COLOR_RED = 4,
  VGA_COLOR_MAGENTA = 5,
  VGA_COLOR_BROWN = 6,
  VGA_COLOR_LIGHT_GRAY = 7,
  VGA_COLOR_DARK_GRAY = 8,
  VGA_COLOR_LIGHT_BLUE = 9,
  VGA_COLOR_LIGHT_GREEN = 10,
  VGA_COLOR_LIGHT_CYAN = 11,
  VGA_COLOR_LIGHT_RED = 12,
  VGA_COLOR_LIGHT_MAGENTA = 13,
  VGA_COLOR_YELLOW = 14,
  VGA_COLOR_WHITE = 15,
} vga_color;

/* Defines VGA Display */
typedef struct {
  size_t rows; /* number of rows */
  size_t cols; /* number of columns */

  vga_color fg_color; /* foreground color */
  vga_color bg_color; /* background color */

  uint16_t *address;
  uint16_t cursor; /* current cursor position */
} vga_display;

/* Clears the VGA display screen and resets the cursor */
void vga_clear(void);

/* Details of the VGA display */
vga_display vga_get(void);

/* Initializes the VGA with the physical address, rows and columns */
void vga_init(void);

/* Moves the cursor to the next line */
void vga_nextln(void);

/* Prints the text on the screen */
void vga_print(const char *text);

/* Prints a character on the screen */
void vga_printchar(const uint8_t c);

/* Prints the text on the screen and moves the cursor to the next line */
void vga_println(const char *text);

/* Scrolls the display with the given number of rows */
void vga_scroll(uint8_t rows);

/* Sets the foreground and background color for the display */
void vga_set(vga_color fg, vga_color bg);

/* Sets the cursor using the position from the beginning of the screen */
void vga_set_cursor(uint16_t position);

/* Prints the text buffer on the screen upto the given length */
void vga_write(const uint8_t *buf, size_t len);
