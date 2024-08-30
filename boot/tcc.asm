; tiny code christmas in fox32 assembly. draws a little pattern to the screen
; run this as a boot sector (i.e. pass to fox32 as a bootable disk)

    opton
    org 0x00000800

entry:
    mov r11, 479 ; Y counter
y_loop:
    mov r31, 639 ; X counter
x_loop:
    mov r0, r31
    mov r1, r11
    add r1, 16
    mov r2, r31
    xor r2, r11
    rem r2, 3
    sla r2, 7
    call [0xF004201C] ; draw_pixel_to_background
    rloop.8 x_loop
    dec r11
    ifnz rjmp.8 y_loop

    rjmp.8 entry

    ; bootable magic bytes
    nop ; work around an assembler bug with org.pad coming after a non-32-bit instruction
    org.pad 0x000009FC
    data.32 0x523C334C
