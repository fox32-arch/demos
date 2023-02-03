; cputest as a raw binary

	; Link at 1 MiB, then copy ourselves there.
	;
	; - When running as ROM, copying into RAM means we can have global variables
	; - When running as disk, copying into RAM is necessary anyway (fox32rom only loads one sector)
	; - When running from a fixed location, we don't have to do any kind of relocations
	org	0x100000

start:
	rta	r0, start

	cmp	r0, 0xf0000000
ifz	rjmp	rom_init
	cmp	r0, 0x800
ifz	rjmp	disk_init
nope:	rjmp	nope


rom_init:
	mov	rsp, 0x100000
	rta	r0, start ; source of copy
	mov	r1, start ; target of copy
	mov	r31, end
	sub	r31, start
  rom_copy_loop:
	mov.8	[r1], [r0]
	inc	r0
	inc	r1
	rloop	rom_copy_loop
	jmp	new_world


disk_init:
	in	r0, 0x80001000  ; determine size of disk
	mov	r31, r0         ; number of blocks
	add	r31, 0x1ff
	srl	r31, 9
	mov	r1, 0           ; current block
	mov	r2, start       ; target address
  disk_loop:
	out	0x80002000, r2  ; set buffer pointer
	out	0x80003000, r1  ; initiate read from block
	inc	r1
	add	r2, 0x200
	rloop	disk_loop
	jmp	new_world

new_world:
	rjmp	main

#include "cputest.asm"
end:
