; window demo

    mov r0, window_struct
    mov r1, window_title
    mov r2, 256
    mov r3, 256
    mov r4, 64
    mov r5, 64
    mov r6, menu_items_root
    call new_window

event_loop:
    mov r0, window_struct
    call get_next_window_event

    ; did the user click the menu bar?
    cmp r0, EVENT_TYPE_MENU_BAR_CLICK
    ifz mov r0, menu_items_root
    ifz call menu_bar_click_event

    ; is the user in a menu?
    cmp r0, EVENT_TYPE_MENU_UPDATE
    ifz call menu_update_event

    ; did the user click a menu item?
    cmp r0, EVENT_TYPE_MENU_CLICK
    ifz call menu_click_event

    ; did the user click somewhere in the window?
    cmp r0, EVENT_TYPE_MOUSE_CLICK
    ifz call mouse_down

    call yield_task
    rjmp event_loop

clear_window:
    mov r0, 0xFF000000
    mov r1, window_struct
    call fill_window
    ret

mouse_down:
    push r0

    ; first, check if we are attempting to drag or close the window
    cmp r2, 16
    iflteq jmp drag_or_close_window

    ; if not, get the window's overlay and draw a colored square into it
    mov r0, window_struct
    call get_window_overlay_number

    mov r5, r0
    mov r4, r2
    sla r4, 16
    add r4, r1
    or r4, 0xFF000000
    mov r0, r1
    mov r1, r2
    mov r2, 16
    mov r3, 16
    call draw_filled_rectangle_to_overlay

    pop r0
    ret

menu_click_event:
    ; r2 contains the clicked root menu
    ; r3 contains the clicked menu item

    ; window
    cmp r2, 0
    ifz call window_menu_click_event

    ret

window_menu_click_event:
    ; r2 contains the clicked root menu
    ; r3 contains the clicked menu item

    ; clear window
    cmp r3, 0
    ifz call clear_window

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

window_title: data.str "Window Demo" data.8 0
window_struct: data.fill 0, 32

menu_items_root:
    data.8 1                                                      ; number of menus
    data.32 menu_items_window_list data.32 menu_items_window_name ; pointer to menu list, pointer to menu name
menu_items_window_name:
    data.8 6 data.str "Window" data.8 0x00 ; text length, text, null-terminator
menu_items_window_list:
    data.8 1                                      ; number of items
    data.8 14                                     ; menu width (usually longest item + 2)
    data.8 12 data.str "Clear Window" data.8 0x00 ; text length, text, null-terminator

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
