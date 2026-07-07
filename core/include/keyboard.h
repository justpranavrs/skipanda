/* -----------------------------------------------------------------------------
 * @file     keyboard.h
 * @title    I8042 PS/2 Keyboard
 * @desc     Functions and definitions for managing the PS/2 keyboard which
 *           can retrieve scancodes and convert to characters.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#pragma once

#include "pmio.h"
#include <stdbool.h>
#include <stdint.h>

#define KB_DATA_PORT (uint16_t)(0x60)
#define KB_IO_PORT (uint16_t)(0x64)

#define KB_NO_PRINT (uint8_t)(0x00)

#define KB_CAPS_LOCK (uint8_t)(0x14)
#define KB_ESCAPE (uint8_t)(0x1b)
#define KB_INVALID_KEY (uint8_t)(0xFF)

static const uint8_t KB_SCANCODE_SET_I[] = {
    KB_NO_PRINT, KB_ESCAPE, '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '0', '-', '=', '\b','\t', 'Q', 'W', 'E', 'R', 'T', 'Y',
    'U', 'I', 'O', 'P', '[', ']', '\n', KB_INVALID_KEY, 'A', 'S', 'D', 'F',
    'G', 'H', 'J', 'K', 'L', ':', '\'', '`', KB_INVALID_KEY, '\\', 'Z', 'X',
    'C', 'V', 'B', 'N', 'M', ',', '.', '/', KB_INVALID_KEY, '*', KB_INVALID_KEY,
    ' ', KB_CAPS_LOCK,
};

typedef struct {
  bool is_caps_lock; /* if caps lock is enabled */
} keyboard;

/* Initializes the keyboard */
void kb_init(void);

/* Handles keyboard state changes and returns the final printable character */
uint8_t kb_process(void);
