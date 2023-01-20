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

## TODO

- arithmetic tests
  - perform some calculations and check the results
  - check that the flags are set correctly
- decoding edgecases and variations (also test all valid variants)
  - check that sizes are decoded correctly
  - reserved bit is set
  - invalid register number
    - across source/target and all addressing modes
  - target is immediate
  - invalid condition code
  - invalid operation size
  - invalid opcode
- test preservation of upper bits in 8/16 bit operations except MOVZ
- test behavior of different condition codes
- test exceptions
  - page faults
    - across page boundaries
  - divide by zero
  - invalid opcode, invalid opsize
- test MMU page crossing edge cases