; widget demo

    mov r0, window_struct
    mov r1, window_title
    mov r2, 256
    mov r3, 128
    mov r4, 64
    mov r5, 64
    mov r6, 0
    mov r7, button_0_widget
    call new_window

    mov r0, 0xFFFFFFFF
    mov r1, window_struct
    call fill_window

    mov r0, window_struct
    call draw_widgets_to_window

event_loop:
    mov r0, window_struct
    call get_next_window_event

    ; did the user click somewhere in the window?
    cmp r0, EVENT_TYPE_MOUSE_CLICK
    ifz call mouse_click_event

    ; did the user click a button?
    cmp r0, EVENT_TYPE_BUTTON_CLICK
    ifz call button_click_event

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

button_click_event:
    ; r1 contains the ID of the clicked button

    ; button 0
    cmp r1, 0
    ifz call button_0_clicked

    ; button 1
    cmp r1, 1
    ifz call button_1_clicked

    ret

button_0_clicked:
    push r0
    push r1

    mov r0, window_struct
    call get_window_overlay_number
    mov r5, r0
    mov r0, button_0_clicked_text
    mov r1, 16
    mov r2, 112
    mov r3, 0xFF000000
    mov r4, 0xFFFFFFFF
    call draw_str_to_overlay

    pop r1
    pop r0
    ret

button_1_clicked:
    push r0
    push r1

    mov r0, window_struct
    call get_window_overlay_number
    mov r5, r0
    mov r0, button_1_clicked_text
    mov r1, 16
    mov r2, 112
    mov r3, 0xFF000000
    mov r4, 0xFFFFFFFF
    call draw_str_to_overlay

    pop r1
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

window_title: data.str "Widget Demo" data.8 0
window_struct: data.fill 0, 36

button_0_widget:
    data.32 button_1_widget    ; next_ptr
    data.32 0                  ; id
    data.32 WIDGET_TYPE_BUTTON ; type
    data.32 button_0_text      ; text_ptr
    data.32 0xFFFFFFFF         ; foreground_color
    data.32 0xFF000000         ; background_color
    data.16 80                 ; width
    data.16 0                  ; reserved
    data.16 16                 ; x_pos
    data.16 32                 ; y_pos
button_0_text: data.str "button 0" data.8 0

button_1_widget:
    data.32 0                  ; next_ptr
    data.32 1                  ; id
    data.32 WIDGET_TYPE_BUTTON ; type
    data.32 button_1_text      ; text_ptr
    data.32 0xFFFFFFFF         ; foreground_color
    data.32 0xFF000000         ; background_color
    data.16 80                 ; width
    data.16 0                  ; reserved
    data.16 16                 ; x_pos
    data.16 64                 ; y_pos
button_1_text: data.str "button 1" data.8 0

button_0_clicked_text: data.str "button 0 clicked!" data.8 0
button_1_clicked_text: data.str "button 1 clicked!" data.8 0

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
