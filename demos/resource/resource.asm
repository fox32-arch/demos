; widget demo, with a window created from an external .rsf resource file

    ; open and read resource.rsf into a buffer
    ; exit if file not found
    call get_current_disk_id
    mov r1, r0
    mov r0, window_rsf_filename
    mov r2, window_rsf_struct
    call open
    cmp r0, 0
    ifz call end_current_task
    mov r0, window_rsf_struct
    call get_size
    push r0
    call allocate_memory ; TODO: error handling?
    mov [window_rsf_buffer_ptr], r0
    pop r0
    mov r1, window_rsf_struct
    mov r2, [window_rsf_buffer_ptr]
    call read

    ; extract the resource data from the .rsf
    mov r0, [window_rsf_buffer_ptr]
    call get_res_in_fxf
    mov r1, r0

    ; create the window
    mov r0, window_struct
    ; r1 set above
    call new_window_from_resource

    ; free the memory used by the .rsf as it is no longer needed
    mov r0, [window_rsf_buffer_ptr]
    call free_memory

    ; fill the window with white
    mov r0, 0xFFFFFFFF
    mov r1, window_struct
    call fill_window

    ; redraw the widgets after filling the window
    mov r0, window_struct
    call draw_widgets_to_window

event_loop:
    mov r0, window_struct
    call get_next_window_event

    ; did the user click somewhere in the window?
    cmp r0, EVENT_TYPE_MOUSE_CLICK
    ifz call mouse_click_event

    call yield_task
    rjmp event_loop

mouse_click_event:
    push r0

    ; check if we are attempting to drag or close the window
    cmp r2, 16
    iflteq jmp drag_or_close_window

    ; check if we are clicking on a widget
    mov r0, window_struct
    call handle_widget_click

    pop r0
    ret

drag_or_close_window:
    cmp r1, 8
    iflteq jmp close_window
    mov r0, window_struct
    call start_dragging_window
    pop r0
    ret
close_window:
    mov r0, window_struct
    call destroy_window
    call end_current_task

window_struct: data.fill 0, 40
window_rsf_filename: data.strz "resource.rsf"
window_rsf_struct: data.fill 0, 32
window_rsf_buffer_ptr: data.32 0

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
