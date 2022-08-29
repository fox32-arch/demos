; menu bar demo

    call enable_menu_bar
    call clear_menu_bar
    mov r0, menu_items_root
    mov r1, 0xFFFFFFFF
    call draw_menu_bar_root_items

    ; set properties of overlay 0
    mov r0, 16
    mov r1, 32
    mov r2, 0
    call move_overlay
    mov r0, 512
    mov r1, 16
    mov r2, 0
    call resize_overlay
    mov r0, overlay_framebuffer
    mov r1, 0
    call set_overlay_framebuffer_pointer

    ; enable overlay 0
    mov r0, 0
    call enable_overlay

event_loop:
    call get_next_event

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

    call yield_task
    jmp event_loop

menu_click_event:
    ; r2 contains the clicked root menu
    ; r3 contains the clicked menu item

    ; system
    cmp r2, 0
    ifz call system_menu_click_event

    ; background
    cmp r2, 1
    ifz call background_menu_click_event

    ; text
    cmp r2, 2
    ifz call text_menu_click_event

    ret

system_menu_click_event:
    ; r2 contains the clicked root menu
    ; r3 contains the clicked menu item

    ; end task
    cmp r3, 0
    call end_current_task

    ; shut down
    cmp r3, 1
    ifz icl
    ifz halt

    ret

background_menu_click_event:
    ; r2 contains the clicked root menu
    ; r3 contains the clicked menu item

    ; fox
    cmp r3, 0
    ifz mov r0, fox_image
    ifz call draw_background

    ; sable
    cmp r3, 1
    ifz mov r0, sable_image
    ifz call draw_background

    ret

text_menu_click_event:
    ; r2 contains the clicked root menu
    ; r3 contains the clicked menu item

    ; hello world
    cmp r3, 0
    ifz mov r0, hello_string
    ifz call draw_text

    ; fox32 demo
    cmp r3, 1
    ifz mov r0, demo_string
    ifz call draw_text

    ; about fox32
    cmp r3, 2
    ifz mov r0, about_string
    ifz call draw_text

    ret

draw_background:
    mov r1, 0x02000000
    mov r31, 0x0004B000 ; 640*480
draw_background_loop:
    mov [r1], [r0]
    add r0, 4
    add r1, 4
    loop draw_background_loop

    ret

draw_text:
    push r0
    mov r0, 0x00000000
    mov r1, 0
    call fill_overlay
    pop r0

    mov r1, 0
    mov r2, 0
    mov r3, 0xFFFFFFFF
    mov r4, 0xFF000000
    call draw_str_to_overlay

    ret

hello_string: data.str "Hello world!!" data.8 0x00
demo_string: data.str "This is a demo of fox32's menu system!!" data.8 0x00
about_string: data.str "fox32 is an open source low level fantasy computer" data.8 0x00

menu_items_root:
    data.8 3                                                              ; number of menus
    data.32 menu_items_system_list data.32 menu_items_system_name         ; pointer to menu list, pointer to menu name
    data.32 menu_items_background_list data.32 menu_items_background_name ; pointer to menu list, pointer to menu name
    data.32 menu_items_text_list data.32 menu_items_text_name             ; pointer to menu list, pointer to menu name
menu_items_system_name:
    data.8 6  data.str "System"     data.8 0x00 ; text length, text, null-terminator
menu_items_background_name:
    data.8 10 data.str "Background" data.8 0x00 ; text length, text, null-terminator
menu_items_text_name:
    data.8 10 data.str "Text"       data.8 0x00 ; text length, text, null-terminator
menu_items_system_list:
    data.8 2                                     ; number of items
    data.8 11                                    ; menu width (usually longest item + 2)
    data.8 8  data.str "End Task"  data.8 0x00   ; text length, text, null-terminator
    data.8 9  data.str "Shut Down" data.8 0x00   ; text length, text, null-terminator
menu_items_background_list:
    data.8 2                                     ; number of items
    data.8 7                                     ; menu width (usually longest item + 2)
    data.8 3  data.str "Fox"   data.8 0x00       ; text length, text, null-terminator
    data.8 5  data.str "Sable" data.8 0x00       ; text length, text, null-terminator
menu_items_text_list:
    data.8 3                                     ; number of items
    data.8 13                                    ; menu width (usually longest item + 2)
    data.8 11 data.str "Hello World" data.8 0x00 ; text length, text, null-terminator
    data.8 10 data.str "fox32 Demo"  data.8 0x00 ; text length, text, null-terminator
    data.8 11 data.str "About fox32" data.8 0x00 ; text length, text, null-terminator

fox_image:
    #include_bin "fox.raw"

sable_image:
    #include_bin "sable.raw"

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"

overlay_framebuffer: data.fill 0, 0x8000 ; 512x16x4
