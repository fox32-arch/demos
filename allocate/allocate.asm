; memory allocation demo

    ; allocate first 4 byte block
    mov r0, 4
    call allocate_memory

    brk

    mov r1, r0

    ; allocate second 4 byte block
    mov r0, 4
    call allocate_memory

    brk

    ; free the first block
    mov r0, r1
    call free_memory

    ; allocate 16 byte block
    mov r0, 16
    call allocate_memory

    brk

    ; allocate third 4 byte block
    mov r0, 4
    call allocate_memory

    brk

    ; allocate fourth 4 byte block
    mov r0, 4
    call allocate_memory

    brk

yield_loop:
    call yield_task
    rjmp yield_loop

    #include "../../fox32rom/fox32rom.def"
    #include "../../fox32os/fox32os.def"
