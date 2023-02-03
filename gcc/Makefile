FOX32ASM := ../../fox32asm/target/release/fox32asm
RISCVCC := riscv64-linux-gnu-gcc

all: hello.fxf

%.fxf: %.asm
	$(FOX32ASM) $< $@

%.asm: %.s
	./rv2fox $< -o $@

%.s: %.c
	$(RISCVCC) -march=rv32im -mabi=ilp32 -Wall -Os $< -S -o $@
