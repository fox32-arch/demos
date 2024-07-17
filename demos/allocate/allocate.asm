; memory allocation demo

    pop [stream_ptr]

    mov r0, info_string
    call print

    ; allocate first 4 byte block
    mov r0, first_4byte_string
    call print
    mov r0, 4
    call allocate_memory
    mov [first_4byte_ptr], r0
    call print_hex
    mov r0, lf
    call print

    ; allocate second 4 byte block
    mov r0, second_4byte_string
    call print
    mov r0, 4
    call allocate_memory
    mov [second_4byte_ptr], r0
    call print_hex
    mov r0, lf
    call print

    ; free the first 4 byte block
    mov r0, free_first_4byte_string
    call print
    mov r0, [first_4byte_ptr]
    call free_memory

    ; allocate 16 byte block
    mov r0, single_16byte_string
    call print
    mov r0, 16
    call allocate_memory
    mov [single_16byte_ptr], r0
    call print_hex
    mov r0, lf
    call print

    ; allocate third 4 byte block
    mov r0, third_4byte_string
    call print
    mov r0, 4
    call allocate_memory
    mov [third_4byte_ptr], r0
    call print_hex
    mov r0, lf
    call print

    ; allocate fourth 4 byte block
    mov r0, fourth_4byte_string
    call print
    mov r0, 4
    call allocate_memory
    mov [fourth_4byte_ptr], r0
    call print_hex
    mov r0, lf
    call print

    ; free all live blocks and exit
    mov r0, [second_4byte_ptr]
    call free_memory
    mov r0, [third_4byte_ptr]
    call free_memory
    mov r0, [fourth_4byte_ptr]
    call free_memory
    mov r0, [single_16byte_ptr]
    call free_memory
    call end_current_task

info_string: data.str "memory allocation demo" data.8 10 data.8 0
first_4byte_string: data.strz "ptr from 1st 4 byte allocation: "
second_4byte_string: data.strz "ptr from 2nd 4 byte allocation: "
third_4byte_string: data.strz "ptr from 3rd 4 byte allocation: "
fourth_4byte_string: data.strz "ptr from 4th 4 byte allocation: "
free_first_4byte_string: data.str "freeing 1st allocation" data.8 10 data.8 0
single_16byte_string: data.strz "ptr from 16 byte allocation: "
lf: data.8 10 data.8 0

print:
    push r0
    push r1
    push r2

    mov r2, r0
    call string_length
    mov r1, [stream_ptr]
    call write

    pop r2
    pop r1
    pop r0
    ret

print_hex:
    push r0
    push r1
    push r2
    push r10
    push r11
    push r12
    push r31

    mov r10, r0
    mov r31, 8
print_hex_loop:
    rol r10, 4
    movz.16 r11, r10
    and r11, 0x0F
    add r11, print_hex_characters
    mov.8 [print_hex_buffer], [r11]
    mov r0, 1
    mov r1, [stream_ptr]
    mov r2, print_hex_buffer
    call write
    loop print_hex_loop

    pop r31
    pop r12
    pop r11
    pop r10
    pop r2
    pop r1
    pop r0
    ret
print_hex_characters: data.str "0123456789ABCDEF"
print_hex_buffer: data.8 0

stream_ptr: data.32 0
first_4byte_ptr: data.32 0
second_4byte_ptr: data.32 0
third_4byte_ptr: data.32 0
fourth_4byte_ptr: data.32 0
single_16byte_ptr: data.32 0

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
