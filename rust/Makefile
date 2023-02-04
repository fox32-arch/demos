FOX32ASM := ../../fox32asm/target/release/fox32asm
CARGO := cargo
RV2FOX := ../../tools/gcc/rv2fox

all: target/riscv32im-unknown-none-elf/release/hello.fxf

target/riscv32im-unknown-none-elf/release/%.fxf: target/riscv32im-unknown-none-elf/release/deps/%.asm
	$(FOX32ASM) $< $@

target/riscv32im-unknown-none-elf/release/deps/%.asm: target/riscv32im-unknown-none-elf/release/deps/%.s
	$(RV2FOX) $< -o $@
	cp src/start.asm target/riscv32im-unknown-none-elf/release/deps/start.asm

target/riscv32im-unknown-none-elf/release/deps/%.s: src/main.rs
	RUSTFLAGS="--emit asm" $(CARGO) build --release --target riscv32im-unknown-none-elf -Zbuild-std=core
	mv target/riscv32im-unknown-none-elf/release/deps/hello-*.s target/riscv32im-unknown-none-elf/release/deps/hello.s
