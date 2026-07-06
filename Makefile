BOOT_DIR = boot
C_DIR = core
CONFIG_SRC = $(BOOT_DIR)/config.inc

# Compiler and Emulator
ASM = nasm
ASMFLAGS = -f elf32 -p $(CONFIG_SRC)
BOOT_EMU = qemu-system-i386

CC = i686-elf-gcc
CCFLAGS = -std=gnu99 -ffreestanding -nostdlib -O2 -Wall -Wextra -I$(C_DIR)/include

# Directory Configuration
BUILD_DIR = build

# Source Files
BOOT_SRC = $(BOOT_DIR)/boot.asm
BOOT_EXT_SRC = $(BOOT_DIR)/boot_ext.asm
LINKER_SRC = linker.ld

# C
MAIN_SRC = $(C_DIR)/main.c
VGA_SRC = $(C_DIR)/vga.c

# Generated Artifacts
BOOT_OBJ = $(BUILD_DIR)/boot.o
BOOT_LIST = $(BUILD_DIR)/boot.lst

BOOT_EXT_OBJ = $(BUILD_DIR)/boot_ext.o
BOOT_EXT_LIST = $(BUILD_DIR)/boot_ext.lst

MAIN_OBJ = $(BUILD_DIR)/main.o
VGA_OBJ = $(BUILD_DIR)/vga.o

OBJS = $(BOOT_OBJ) $(BOOT_EXT_OBJ) $(MAIN_OBJ) $(VGA_OBJ)
IMG_SRC = $(BUILD_DIR)/skipanda.img

.PHONY: all run clean $(BOOT_SRC) $(BOOT_EXT_SRC) $(MAIN_SRC)

all: $(IMG_SRC)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BOOT_OBJ): $(BOOT_SRC) | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $(BOOT_SRC) -o $(BOOT_OBJ) -l $(BOOT_LIST)

$(BOOT_EXT_OBJ): $(BOOT_EXT_SRC) | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $(BOOT_EXT_SRC) -o $(BOOT_EXT_OBJ) -l $(BOOT_EXT_LIST)

$(MAIN_OBJ):  $(MAIN_SRC) | $(BUILD_DIR)
	$(CC) $(CCFLAGS) -c $(MAIN_SRC) -o $(MAIN_OBJ)

$(VGA_OBJ):  $(VGA_SRC) | $(BUILD_DIR)
	$(CC) $(CCFLAGS) -c $(VGA_SRC) -o $(VGA_OBJ)
	
$(IMG_SRC): $(OBJS)
	ld -m elf_i386 -T $(LINKER_SRC) -o $(IMG_SRC) $(OBJS)

run: clean $(IMG_SRC)
	$(BOOT_EMU) -drive format=raw,file=$(IMG_SRC)

clean:
	@rm -rf $(BUILD_DIR)
