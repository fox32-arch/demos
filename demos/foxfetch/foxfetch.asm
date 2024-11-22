; foxfetch

    opton

    pop [terminal_stream_struct_ptr]
    cmp [terminal_stream_struct_ptr], 0
    ifz call end_current_task

    mov r0, rom_string
    call print_str_to_terminal
    call get_rom_version
    add r0, '0'
    call print_character_to_terminal
    movz.8 r0, '.'
    call print_character_to_terminal
    mov r0, r1
    add r0, '0'
    call print_character_to_terminal
    movz.8 r0, '.'
    call print_character_to_terminal
    mov r0, r2
    add r0, '0'
    call print_character_to_terminal
    movz.8 r0, 10
    call print_character_to_terminal

    mov r0, kern_string
    call print_str_to_terminal
    call get_os_version
    add r0, '0'
    call print_character_to_terminal
    movz.8 r0, '.'
    call print_character_to_terminal
    mov r0, r1
    add r0, '0'
    call print_character_to_terminal
    movz.8 r0, '.'
    call print_character_to_terminal
    mov r0, r2
    add r0, '0'
    call print_character_to_terminal
    movz.8 r0, 10
    call print_character_to_terminal

    mov r0, heap_string
    call print_str_to_terminal
    call heap_usage
    push r0
    div r0, 1048576
    call print_decimal_to_terminal
    mov r0, mib_string
    call print_str_to_terminal
    movz.8 r0, '('
    call print_character_to_terminal
    pop r0
    call print_decimal_to_terminal
    mov r0, bytes_string
    call print_str_to_terminal
    movz.8 r0, ')'
    call print_character_to_terminal
    movz.8 r0, 10
    call print_character_to_terminal

    call end_current_task

; print a character to the terminal
; inputs:
; r0: ASCII character
; outputs:
; none
print_character_to_terminal:
    push r1
    push r2

    mov.8 [char_buffer], r0
    mov r0, 1
    mov r1, [terminal_stream_struct_ptr]
    mov r2, char_buffer
    call write

    pop r2
    pop r1
    ret

; print a string to the terminal
; inputs:
; r0: pointer to null-terminated string
; outputs:
; none
print_str_to_terminal:
    push r0
    push r1
    push r2

    mov r2, r0
    call string_length
    mov r1, [terminal_stream_struct_ptr]
    call write

    pop r2
    pop r1
    pop r0
    ret

; print a decimal integer to the terminal
; inputs:
; r0: integer
; outputs:
; none
print_decimal_to_terminal:
    push r0
    push r10
    push r11
    push r12
    push r13
    mov r10, rsp
    mov r12, r0

    push.8 0
print_decimal_to_terminal_loop:
    push r12
    div r12, 10
    pop r13
    rem r13, 10
    mov r11, r13
    add r11, '0'
    push.8 r11
    cmp r12, 0
    ifnz jmp print_decimal_to_terminal_loop
print_decimal_to_terminal_print:
    mov r0, rsp
    call print_str_to_terminal

    mov rsp, r10
    pop r13
    pop r12
    pop r11
    pop r10
    pop r0
    ret

kern_string:  data.strz "krnl: "
rom_string:   data.strz "rom:  "
heap_string:  data.strz "heap: "
mib_string:   data.strz " MiB "
bytes_string: data.strz " bytes"

terminal_stream_struct_ptr: data.32 0
char_buffer: data.32 0

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
