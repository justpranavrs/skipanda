ASM = nasm
BOOT_EMU = qemu-system-i386

# Directory Configuration
BUILD_DIR = build

# Source Files
BOOT_SRC = src/boot.asm
BOOT_EXT_SRC = src/boot_ext.asm
LINKER_SRC = linker.ld

# Generated Artifacts
BOOT_OBJ = $(BUILD_DIR)/boot.o
BOOT_LIST = $(BUILD_DIR)/boot.lst

BOOT_EXT_OBJ = $(BUILD_DIR)/boot_ext.o
BOOT_EXT_LIST = $(BUILD_DIR)/boot_ext.lst

IMG_SRC = $(BUILD_DIR)/disk.img

.PHONY: all run clean $(BOOT_SRC) $(BOOT_EXT_SRC)

all: $(IMG_SRC)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BOOT_OBJ): $(BOOT_SRC) | $(BUILD_DIR)
	$(ASM) -f elf32 $(BOOT_SRC) -o $(BOOT_OBJ) -l $(BOOT_LIST)

$(BOOT_EXT_OBJ): $(BOOT_EXT_SRC) | $(BUILD_DIR)
	$(ASM) -f elf32 $(BOOT_EXT_SRC) -o $(BOOT_EXT_OBJ) -l $(BOOT_EXT_LIST)

$(IMG_SRC): $(BOOT_OBJ) $(BOOT_EXT_OBJ)
	ld -m elf_i386 -T $(LINKER_SRC) -o $(IMG_SRC) $(BOOT_OBJ) $(BOOT_EXT_OBJ)

run: clean $(IMG_SRC)
	$(BOOT_EMU) -drive format=raw,file=$(IMG_SRC)

clean:
	@rm -rf $(BUILD_DIR)
