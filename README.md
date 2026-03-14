# Trigonometry functions in ASM

This is a small project that follows _Assembly Language for X86 Processors_ by
Kip R. Irvine.

## Building

Disclaimer: I have only tested this on Ubuntu 22.04.5 LTS x86_64 with an Intel
i5-4570R CPU.

### 1. Download UASM

You can download it from the [UASM webpage](https://www.terraspace.co.uk/uasm.html).

### 2. Download and Compile IrvingT

[IrvingT](https://github.com/ObjectBoxPC/irvingt) is a clone of the Irvine32
library for Unix-like systems. It is highly recommended that you read their [puzzle
document](https://github.com/ObjectBoxPC/irvingt/blob/develop/doc/puzzle.md).

The `irvingt` directory should be placed in this project's root directory so
that the [Makefile](/Makefile) can link against the generated library.

**Note**: Some slight modifications are needed to implement functions such as
`WriteFloat`. I may or may not submit a PR for that, but it's relatively easy to
write your own implementation.

To compile IrvingT, run `make` inside the `irvingt` directory:
```sh
cd irvingt
make
```

You should get a static library called `irvingt.a`.

### 3. Download and change the Irvine32 Include Files

Download and extract the [Irvine32 library
files](https://github.com/surferkip/asmbook). Ideally, place them in this
project's root directory.

In the `SmallWin.inc` file provided with Irvine32, change the line:
```asm
.MODEL flat, stdcall
```
to:
```asm
.MODEL flat, c
```

### 4. Assemble and link

Simply run `make`, and you should obtain an executable called `asm-trig`.
