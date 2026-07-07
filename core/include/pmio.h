/* -----------------------------------------------------------------------------
 * @file     pmio.h
 * @title    Port IO
 * @desc     Defines the low level abstractions with inline assembly wrappers
 *           for Port-Mapped Input/Output (PMIO).
 * @author   Pranav R S
 * -----------------------------------------------------------------------------
 */

#pragma once

#include <stdint.h>

/* Sends an 8-bit value to the specified port */
static inline void outb(uint16_t port, uint8_t value) {
    __asm__ volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}

/* Reads an 8-bit value from the specified port */
static inline uint8_t inb(uint16_t port) {
    uint8_t value;
    __asm__ volatile ("inb %1, %0" :  "=a"(value) : "Nd"(port));
    return value;
}