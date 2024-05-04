; the actual game!!

game_setup:
    ; clear the background
    mov r0, 0xFF000000
    call fill_background

    ; clear the tile array
    call clear_tile_array

    ; set up the version string overlay
    mov r0, 0
    mov r1, 0
    mov r2, 0
    call move_overlay
    mov r0, 320
    mov r1, 16
    mov r2, 0
    call resize_overlay
    mov r0, version_string_overlay_framebuffer
    mov r1, 0
    call set_overlay_framebuffer_pointer
    mov r0, 0
    call enable_overlay
    mov r0, 0xFF000000
    mov r1, 0
    call fill_overlay
    mov r0, version_string
    mov r1, 0
    mov r2, 0
    mov r3, 0xFFFFFFFF
    mov r4, 0x00000000
    mov r5, 0
    call draw_str_to_overlay

    ; set up the nki string overlay
    mov r0, 0
    mov r1, 16
    mov r2, 1
    call move_overlay
    mov r0, 640
    mov r1, 16
    mov r2, 1
    call resize_overlay
    mov r0, nki_string_overlay_framebuffer
    mov r1, 1
    call set_overlay_framebuffer_pointer
    mov r0, 1
    call enable_overlay
    mov r0, 0xFF000000
    mov r1, 1
    call fill_overlay

    ; randomize the robot position
    mov r1, ROBOT_X_MIN
    mov r2, ROBOT_X_MAX
    call random_range
    mov.16 [robot_x], r0
    mov r1, ROBOT_Y_MIN
    mov r2, ROBOT_Y_MAX
    call random_range
    mov.16 [robot_y], r0

    ; set up the robot overlay
    movz.16 r0, [robot_x]
    mul r0, 8
    movz.16 r1, [robot_y]
    add r1, Y_OFFSET
    mul r1, 16
    mov r2, 2
    call move_overlay
    mov r0, 8
    mov r1, 16
    mov r2, 2
    call resize_overlay
    mov r0, robot_overlay_framebuffer
    mov r1, 2
    call set_overlay_framebuffer_pointer
    mov r0, 2
    call enable_overlay
    mov r0, 0xFF000000
    mov r1, 2
    call fill_overlay
    mov r0, '#'
    mov r1, 0
    mov r2, 0
    mov r3, 0xFF000000
    mov r4, 0xFFFFFFFF
    mov r5, 2
    call draw_font_tile_to_overlay

    ; pick a random item ID for the kitten
    ; these IDs are out of the nki range, so there won't be any overlap
    mov r1, 0x00000300
    mov r2, 0x0000FFFF
    call random_range
    mov.16 [kitten_item], r0

    ; randomize the tile array and draw it
    call randomize_tile_array
    call draw_tile_array

game_loop:
    call get_next_event

    cmp r0, EVENT_TYPE_KEY_DOWN
    ifz call key_down_event

    jmp game_loop

; called when the robot finds the kitten :3
; inputs:
; none
; outputs:
; none
found_kitten:
    ; clear the background
    mov r0, 0xFF000000
    call fill_background

    ; clear the nki overlay
    mov r0, 0xFF000000
    mov r1, 1
    call fill_overlay

    ; draw the found kitten string
    mov r0, found_kitten_string
    mov r1, 0
    mov r2, 0
    mov r3, 0xFFFFFFFF
    mov r4, 0xFF000000
    mov r5, 1
    call draw_str_to_overlay

    ; pop the return address off the stack
    pop r0

    ; enter a loop waiting for the player to press a key
found_kitten_loop:
    call get_next_event

    cmp r0, EVENT_TYPE_KEY_DOWN
    ifz jmp found_kitten_key_down_event

    jmp found_kitten_loop
found_kitten_key_down_event:
    cmp r1, 0x15 ; Y key
    ifz jmp game_setup
    cmp r1, 0x31 ; N key
    ifz jmp 0xF0000000

    jmp found_kitten_loop

; called when a key is pressed
; inputs:
; r1: keyboard scancode
; outputs:
; none
key_down_event:
    ; check if the user wants to quit (Q key)
    cmp.8 r1, 0x10
    ifz jmp 0xF0000000

    ; check for arrow keys
    cmp.8 r1, 0x67 ; up
    ifz mov r0, 0
    ifz jmp move_robot
    cmp.8 r1, 0x6C ; down
    ifz mov r0, 1
    ifz jmp move_robot
    cmp.8 r1, 0x69 ; left
    ifz mov r0, 2
    ifz jmp move_robot
    cmp.8 r1, 0x6A ; right
    ifz mov r0, 3
    ifz jmp move_robot

    ret

; move the robot player
; inputs:
; r0: direction (0 = up, 1 = down, 2 = left, 3 = right)
; outputs:
; none
move_robot:
    cmp r0, 0
    ifz jmp move_robot_up
    cmp r0, 1
    ifz jmp move_robot_down
    cmp r0, 2
    ifz jmp move_robot_left
    cmp r0, 3
    ifz jmp move_robot_right
move_robot_overlay:
    movz.16 r0, [robot_x]
    movz.16 r1, [robot_y]
    mul r0, 8
    add r1, Y_OFFSET
    mul r1, 16
    mov r2, 2
    call move_overlay

    ; check if we're on top of the kitten
    movz.16 r0, [robot_x]
    movz.16 r1, [robot_y]
    call get_tile_in_array
    cmp.16 r0, [kitten_item]
    ifz jmp found_kitten

    ; check if we're on top of an item
    movz.16 r0, [robot_x]
    movz.16 r1, [robot_y]
    call get_tile_in_array
    cmp r0, 0
    ifnz call draw_nki_string
    ret
