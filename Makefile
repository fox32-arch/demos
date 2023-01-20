FOX32ASM    := ../fox32asm/target/release/fox32asm
FOX32       := ../fox32/fox32
FOX32OS_IMG := ../fox32os/fox32os.img

SRC = \
      demos/hello_world/hello.asm \
      demos/allocate/allocate.asm \
      demos/audio/audio.asm \
      demos/multitasking/multitasking.asm \
      demos/robotfindskitten/main.asm \
      demos/window/window.asm \
      cputest/cputest.asm

FXF = $(subst .asm,.fxf,$(SRC))

all: $(FXF)

%.fxf: %.asm
	$(FOX32ASM) $< $@

# Extra dependencies
demos/robotfindskitten/main.fxf: $(wildcard demos/robotfindskitten/*.asm)
cputest/cputest.fxf: $(wildcard cputest/*.asm)

demos/audio/audio.fxf: demos/audio/audio.raw

demos/audio/audio.raw:
	# create empty dummy file
	touch $@

clean:
	rm -f $(FXF) cputest/cputest.log

.PHONY: clean all cputest/cputest.log

test: cputest/cputest.log
	grep -q "All tests passed" cputest/cputest.log

cputest/cputest.log: cputest/cputest.fxf
	$(FOX32) --headless --disk $(FOX32OS_IMG) --disk cputest/cputest.fxf | tee cputest/cputest.log
