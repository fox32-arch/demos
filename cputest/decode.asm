; instruction decoding tests

; To recall, instructions are encoded as:
; - CCCC              a control word (16 bits)
; - SS/SSSS/SSSSSSSS  optionally a source word (8/16/32 bits)
; - TT/TTTT/TTTTTTTT  if there's a source word, optionally a target word (8/16/32 bits)
;
; This means:
; - there are 64k possible control words (though not all are valid)
; - an instruction can be up to 10 bytes long
;
; The control word (in bits):
; zzoooooorcccttss
; ^ ^     ^^  ^ ^- source operand type
; | |     ||  '--- target operand type
; | |     |'------ condition code
; | |     '------- reserved bit (ignored)
; | '------------- opcode
; '--------------- operation size
;
; Although a target type "immediate" doesn't make sense in most cases, the CPU accepts it.


; Control word test. Here, we check for every possible control word, how the
; instruction is decoded. To make the CPU decode an instruction, the execution
; flow must run over it. Fortunately we can decode an instruction without
; running it, by using the condition code:
;
;	or.8	r3, 42  ; sets some bits in r3, and z=0
; ifz	data.16 0xdead  ; decoded but never executed
;
; After the expected length of the instruction, we pad the rest of the code
; buffer with a0 a0 ..., because 0xa0a0 decodes to ifnz brk, i.e. an
; unconditional break, when we know that z=0.

ctrl_predict:
	; predict decoding, return size, or 0 for invalid instructions
	mov	r12, r0   ; source operand type
	and	r12, 3
	mov	r13, r0   ; target operand type
	srl	r13, 2
	and	r13, 3
	mov	r14, r0   ; condition code
	srl	r14, 4
	and	r14, 7
	mov	r15, r0   ; opcode
	srl	r15, 8
	and	r15, 0x3f
	mov	r16, r0   ; operation size
	srl	r16, 14
	and	r16, 3

	rta	r17, ctrl_table
	add	r17, r15
	movz.8	r17, [r17]

	movz.8	r18, r17    ; number of args
	and.8	r18, 0xf0
	srl.8	r18, 4

	cmp.8	r18, 0xf   ; invalid opcode: return 0
ifz	mov	r0, 0
ifz	ret

	xor	r0, r0     ; check if operation size is valid
	bse	r0, r16
	and	r0, r17
ifz	mov	r0, 0
ifz	ret

	mov	r20, 2     ; instruction length

	cmp.8	r18, 1     ; one argument: check src size
iflt	rjmp	ctrl_skip_src
	mov	r0, r12
	mov	r1, r16
	rcall	ctrl_get_operand_size
	add	r20, r0
  ctrl_skip_src:

	cmp.8	r18, 2     ; two arguments: check tgt size
iflt	rjmp	ctrl_skip_tgt
	mov	r0, r13
	mov	r1, r16
	rcall	ctrl_get_operand_size
	add	r20, r0
  ctrl_skip_tgt:

	mov	r0, r20
	ret


ctrl_get_operand_size:
	; r0: operand type
	; r1: operation size (as encoded in the instruction)
	; returns in r0: operand size in bytes
	cmp	r0, 0 ; register
ifz	mov	r2, 1

	cmp	r0, 1 ; register pointer
ifz	mov	r2, 1

	cmp	r0, 2 ; immediate
ifz	rjmp	ctrl_ret_opsize

	cmp	r0, 3 ; immediate pointer
ifz	mov	r2, 4

	mov	r0, r2
	ret

  ctrl_ret_opsize:
	xor	r0, r0
	bse	r0, r1
	ret


ctrl_table:
	;        .------ number of operands (0, 1, 2) or f for invalid opcodes
	;        vv----- valid operation sizes (bitmask)
	data.8 0x07  ; 0x00: NOP
	data.8 0x27  ; 0x01: ADD
	data.8 0x27  ; 0x02: MUL
	data.8 0x27  ; 0x03: AND
	data.8 0x27  ; 0x04: SLA
	data.8 0x27  ; 0x05: SRA
	data.8 0x27  ; 0x06: BSE
	data.8 0x27  ; 0x07: CMP

	data.8 0x14  ; 0x08: JMP
	data.8 0x14  ; 0x09: RJMP
	data.8 0x17  ; 0x0A: PUSH
	data.8 0x24  ; 0x0B: IN
	data.8 0x04  ; 0x0C: ISE
	data.8 0x04  ; 0x0D: MSE
	data.8 0xf4  ; 0x0E: ---
	data.8 0xf4  ; 0x0F: ---

	data.8 0x07  ; 0x10: HALT
	data.8 0x17  ; 0x11: INC
	data.8 0xf4  ; 0x12: ---
	data.8 0x27  ; 0x13: OR
	data.8 0x27  ; 0x14: IMUL
	data.8 0x27  ; 0x15: SRL
	data.8 0x27  ; 0x16: BCL
	data.8 0x27  ; 0x17: MOV

	data.8 0x14  ; 0x18: CALL
	data.8 0x14  ; 0x19: RCALL
	data.8 0x17  ; 0x1A: POP
	data.8 0x24  ; 0x1B: OUT
	data.8 0x04  ; 0x1C: ICL
	data.8 0x04  ; 0x1D: MCL
	data.8 0xf4  ; 0x1E: ---
	data.8 0xf4  ; 0x1F: ---

	data.8 0x07  ; 0x20: BRK
	data.8 0x27  ; 0x21: SUB
	data.8 0x27  ; 0x22: DIV
	data.8 0x27  ; 0x23: XOR
	data.8 0x27  ; 0x24: ROL
	data.8 0x27  ; 0x25: ROR
	data.8 0x27  ; 0x26: BTS
	data.8 0x27  ; 0x27: MOVZ

	data.8 0x14  ; 0x28: LOOP
	data.8 0x14  ; 0x29: RLOOP
	data.8 0x04  ; 0x2A: RET
	data.8 0xf4  ; 0x2B: ---
	data.8 0x14  ; 0x2C: INT
	data.8 0x14  ; 0x2D: TLB
	data.8 0xf4  ; 0x2E: ---
	data.8 0xf4  ; 0x2F: ---

	data.8 0xf4  ; 0x30: ---
	data.8 0x17  ; 0x31: DEC
	data.8 0x27  ; 0x32: REM
	data.8 0x17  ; 0x33: NOT
	data.8 0x27  ; 0x34: IDIV
	data.8 0x27  ; 0x35: IREM
	data.8 0xf4  ; 0x36: ---
	data.8 0xf4  ; 0x37: ---

	data.8 0xf4  ; 0x38: ---
	data.8 0x24  ; 0x39: RTA
	data.8 0x04  ; 0x3A: RETI
	data.8 0xf4  ; 0x3B: ---
	data.8 0xf4  ; 0x3C: ---
	data.8 0x14  ; 0x3D: FLP
	data.8 0xf4  ; 0x3E: ---
	data.8 0xf4  ; 0x3F: ---

