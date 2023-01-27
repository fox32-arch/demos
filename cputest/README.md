# fox32 CPU test suite

```sh
$ make test
...
Welcome to the fox32 CPU test suite!

>>> Running dummy tests
pass... PASS
All tests passed.
grep -q "All tests passed" cputest/cputest.log
```

`cputest.fxf` can be run under fox32os, `cputest.bin` can be run either as a ROM or as a disk.

## TODO

- arithmetic tests
  - perform some calculations and check the results
  - check that the flags are set correctly
- decoding edgecases and variations (also test all valid variants)
  - invalid register number
    - across source/target and all addressing modes
- test preservation of upper bits in 8/16 bit operations except MOVZ
- test exceptions
  - page faults
    - across page boundaries
  - divide by zero
  - invalid opcode, invalid opsize
- test MMU page crossing edge cases
