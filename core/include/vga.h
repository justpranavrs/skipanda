/* -----------------------------------------------------------------------------
 * @file     vga.h
 * @title    Video Graphics Array (VGA)
 * @desc     Functions and definitions for managing the VGA display. Handles
 *           printing, clearing, scrolling for colored text characters.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#pragma once

#include <stddef.h>
#include <stdint.h>

/* VGA */
typedef struct {
  uint32_t address; /* physical address of the video memory */
  uint32_t rows;    /* number of rows in the display */
  uint32_t cols;    /* number of columns in the display */
} __attribute__((packed)) vga_config_t;

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
  vga_color bg_color; /* background color */
  uint16_t *address;
  uint16_t cursor; /* current cursor position */
} vga_display;

/* Initializes the VGA with the provided physical address, rows and columns */
void vga_initialize(vga_config_t *cfg);

/* Clears the VGA display screen, sets the background color and resets the
 * cursor */
void vga_clear_screen(vga_color color);

/* Prints the text on the screen and moves the cursor to the next line */
void vga_println(const char *text, vga_color color);
