; multitasking demo

    ; fox32os starts running this code as task 0
    ; first, allocate 256 byte memory blocks to be used as stacks by tasks 1 and 2
    mov r0, 256
    call allocate_memory
    mov [task_1_stack_pointer], r0
    mov r0, 256
    call allocate_memory
    mov [task_2_stack_pointer], r0

    ; start task 1
    mov r0, 1                      ; task ID
    mov r1, task_1                 ; pointer to task code block
    mov r2, [task_1_stack_pointer] ; pointer to task stack block
    mov r3, 0                      ; pointer to task code block to free when task ends
                                   ; (zero since we don't want to free any code blocks when the task ends)
    mov r4, [task_1_stack_pointer] ; pointer to task stack block to free when task ends
    call new_task

    ; start task 2
    mov r0, 2                      ; task ID
    mov r1, task_2                 ; pointer to task code block
    mov r2, [task_2_stack_pointer] ; pointer to task stack block
    mov r3, 0                      ; pointer to task code block to free when task ends
                                   ; (zero since we don't want to free any code blocks when the task ends)
    mov r4, [task_2_stack_pointer] ; pointer to task stack block to free when task ends
    call new_task

    ; end task 0
    call end_current_task



; this runs as task 1
task_1:
    call get_current_task_id
    mov r10, r0
    mov r0, task_id_str
    mov r1, 16
    mov r2, 16
    mov r3, 0xFFFFFFFF
    mov r4, 0xFF000000
    call draw_format_str_to_background

    mov r0, 0
task_1_loop:
    inc r0
    mov r1, 80
    mov r2, 16
    mov r3, 0xFFFFFFFF
    mov r4, 0xFF000000
    call draw_decimal_to_background
    push r0
    call yield_task
    pop r0
    jmp task_1_loop



; this runs as task 2
task_2:
    call get_current_task_id
    mov r10, r0
    mov r0, task_id_str
    mov r1, 16
    mov r2, 32
    mov r3, 0xFFFFFFFF
    mov r4, 0xFF000000
    call draw_format_str_to_background

    mov r0, 0xFFFFFFFF
task_2_loop:
    dec r0
    mov r1, 80
    mov r2, 32
    mov r3, 0xFFFFFFFF
    mov r4, 0xFF000000
    call draw_decimal_to_background
    push r0
    call yield_task
    pop r0
    jmp task_2_loop



task_1_stack_pointer: data.32 0
task_2_stack_pointer: data.32 0
task_id_str: data.str "Task %u: " data.8 0

    #include "../../fox32rom/fox32rom.def"
    #include "../../fox32os/fox32os.def"
