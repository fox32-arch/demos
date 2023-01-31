; Memory tests (with and without MMU)

nommu_read1_name: data.strz "No MMU, read, just before RAM end"
nommu_read1_fn:
	mov	r0, [0x3fffffc]
	mov.8	r0, [0x3ffffff]
	mov.16	r0, [0x3fffffe]
	rta	[0x408], expect_exception
	mov	r0, [0x3fffffd]
	int	0

nommu_read2_name: data.strz "No MMU, read, just after RAM end"
nommu_read2_fn:
	rta	[0x408], expect_exception
	mov	r0, [0x4000000]
	int	0

nommu_read3_name: data.strz "No MMU, read, ROM"
nommu_read3_fn:
	mov	r0, [0xf0000000]
	int	1

nommu_read4_name: data.strz "No MMU, read, ROM end"
nommu_read4_fn:
	mov.8	r0, [0xf007ffff]
	mov.16	r0, [0xf007fffe]
	mov	r0, [0xf007fffc]
	rta	[0x408], expect_exception
	mov	r0, [0xf007fffd]
	int	1

nommu_fetch_name: data.strz "No MMU, jump past RAM"
nommu_fetch_fn:
	rta	[0x408], expect_exception
	jmp	0x4000000
	int	0

nommu_write1_name: data.strz "No MMU, write, just before RAM end"
nommu_write1_fn:
	mov	[0x3fffffc], 0
	mov.8	[0x3ffffff], 0
	mov.16	[0x3fffffe], 0
	rta	[0x40c], expect_exception
	mov	[0x3fffffd], 0
	int	0

nommu_write2_name: data.strz "No MMU, write, just after RAM end"
nommu_write2_fn:
	rta	[0x40c], expect_exception
	mov	[0x4000000], 0
	int	0

nommu_write3_name: data.strz "No MMU, write, ROM"
nommu_write3_fn:
	rta	[0x40c], expect_exception
	mov	[0xf0000000], 0
	int	0


; TODO:
; - "allocate" some memory somewhere
; - read / write page faults
;   - page directory missing
;   - page missing
;   - page access bits forbid access
; - overhang
;   - various operations:
;     - instruction fetch
;     - load/store
;   - between two valid pages
;   - from valid to invalid


mem_table_name: data.strz "Memory tests"
mem_table:
	data.32 nommu_read1_name  data.32 nommu_read1_fn
	data.32 nommu_read2_name  data.32 nommu_read2_fn
	data.32 nommu_read3_name  data.32 nommu_read3_fn
	data.32 nommu_read4_name  data.32 nommu_read4_fn
	data.32 nommu_fetch_name  data.32 nommu_fetch_fn
	data.32 nommu_write1_name  data.32 nommu_write1_fn
	data.32 nommu_write2_name  data.32 nommu_write2_fn
	data.32 0