move_robot_up:
    cmp.16 [robot_y], ROBOT_Y_MIN
    ifnz dec.16 [robot_y]
    jmp move_robot_overlay
move_robot_down:
    cmp.16 [robot_y], ROBOT_Y_MAX
    ifnz inc.16 [robot_y]
    jmp move_robot_overlay
move_robot_left:
    cmp.16 [robot_x], ROBOT_X_MIN
    ifnz dec.16 [robot_x]
    jmp move_robot_overlay
move_robot_right:
    cmp.16 [robot_x], ROBOT_X_MAX
    ifnz inc.16 [robot_x]
    jmp move_robot_overlay

; fill the tile array with random items
; inputs:
; none
; outputs:
; none
randomize_tile_array:
    mov r0, tile_array
    mov r31, 15
randomize_tile_array_loop:
    ; set the nki items
    mov r1, 0
    mov r2, TILE_ARRAY_WIDTH
    call random_range
    mov r10, r0
    mov r1, 0
    mov r2, TILE_ARRAY_HEIGHT
    call random_range
    mov r11, r0
    mov r1, 1
    mov r2, NUMBER_OF_NKIS
    call random_range
    mov r2, r0
    mov r0, r10
    mov r1, r11
    call set_tile_in_array
    loop randomize_tile_array_loop

    ; set the kitten item
    mov r1, 0
    mov r2, TILE_ARRAY_WIDTH
    call random_range
    mov r10, r0
    mov r1, 0
    mov r2, TILE_ARRAY_HEIGHT
    call random_range
    mov r1, r0
    mov r0, r10
    movz.16 r2, [kitten_item]
    call set_tile_in_array

    ret

; draw a non-kitten item string
; inputs:
; r0: NKI string number
; outputs:
; none
draw_nki_string:
    mov r10, r0

    ; clear the overlay
    mov r0, 0xFF000000
    mov r1, 1
    call fill_overlay

    ; calculate the pointer to the string
    mov r0, nki_table
    mul r10, 4
    add r0, r10
    mov r0, [r0]

    ; draw the string
    mov r1, 0
    mov r2, 0
    mov r3, 0xFFFFFFFF
    mov r4, 0xFF000000
    mov r5, 1
    call draw_str_to_overlay

    ret

; draw the tile array to the background
; inputs:
; none
; outputs:
; none
draw_tile_array:
    mov r11, TILE_ARRAY_HEIGHT ; y counter
draw_tile_array_y_loop:
    mov r10, TILE_ARRAY_WIDTH ; x counter
draw_tile_array_x_loop:
    mov r0, r10
    mov r1, r11
    call get_tile_in_array

    ; convert to a drawable ascii character
    cmp r0, 93
    ifz inc r0
    rem r0, 93
    cmp r0, 0
    ifz mov r0, ' '
    ifnz add r0, 33

    mov r5, r0

    mov r1, 0xFF050505
    mov r2, 0xFFFFFFFF
    call random_range
    mov r3, r0
    mov r0, r5

    ; draw the tile!!
    mov r1, r10
    mul r1, 8
    mov r2, r11
    add r2, Y_OFFSET
    mul r2, 16
    mov r4, 0xFF000000
    call draw_font_tile_to_background

    dec r10
    ifnz jmp draw_tile_array_x_loop
    dec r11
    ifnz jmp draw_tile_array_y_loop

    mov r0, 0
    mov r1, 26
    call get_tile_in_array

    ret

; set a tile in the tile array
; inputs:
; r0: X position
; r1: Y position
; r2: tile
; outputs:
; none
set_tile_in_array:
    mul r1, TILE_ARRAY_WIDTH
    add r0, r1
    sla r0, 1
    add r0, tile_array
    mov.16 [r0], r2
    ret

; get a tile from the tile array
; inputs:
; r0: X position
; r1: Y position
; outputs:
; r0: tile
get_tile_in_array:
    mul r1, TILE_ARRAY_WIDTH
    add r0, r1
    sla r0, 1
    add r0, tile_array
    movz.16 r0, [r0]
    ret

; clear all tiles in the tile array
; inputs:
; none
; outputs:
; none
clear_tile_array:
    push r0
    push r1
    push r2
    push r31

    mov r0, tile_array
    mov r1, TILE_ARRAY_WIDTH
    mov r2, TILE_ARRAY_HEIGHT
    mul r1, r2
    mov r31, r1
clear_tile_array_loop:
    mov.16 [r0], 0
    add r0, 2
    loop clear_tile_array_loop

    pop r31
    pop r2
    pop r1
    pop r0
    ret

tile_array: data.fill 0, 0x10E0 ; 80x27x2
const TILE_ARRAY_WIDTH: 80
const TILE_ARRAY_HEIGHT: 27

robot_x: data.16 0
const ROBOT_X_MIN: 0
const ROBOT_X_MAX: 79

robot_y: data.16 0
const ROBOT_Y_MIN: 0
const ROBOT_Y_MAX: 26

kitten_item: data.16 0

const Y_OFFSET: 3

version_string_overlay_framebuffer: data.fill 0, 0x5000 ; 320x16x4
nki_string_overlay_framebuffer: data.fill 0, 0xA000 ; 640x16x4
robot_overlay_framebuffer: data.fill 0, 0x0200 ; 8x16x4

found_kitten_string: data.str "You found kitten! Way to go, robot! Play again? (y/n)" data.8 0
