# fox32os Demos

 - [allocate](allocate) - memory allocation demo
 - [audio](audio) - audio playback demo
 - [menu](menu) - menu bar demo
 - [multitasking](multitasking) - multitasking demo
 - [paint](paint) - mouse painting demo

## Building

Use **fox32asm** to build a relocatable FXF file, then run it within **fox32os**:  
`fox32asm paint.asm paint.fxf`  
`fox32 fox32os.img paint.fxf`
