; terminal I/O demo. invoke as:
;
;   1> termio
;   1> termio fox

    pop [stream_ptr]
    pop [arg_0]
    pop [arg_1]
    pop [arg_2]
    pop [arg_3]

    mov r0, hello
    call print

    mov r0, [arg_0]
    cmp r0, 0
    ifz mov r0, world
    call print

    mov r0, end
    call print

    mov r0, press
    call print

key_loop:
    mov r0, 1            ; r0: length
    mov r1, [stream_ptr] ; r1: file pointer
    mov r2, input        ; r2: buffer
    call read
    movz.8 r0, [r2]
    cmp.8 r0, 0
    ifz jmp key_loop

    call end_current_task


input: data.8 0
hello: data.str "hello " data.8 0
world: data.str "world" data.8 0
end: data.str "!" data.8 10 data.8 0
press: data.str "Press any key to exit." data.8 10 data.8 0

print:
    push r0
    push r1
    push r2

    mov r2, r0            ; r2: source buffer
    call string_length    ; r0: length
    mov r1, [stream_ptr]  ; r1: stream pointer
    call write

    pop r2
    pop r1
    pop r0
    ret

stream_ptr: data.32 0
arg_0: data.32 0
arg_1: data.32 0
arg_2: data.32 0
arg_3: data.32 0

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
