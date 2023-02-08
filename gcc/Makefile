FOX32ASM := ../../fox32asm/target/release/fox32asm
RISCVCC := riscv64-linux-gnu-gcc
RV2FOX := ../../tools/gcc/rv2fox

all: hello.fxf

%.fxf: %.asm
	$(FOX32ASM) $< $@

%.asm: %.s
	$(RV2FOX) $< -o $@

%.s: %.c
	$(RISCVCC) -march=rv32im -mabi=ilp32 -Wall -O0 -fno-stack-protector -fno-section-anchors $< -S -o $@
