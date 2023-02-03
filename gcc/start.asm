	mov	r1, rv2fox_end
	rjmp	main

rv2fox_end:
	rcall	end_current_task

#include "../../fox32os/fox32os.def"
