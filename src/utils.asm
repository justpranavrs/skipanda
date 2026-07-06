; Common Utilities
display: ; display on the screen
    mov ah, 0x0e ; write character in tty mode
.print:
    lodsb
    or al, al
    jz .done
    int 0x10 ; invoke interrupt
    jmp .print
.done:
    ret

halt_cpu: ; halt the cpu
    cli
    hlt
    jmp $
