; tiny code christmas in fox32 assembly. draws a little pattern to the screen
; run this as a boot sector (i.e. pass to fox32 as a bootable disk)

    opton
    org 0x00000800

    mov r11, 479 ; Y counter
y_loop:
    mov r10, 639 ; X counter
x_loop:
    mov r0, r10
    mov r1, r11
    add r1, 16
    mov r2, r10
    xor r2, r11
    rem r2, 3
    mul r2, 128
    or r2, 0xFF000000
    call [0xF004201C] ; draw_pixel_to_background
    dec r10
    ifnz rjmp x_loop
    dec r11
    ifnz rjmp y_loop

    rjmp 0

    ; bootable magic bytes
    org.pad 0x000009FC
    data.32 0x523C334C
