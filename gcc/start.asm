	mov	r1, rv2fox_end
	rjmp	main

rv2fox_end:
	rcall	[0x00000A18] ; end_current_task
