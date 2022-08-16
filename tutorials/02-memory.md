# **Section 2**: Memory

**fox32**'s physical memory is laid out as a flat space spanning from addresses 0x00000000 to 0x03FFFFFF (R/W) and 0xF0000000 to 0xF007FFFF (R/O). Paging can be optionally be enabled. A few things are placed at fixed locations in memory, as shown in the diagram below. The unused portions of memory are free to be used for your own purposes. **fox32os** provides a memory allocator that allows you to dynamically allocate and free memory while your program is running.

```
--------- - 0x00000000
|       | - 0x00000000-0x000007FF - interrupt and exception vectors
|       | - 0x00000800            - fox32os entry point
|       | - 0x00000810            - fox32os routine jump table
|       |
|       |
|       |
|       | - 0x????????-0x01FFF800 - stack (grows downwards!!)
|   R   | - 0x01FFF800-0x01FFFFFF - fox32rom temporary data
|   /   | - 0x02000000-0x0212BFFF - background framebuffer
|   W   | - 0x0212C000-0x0213BFFF - audio buffers 0 & 1
|       | - 0x0214C000-0x0228FFFF - fox32rom temporary data
|       | - 0x02290000-0x0229FFFF - audio buffers 2 & 3
|       |
|       |
|       |
|       |
|       |
--------- - 0x03FFFFFF
/\/\/\/\/
--------- - 0xF0000000            - reset entry point
|       | - 0xF0000000-0xF003FFFF - fox32rom
|       |
|   R   |
|   /   | - 0xF0040000            - fox32rom routine jump table
|   O   |
|       |
|       |
--------- - 0xF007FFFF
```

[< Previous Section](01-introduction.md) | Next Section >
