# **Section 1**: Introduction

**fox32** is a fantasy computer made up of a few different components:
 - The virtual machine and architecture itself is called **fox32**. It's what everything runs on top of.
 - The boot ROM is called **fox32rom**. It contains a bunch of useful routines that can be used for your own purposes. Think of it as something similar to Apple's Macintosh Toolbox ROM.
 - The operating system is called **fox32os**. It runs on top of fox32rom and allows the use of relocatable FXF binaries, cooperative multitasking, and filesystem access. This is what your programs will run on top of.

Programs are written in a custom assembly language, with mnemonics inspired by x86 and Z80. Here's a little example which draws "hello world" at position 16x16:
```
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

    #include "fox32rom.def"
    #include "fox32os.def"
```

Let's go over this!
 - `mov r0, string` - Copy the address of `string` into register `r0`
 - `call draw_str_to_background` - Call the **fox32rom** routine which draws a string to the background (more on this later)
 - `yield_loop:` - Define a new label called `yield_loop`
 - `call yield_task` - Call the **fox32os** routine which switches to the next task (more on this later)
 - `rjmp yield_loop` - Relative-jump to the `yield_loop` label defined earlier
 - `data.str ...` - Define an ASCII string
 - `data.8 ...` - Define a single byte (used here as the null-terminator for the string)
 - `#include "fox32rom.def"` - Include the **fox32rom** definition file
 - `#include "fox32os.def"` - Include the **fox32os** definition file
