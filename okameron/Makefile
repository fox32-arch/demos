VOS := ../../okameron/okameron.lua
FOX32ASM := ../../fox32asm/target/release/fox32asm

build:
	lua $(VOS) -arch=fox32 Fox32Demo.okm > out.asm
	$(FOX32ASM) out.asm OkameronDemo.fxf
	# rm out.asm