ctrl_code_buf: data.fill 0, 16
ctrl_name: data.str "control word" data.8 0
ctrl_fn:
	; iterate over all 64k possible control words
	mov	r8, 0    ; control word
	mov	r9, 0    ; failure count
  ctrl_loop:
	mov	r0, r8
	and.8	r0, 0x70
	cmp.8	r0, 0x10  ; if condition code isn't ifz
ifnz	rjmp	ctrl_next ; ... then skip to the next control word

  ctrl_build:
	mov	r0, r8
	rcall	ctrl_predict
	mov	r11, r0   ; save predicted length for later

	; write padding into buffer
	mov	r0, 0
	mov	r1, 16
	rta	r2, ctrl_code_buf
  ctrl_pad_loop:
	cmp	r0, r11
	mov.8	[r2], 0xa0 ; outsize the instruction pad with a0
iflt	mov.8	[r2], 0    ;  inside the instruction pad with 00
	inc	r2
	inc	r0
	cmp	r0, r1
iflt	rjmp	ctrl_pad_loop

	; write control word
	rta	r0, ctrl_code_buf
	mov.16	[r0], r8

	rta	[0x404], ctrl_invalid
	rta	[0x410], ctrl_brk

	or.8	r1, 1      ; set z=0
	jmp	r0         ; and go!

  ctrl_brk:
	pop	r0
	mov	r1, rsp
	inc	r1
	mov	r10, [r1]
	rta	[r1], ctrl_check
	sub	r10, 2
	reti

  ctrl_invalid:
	pop	r0
	mov	r1, rsp
	inc	r1
	mov	r10, [r1]
	rta	[r1], ctrl_check
	reti

  ctrl_check:
	sub	r10, ctrl_code_buf
	cmp	r10, r11
ifz	rjmp	ctrl_next

  ctrl_bad:
	inc	r9
	rta	r0, ctrl_mismatch
	rcall	putstr
	mov	r0, r8
	rcall	puthex16
	rta	r0, ctrl_expected
	rcall	putstr
	mov	r0, r11
	rcall	puthex4
	rta	r0, ctrl_actual
	rcall	putstr
	mov	r0, r10
	rcall	puthex4
	rta	r0, ctrl_dot
	rcall	puts

  ctrl_next:
	inc	r8
	cmp	r8, 0x10000
ifz	rjmp	ctrl_end
	rjmp	ctrl_loop

  ctrl_end:
	and	r9, r9
ifz	int	1
	int	0

ctrl_mismatch: data.str "Mismatch with control word " data.8 0
ctrl_expected: data.str ". Expected length " data.8 0
ctrl_actual:   data.str ". Actual length " data.8 0
ctrl_dot:      data.str "." data.8 0


regnum_name: data.strz "Register numbers"
regnum_fn:
	xor	r0, r0
	data.16 0x8100 data.8 0 data.8    0 ; add r0,   r0
	data.16 0x8100 data.8 0 data.8 0x20 ; add rsp,  r0
	data.16 0x8100 data.8 0 data.8 0x21 ; add resp, r0
	data.16 0x8100 data.8 0 data.8 0x22 ; add rfp,  r0
	mov	[0x404], expect_exception
	data.16 0x8100 data.8 0 data.8 0x23 ; invalid
	int	0

incimm_name: data.strz "inc immediate"
incimm_fn:
	; the `inc` instruction reads and writes its source operand, so `inc 42` is not allowed.
	inc	[incimm_buf]
	mov	[0x404], expect_exception
	inc	42
	int	0
incimm_buf: data.32 42

outimm_name: data.strz "out immediate"
outimm_fn:
	; the `out` instruction is special in that it allows an immediate as target operand
	mov	r0, 0
	out	r0, 0xf0
	mov	r1, 0x9f
	out	r0, r1
	data.16 0x9b02 data.32 0xa6 data.8 0  ; out r0, 0xa6
	data.16 0x9b0a data.32 0x8a data.32 0 ; out  0, 0x8a
	int	1

decode_table_name: data.str "instruction decoding tests" data.8 0
decode_table:
	data.32 ctrl_name  data.32 ctrl_fn
	data.32 regnum_name  data.32 regnum_fn
	data.32 incimm_name  data.32 incimm_fn
	data.32 outimm_name  data.32 outimm_fn
	data.32 0
