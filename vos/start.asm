    call main
    call end_current_task

vos_next_win_event:
    push r8
    call get_next_window_event
    mov r8, vos_event_args
    mov.32 [r8], r1
    add r8, 4
    mov.32 [r8], r2
    add r8, 4
    mov.32 [r8], r3
    add r8, 4
    mov.32 [r8], r4
    add r8, 4
    mov.32 [r8], r5
    add r8, 4
    mov.32 [r8], r6
    add r8, 4
    mov.32 [r8], r7
    pop r8
    ret

vos_event_args: data.fill 0, 28

#include "../../fox32rom/fox32rom.def"
#include "../../fox32os/fox32os.def"