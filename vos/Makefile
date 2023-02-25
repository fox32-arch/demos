VOS := ../../vosLang/src/vos.lua
FOX32ASM := ../../fox32asm/target/release/fox32asm

build:
	lua $(VOS) -arch=fox32 hello.vos hello_vos.asm
	$(FOX32ASM) hello_vos.asm hello.fxf
	# rm hello_vos.asm