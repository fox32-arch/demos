; peter alert lol
; inspired by kokoscript's peter alert: https://github.com/kokoscript/PeterAlert

    mov r0, window_struct
    mov r1, window_title
    mov r2, 64
    mov r3, 64
    mov r4, 64
    mov r5, 64
    mov r6, 0
    mov r7, button_widget
    call new_window

    mov r0, 0xFFFFFFFF
    mov r1, window_struct
    call fill_window

    mov r0, peter_image
    mov r1, 32
    mov r2, 32
    call set_tilemap

    mov r0, window_struct
    call get_window_overlay_number
    mov r3, r0
    mov r0, 0
    mov r1, 16
    mov r2, 16
    call draw_tile_to_overlay

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
    ifz jmp close_window

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

peter_image:
    #include "peter.inc"

window_title: data.str "Peter" data.8 0
window_struct: data.fill 0, 40
button_widget:
    data.32 0                  ; next_ptr
    data.32 1                  ; id
    data.32 WIDGET_TYPE_BUTTON ; type
    data.32 button_text        ; text_ptr
    data.32 0xFFFFFFFF         ; foreground_color
    data.32 0xFF000000         ; background_color
    data.16 32                 ; width
    data.16 16                 ; height
    data.16 16                 ; x_pos
    data.16 56                 ; y_pos
button_text: data.str "ok" data.8 0

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
