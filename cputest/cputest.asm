; CPU test

	; Register usage:
	;
	; In main program (cputest.asm):
	; - r0-r7:  temporary values, function call parameters (only valid between function
	;           calls or if you can assure that the called function doesn't trash them)
	; - r8: supertable entry pointer
	; - r9: table entry pointer
	; - r10: fail count
	;
	; Before each test, the registers are initialized to a clean state:
	; - r0-r31 = 0
	; - rsp, resp: in a usable state
	; - flags: zero/carry = 0, swap sp = 1, interrupt enable = 0
	; - MMU disabled
	;
	; Tests are ended through the software interrupt mechanism:
	; - int 0   ; failure
	; - int 1   ; pass

	rjmp	main

;
; Various helper functions
;
putc:
	; r0: character
	mov	r1, 0
	out	r1, r0
	ret

putstr:	; output a NUL-terminated string
	; r0: string pointer
	mov	r2, r0
  putstr_loop:
	mov.8	r0, [r2]
	cmp.8	r0, 0
ifz	ret
	rcall	putc
	inc	r2
	rjmp	putstr_loop


puts:	; output a NUL-terminated string followed by \n
	rcall	putstr
	mov	r0, 0x0a
	rcall	putc
	ret

hexstr:
	data.str "0123456789abcdef"

puthex4:
	and	r0, 0xf
	add	r0, hexstr
	mov	r0, [r0]
	rcall	putc
	ret

puthex8:
	; output a hex number (8 bits)
	mov	r2, r0
	and	r2, 0xff

	mov	r0, r2
	srl	r0, 4	; high 4 bits
	rcall	puthex4

	mov	r0, r2	; low 4 bits
	rcall	puthex4

	ret

puthex16:
	; output a hex number (16 bits)
	mov	r3, r0
	and	r3, 0xffff

	mov	r0, r3
	srl	r0, 8	; high 8 bits
	rcall	puthex8

	mov	r0, r3	; low 8 bits
	rcall	puthex8

	ret

puthex32:
	; output a hex number (32 bits)
	mov	r4, r0

	mov	r0, r4
	srl	r0, 16	; high 16 bits
	rcall	puthex16

	mov	r0, r4	; low 16 bits
	rcall	puthex16

	ret


shutdown:
	mov	r0, 0x80010000
	mov	r1, 0
	out	r0, r1
  shutdown_hang:
	rjmp	shutdown_hang

;
; Tests.
;

example_name: data.str "pass" data.8 0
example_fn:
	int	1

example2_name: data.str "fail" data.8 0
example2_fn:
	int	0


example_table_name: data.str "example tests" data.8 0
example_table:
	; Test table (example).
	data.32 example_name  data.32 example_fn
	;data.32 example2_name  data.32 example2_fn
	data.32 0

#include "div0.asm"

supertable:
	data.32 example_table_name  data.32 example_table
	data.32 div0_table_name  data.32 div0_table
	data.32 0


run_test:
	; run one test.
	; r0: test function pointer

	push	r8   ; save register state
	push	r9
	push	r10
	push	r11
	push	r12
	push	r13
	push	r14
	push	r15
	push	r16
	push	r17
	push	r18
	push	r19
	push	r20
	push	r21
	push	r22
	push	r23
	push	r24
	push	r25
	push	r26
	push	r27
	push	r28
	push	r29
	push	r30
	push	r31
	push	[0x400] ; and exception vectors
	push	[0x404]
	push	[0x408]
	push	[0x40c]
	push	[0x410]

	mov	r1, 0  ; initialize new register state
	mov	r2, r1
	mov	r3, r1
	mov	r4, r1
	mov	r5, r1
	mov	r6, r1
	mov	r7, r1
	mov	r8, r1
	mov	r9, r1
	mov	r10, r1
	mov	r11, r1
	mov	r12, r1
	mov	r13, r1
	mov	r14, r1
	mov	r15, r1
	mov	r16, r1
	mov	r17, r1
	mov	r18, r1
	mov	r19, r1
	mov	r20, r1
	mov	r21, r1
	mov	r22, r1
	mov	r23, r1
	mov	r24, r1
	mov	r25, r1
	mov	r26, r1
	mov	r27, r1
	mov	r28, r1
	mov	r29, r1
	mov	r30, r1
	mov	r31, r1
	rta	[0x400], handle_exception0
	rta	[0x404], handle_exception1
	rta	[0x408], handle_exception2
	rta	[0x40c], handle_exception3
	rta	[0x410], handle_exception4
	rta	[0x000], handle_int
	rta	[0x004], handle_int

	mov	resp, rsp
	mov	r1, rsp
	sub	r1, 16  ; make some space

	push	r1      ; stack pointer
	push	r0      ; instruction pointer
	push.8	0xc     ; flags (swap sp = interrupt = 1)
	mov	r0, r2
	mov	r1, r2
	reti            ; jump!

handle_exception0: mov r12, 0  rjmp handle_exception
handle_exception1: mov r12, 1  rjmp handle_exception
handle_exception2: mov r12, 2  rjmp handle_exception
handle_exception3: mov r12, 3  rjmp handle_exception
handle_exception4: mov r12, 4  rjmp handle_exception

handle_exception:
	pop	r8      ; exception argument
	pop.8	r9      ; flags
	pop	r10     ; instruction pointer
	pop	r11     ; old stack pointer
	rta	r0, badex
	rcall	putstr
	mov	r0, r12
	rcall	puthex4
	rta	r0, badex1
	rcall	putstr
	mov	r0, r10
	rcall	puthex32
	rta	r0, badex2
	rcall	putstr
	mov	r0, r8
	rcall	puthex32
	mov	r0, '.'
	rcall	putc

	mov	r0, 0   ; return failure
	rjmp	run_test_return

badex:	data.str "unhandled exception " data.8 0
badex1:	data.str " in test: IP=" data.8 0
badex2:	data.str ", ARG=" data.8 0


handle_int:
	pop	r0      ; interrupt vector
	pop.8	r1      ; flags
	pop	r2      ; instruction pointer
	pop	r3      ; old stack pointer

run_test_return:
	pop	[0x410] ; restore exception vectors
	pop	[0x40c]
	pop	[0x408]
	pop	[0x404]
	pop	[0x400]
	pop	r31   ; restore previous register state
	pop	r30
	pop	r29
	pop	r28
	pop	r27
	pop	r26
	pop	r25
	pop	r24
	pop	r23
	pop	r22
	pop	r21
	pop	r20
	pop	r19
	pop	r18
	pop	r17
	pop	r16
	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	r11
	pop	r10
	pop	r9
	pop	r8

	ret

running: data.str ">>> Running " data.8 0

run_tests:
	; iterate through all test tables
	rta	r8, supertable
	mov	r10, 0

  run_tests_super_loop:
	mov	r0, [r8]  ; get name
	and	r0, r0
ifz	mov	r0, r10   ; return fail count at end of table
ifz	ret

	rta	r0, running
	rcall	putstr
	mov	r0, [r8]  ; get name
	and	r0, r0
	rcall	puts

	add	r8, 4
	mov	r9, [r8]
	add	r8, 4

	; iterate through all tests within the current table
  run_tests_loop:
	mov	r0, [r9]  ; name
	and	r0, r0
ifz	rjmp	run_tests_super_loop

	rcall	putstr
	rta	r0, dots
	rcall	putstr

	add	r9, 4
	mov	r0, [r9] ; fn
	add	r9, 4

	rcall	run_test

	and	r0, r0
	rta	r0, pass
ifz	rta	r0, fail
ifz	inc	r10       ; count the failure
	rcall	puts
	rjmp	run_tests_loop


dots:	data.str "..." data.8 0
pass:	data.str " PASS" data.8 0
fail:	data.str " FAIL!" data.8 0
hello:	data.8 10 data.str "Welcome to the fox32 CPU test suite!" data.8 10 data.8 0
allpass: data.str "All tests passed." data.8 0
failed:	data.str " tests failed!" data.8 0

silence_interrupts:
	; install interrupt handlers that don't cause memory curruption issues
	mov	r0, 0
  silence_loop:
	rta	[r0], silence
	add	r0, 4
	cmp	r0, 0x400
iflt	rjmp	silence_loop
	ret

silence:
	add	rsp, 4
	reti

main:
	; main entry point
	rta	r0, hello
	rcall	puts
	rcall	silence_interrupts
	rcall	run_tests
	and	r0, r0
ifz	rta	r0, allpass
ifz	rcall	puts
ifnz	rcall	puthex32
ifnz	rta	r0, failed
ifnz	rcall	puts
	rcall	shutdown
