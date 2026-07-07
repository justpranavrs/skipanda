/* -----------------------------------------------------------------------------
 * @file     keyboard.c
 * @title    I8042 PS/2 Keyboard
 * @desc     Implementation of the keyboard driver for managing the PS/2
 *           controller which can retrieve scancodes and convert to characters.
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#include "keyboard.h"
#include <stdint.h>

static keyboard kb;

/* Checks if the output buffer is full using the status register */
static inline bool kb_has_data(void) { return (inb(KB_IO_PORT) & 0x01); }

/* Retrieves the scancode using the data port */
static inline uint8_t kb_read_scancode(void) { return inb(KB_DATA_PORT); }

/* Checks if the scancode was a release */
static inline bool kb_is_release(uint8_t scancode) { return (scancode & 0x80); }

/* Retrives the scancode from the keyboard */
static uint8_t kb_get_scancode(void) {
  uint8_t scancode;
  do {
    while (!kb_has_data()) {
    }
    scancode = kb_read_scancode();
  } while (kb_is_release(scancode));
  return scancode;
}

/* Retrieves the character using the scancode */
static uint8_t kb_scancode_to_char(uint8_t scancode) {
  if (scancode > 58) {
    return KB_NO_PRINT;
  }
  return KB_SCANCODE_SET_I[scancode];
}

/* Initialises the keyboard */
void kb_init(void) { kb.is_caps_lock = false; }

/* Handles keyboard state changes and returns the final printable character */
uint8_t kb_process(void) {
    char c = kb_scancode_to_char(kb_get_scancode());
    switch (c) {
    case KB_CAPS_LOCK:
      kb.is_caps_lock = !kb.is_caps_lock;
      c = KB_NO_PRINT;
      break;
    default:
      if (!kb.is_caps_lock && (c >= 'A' && c <= 'Z')) {
        c += 0x20;
      }
    }
    return c;
}
