ASM = nasm
BOOT_EMU = qemu-system-i386

# Directory Configuration
BUILD_DIR = build

# Source Files
BOOT_SRC = src/boot.asm
BRIDGE_SRC = src/bridge.asm
LINKER_SRC = linker.ld

# Generated Artifacts
BOOT_OBJ = $(BUILD_DIR)/boot.o
BOOT_LIST = $(BUILD_DIR)/boot.lst

BRIDGE_OBJ = $(BUILD_DIR)/bridge.o
BRIDGE_LIST = $(BUILD_DIR)/bridge.lst

IMG_SRC = $(BUILD_DIR)/disk.img

.PHONY: all run clean $(BOOT_SRC) $(BRIDGE_SRC)

all: $(IMG_SRC)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(BOOT_OBJ): $(BOOT_SRC) | $(BUILD_DIR)
	$(ASM) -f elf32 $(BOOT_SRC) -o $(BOOT_OBJ) -l $(BOOT_LIST)

$(BRIDGE_OBJ): $(BRIDGE_SRC) | $(BUILD_DIR)
	$(ASM) -f elf32 $(BRIDGE_SRC) -o $(BRIDGE_OBJ) -l $(BRIDGE_LIST)

$(IMG_SRC): $(BOOT_OBJ) $(BRIDGE_OBJ)
	ld -m elf_i386 -T $(LINKER_SRC) -o $(IMG_SRC) $(BOOT_OBJ) $(BRIDGE_OBJ)

run: clean $(IMG_SRC)
	$(BOOT_EMU) -drive format=raw,file=$(IMG_SRC)

clean:
	@rm -rf $(BUILD_DIR)
