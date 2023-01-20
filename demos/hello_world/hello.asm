; text drawing demo

    mov r0, string     ; pointer to string
    mov r1, 16         ; X pos
    mov r2, 16         ; Y pos
    mov r3, 0xFFFFFFFF ; foreground color
    mov r4, 0x00000000 ; background color
    call draw_str_to_background

yield_loop:
    call yield_task
    rjmp yield_loop

string: data.str "hello world!" data.8 0

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
