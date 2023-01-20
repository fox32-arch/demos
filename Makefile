FOX32ASM := ../fox32asm/target/release/fox32asm

SRC = \
      demos/allocate/allocate.asm \
      demos/audio/audio.asm \
      demos/multitasking/multitasking.asm \
      demos/robotfindskitten/main.asm \
      demos/window/window.asm

FXF = $(subst .asm,.fxf,$(SRC))

all: $(FXF)

%.fxf: %.asm
	$(FOX32ASM) $< $@

# Extra dependencies
demos/robotfindskitten/main.fxf: $(wildcard demos/robotfindskitten/*.asm)

demos/audio/audio.fxf: demos/audio/audio.raw

demos/audio/audio.raw:
	# create empty dummy file
	touch $@

clean:
	rm -f $(FXF)

.PHONY: clean all
