; splash screen routines

splash_setup:
    ; disable the overlays used during the game and clear the background
    mov r0, 0
    call disable_overlay
    mov r0, 1
    call disable_overlay
    mov r0, 2
    call disable_overlay
    mov r0, 0xFF000000
    call fill_background

    ; draw the splash strings
    mov r0, version_string
    mov r1, 16
    mov r2, 16
    mov r3, 0xFFFFFFFF
    mov r4, 0x00000000
    call draw_str_to_background
    mov r0, credits_string_1
    mov r1, 16
    add r2, 32
    call draw_str_to_background
    mov r0, credits_string_2
    mov r1, 16
    add r2, 16
    call draw_str_to_background
    mov r0, credits_string_3
    mov r1, 16
    add r2, 32
    call draw_str_to_background
    mov r0, instructions_string_1
    mov r1, 16
    add r2, 32
    call draw_str_to_background
    mov r0, instructions_string_2
    mov r1, 16
    add r2, 16
    call draw_str_to_background
    mov r0, instructions_string_3
    mov r1, 16
    add r2, 16
    call draw_str_to_background
    mov r0, instructions_string_4
    mov r1, 16
    add r2, 16
    call draw_str_to_background
    mov r0, instructions_string_5
    mov r1, 16
    add r2, 16
    call draw_str_to_background
    mov r0, instructions_string_6
    mov r1, 16
    add r2, 32
    call draw_str_to_background
    mov r0, instructions_string_7
    mov r1, 16
    add r2, 32
    call draw_str_to_background

    ; fall-through to splash_loop

splash_loop:
    call get_next_event

    cmp r0, EVENT_TYPE_KEY_DOWN
    ifz jmp game_setup

    call yield_task
    jmp splash_loop

version_string:        data.str "robotfindskitten v2.7182818.701/fox32"                                      data.8 0
credits_string_1:      data.str "By the illustrious Leonard Richardson (C) 1997, 2000"                       data.8 0
credits_string_2:      data.str "Written originally for the Nerth Pork robotfindskitten contest"             data.8 0
credits_string_3:      data.str "fox32 rewrite by Ry - 2022"                                                 data.8 0
instructions_string_1: data.str "In this game, you are robot (#). Your job is to find kitten. This task"     data.8 0
instructions_string_2: data.str "is complicated by the existence of various things which are not kitten."    data.8 0
instructions_string_3: data.str "Robot must touch items to determine if they are kitten or not. The game"    data.8 0
instructions_string_4: data.str "ends when robotfindskitten. Alternatively, you may end the game by hitting" data.8 0
instructions_string_5: data.str "the Q key."                                                                 data.8 0
instructions_string_6: data.str "See the documentation for more information."                                data.8 0
instructions_string_7: data.str "Press any key to start."                                                    data.8 0
