OKAMERON := ../../okameron/okameron.lua
FOX32ASM := ../../fox32asm/target/release/fox32asm

all: Fox32Demo.fxf

%.fxf: %.asm
	$(FOX32ASM) $< $@

%.asm: %.okm
	lua $(OKAMERON) -arch=fox32 $< > $@
