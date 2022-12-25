# fox32os Demos

 - [allocate](allocate) - memory allocation demo
 - [audio](audio) - audio playback demo
 - [multitasking](multitasking) - multitasking demo
 - [paint](paint) - mouse painting demo
 - [robotfindskitten](robotfindskitten) - a simple remake of the well-known robotfindskitten game
 - [window](window) - window creation demo

## Building

Use **fox32asm** to build a relocatable FXF file, then run it within **fox32os**:  
`fox32asm window.asm window.fxf`  
`fox32 --disk fox32os.img --disk paint.fxf`
