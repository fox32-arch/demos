; condition code tests

; condition code  | z=0, c=0 | z=0, c=1 | z=1, c=0 | z=1, c=1
;-----------------|----------|----------|----------|----------
; always        0 |  yes     |  yes     |  yes     |  yes
; ifz           1 |  no      |  no      |  yes     |  yes
; ifnz          2 |  yes     |  yes     |  no      |  no
; ifc / iflt    3 |  no      |  yes     |  no      |  yes
; ifnc / ifgteq 4 |  yes     |  no      |  yes     |  no
; ifgt          5 |  yes     |  no      |  no      |  no
; iflteq        6 |  no      |  yes     |  yes     |  yes


condasm_name: data.strz "assembly"
condasm_fn:
	; Walk through list of assembled instructions, extract condition code
	; and operand (expected condition code), fail if they differ.
	rta	r8, condasm_list

  condasm_loop:
	movz.16	r9, [r8]  ; control word
	cmp.16	r9, 0
ifz	int	1

	add	r8, 2
	srl	r9, 4     ; condition code
	and	r9, 7
	movz.16	r10, [r8] ; operand
	add	r8, 2

	cmp	r9, r10
ifz	rjmp	condasm_loop

	rta	r0, condasm_exp
	rcall	putstr
	mov	r0, r9
	rcall	puthex4
	rta	r0, condasm_got
	rcall	putstr
	mov	r0, r10
	rcall	puthex4
	int	0

condasm_exp: data.strz "expected condition code "
condasm_got: data.strz ", got "

condasm_list:
	push.16	0
ifz	push.16	1
ifnz	push.16	2
ifc	push.16	3
iflt	push.16	3
ifnc	push.16	4
ifgteq	push.16	4
ifgt	push.16	5
iflteq	push.16	6
	nop.8 ; list terminator


;
; Execution tests
;

set_cond_z0c0:
	mov	r0, 2
	sub	r0, 1
	ret

set_cond_z0c1:
	mov	r0, 1
	sub	r0, 2
	ret

set_cond_z1c0:
	sub	r0, r0
	ret

set_cond_z1c1:
	mov	r0, 1
	sub	r0, 2
	xor	r0, r0
	ret

ifz_name: data.strz "ifz"
ifz_fn:
	rcall	set_cond_z0c0
ifz	int	0

	rcall	set_cond_z0c1
ifz	int	0

	rcall	set_cond_z1c0
ifz	rjmp	ifz_skip
	int	0
  ifz_skip:

	rcall	set_cond_z1c1
ifz	int	1
	int	0

ifnz_name: data.strz "ifnz"
ifnz_fn:
	rcall	set_cond_z0c0
ifnz	rjmp	ifnz_skip1
	int	0
  ifnz_skip1:

	rcall	set_cond_z0c1
ifnz	rjmp	ifnz_skip2
	int	0
  ifnz_skip2:

	rcall	set_cond_z1c0
ifnz	int	0

	rcall	set_cond_z1c1
ifnz	int	0
	int	1

ifc_name: data.strz "ifc"
ifc_fn:
	rcall	set_cond_z0c0
ifc	int	0

	rcall	set_cond_z0c1
ifc	rjmp	ifc_skip1
	int	0
  ifc_skip1:

	rcall	set_cond_z1c0
ifc	int	0

	rcall	set_cond_z1c1
ifc	int	1
	int	0

ifnc_name: data.strz "ifnc"
ifnc_fn:
	rcall	set_cond_z0c0
ifnc	rjmp	ifnc_skip1
	int	0
  ifnc_skip1:

	rcall	set_cond_z0c1
ifnc	int	0

	rcall	set_cond_z1c0
ifnc	rjmp	ifnc_skip2
	int	0
  ifnc_skip2:

	rcall	set_cond_z1c1
ifnc	int	0
	int	1

ifgt_name: data.strz "ifgt"
ifgt_fn:
	rcall	set_cond_z0c0
ifgt	rjmp	ifgt_skip
	int	0
  ifgt_skip:

	rcall	set_cond_z0c1
ifgt	int	0

	rcall	set_cond_z1c0
ifgt	int	0

	rcall	set_cond_z1c1
ifgt	int	0
	int	1

iflteq_name: data.strz "iflteq"
iflteq_fn:
	rcall	set_cond_z0c0
iflteq	int	0

	rcall	set_cond_z0c1
iflteq	rjmp	iflteq_skip1
	int	0
  iflteq_skip1:

	rcall	set_cond_z1c0
iflteq	rjmp	iflteq_skip2
	int	0
  iflteq_skip2:

	rcall	set_cond_z1c1
iflteq	int	1
	int	0


invcond_name: data.strz "invalid condition code"
invcond_fn:
	data.16 0x0000 ; always nop.8
	mov	[0x404], expect_exception ; 404 Instruction Not Found
	data.16 0xf000 ; "never" nop.8
	int	0


cond_table_name: data.strz "condition code tests"
cond_table:
	data.32 condasm_name  data.32 condasm_fn
	data.32 ifz_name  data.32 ifz_fn
	data.32 ifnz_name  data.32 ifnz_fn
	data.32 ifc_name  data.32 ifc_fn
	data.32 ifnc_name  data.32 ifnc_fn
	data.32 ifgt_name  data.32 ifgt_fn
	data.32 iflteq_name  data.32 iflteq_fn
	data.32 invcond_name  data.32 invcond_fn
	data.32 0
