; Enables A20 Address Line
; Requires (%include ASM_UTILS)
enable_a20:
    call check_a20
    cmp ax, 1
    je a20_success
a20_bios: ; try enabling a20 with bios
    mov ax, 0x2403 ; query a20 gate support
    int 0x15
    jc a20_keyboard
    test ah, ah
    jnz a20_keyboard

    mov ax, 0x2402 ; get a20 gate support
    int 0x15
    jc a20_keyboard
    test ah, ah
    jnz a20_keyboard

    mov ax, 0x2401 ; activate a20 gate
    int 0x15
    jc a20_keyboard
    test ah, ah
    jnz a20_keyboard

    call check_a20
    cmp ax, 1
    je a20_success
a20_keyboard: ; try enabling a20 with keyboard controller
    cli ; disable hardware interrupts

    call .wait_io1 ; disable keyboard port
    mov al, 0xad
    out 0x64, al

    call .wait_io1 ; read controller output port
	mov al, 0xd0
	out 0x64, al

	call .wait_io2
	in al, 0x60
	push ax

	call .wait_io1 ; modify and write back the output port
	mov al, 0xd1
	out 0x64, al

	call .wait_io1
	pop ax
	or al, 2
	out 0x60, al

	call .wait_io1 ; enable keyboard
	mov al, 0xae
	out 0x64, al

    call .wait_io1
	sti ; enable hardware interrupts

	call check_a20
    cmp ax, 1
    je a20_success
    jne a20_fast
.wait_io1: ; wait until keyboard is ready
	in al, 0x64
	test al, 2
	jnz .wait_io1
	ret

.wait_io2: ; wait for output buffer
	in al, 0x64
	test al, 1
	jz .wait_io2
	ret

a20_fast: ; fast a20 gate
    in al, 0x92
    test al, 2
    jnz .check
    
    or al, 2 ; set bit 1
    and al, 0xFE
    out 0x92, al
.check:
    call check_a20
    cmp ax, 1
    jne a20_fail

a20_success: ; a20 is enabled
    mov si, a20_success_msg
    call display_16

    mov ax, 1
    ret

a20_fail: ; could not enable a20
    mov si, a20_fail_err_msg
    call display_16

    mov ax, 0
    ret

check_a20: ; check if a20 is enabled
    push ds
    push es

    xor ax, ax
    mov es, ax ; es = 0x0000
    not ax
    mov ds, ax ; ds = 0xffff

    mov di, 0x0500
    mov si, 0x0510

    mov byte [es:di], 0x00
    mov byte [ds:si], 0xff

    cmp byte [es:di], 0xff ; checks if memory is wrapped

    mov ax, 0
    je .done

    mov ax, 1
.done:
    pop ds
    pop es
    ret

a20_fail_err_msg db "A20 ERR: FAILED", 0x0d, 0x0a, 0
a20_success_msg db "A20 ENABLED", 0x0d, 0x0a, 0
