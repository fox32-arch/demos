OKAMERON := ../../okameron/okameron.lua
FOX32ASM := ../../fox32asm/target/release/fox32asm

all: TermOkm.fxf

%.fxf: %.asm
	$(FOX32ASM) $< $@

%.asm: %.okm
	lua $(OKAMERON) -arch=fox32 -startup=start.asm $< OS.okm > $@
