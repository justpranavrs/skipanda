; Bridge (Stage 2 Bootloader)
%include "src/config.asm"

bits 16 ; 16-bit real mode

_start_bridge:    
    call enable_a20 ; enable a20 address line
    cmp ax, 0
    je halt_cpu

run:
    jmp $

%include ASM_A20
%include ASM_UTILS

times 2048-($-$$) db 0
