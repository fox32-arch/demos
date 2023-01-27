; division-by-zero tests

expect_exception:
	pop	r0
	mov	r0, rsp
	inc	r0
	rta	[r0], exception_good
	reti

exception_good:
	int	1


div0_name: data.str "div by 0" data.8 0
div0_fn:
	rta	[0x400], expect_exception
	mov	r0, 0
	mov	r1, 1
	div	r1, r0
	int	0

idiv0_name: data.str "idiv by 0" data.8 0
idiv0_fn:
	rta	[0x400], expect_exception
	mov	r0, 0
	mov	r1, 1
	idiv	r1, r0
	int	0

rem0_name: data.str "rem by 0" data.8 0
rem0_fn:
	rta	[0x400], expect_exception
	mov	r0, 0
	mov	r1, 1
	rem	r1, r0
	int	0

irem0_name: data.str "irem by 0" data.8 0
irem0_fn:
	rta	[0x400], expect_exception
	mov	r0, 0
	mov	r1, 1
	irem	r1, r0
	int	0

div0_table_name: data.str "division-by-zero tests" data.8 0
div0_table:
	data.32 div0_name  data.32 div0_fn
	data.32 idiv0_name  data.32 idiv0_fn
	data.32 rem0_name  data.32 rem0_fn
	data.32 irem0_name  data.32 irem0_fn
	data.32 0
