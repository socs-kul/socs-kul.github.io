(---
layout: default
title: "Session 2: Assembly basics"
nav_order: 2
nav_exclude: false
search_exclude: false
has_children: false
has_toc: false
---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

# Introduction

## Integers in assembly
In contrast to C, in RISC-V assembly we can only perform arithmetic operations on values stored in registers:
```text
addi t0, zero, 4      # t0 = zero + 4 (zero is a special register containing the value 0)
addi t1, zero, 5      # t1 = zero + 5
addi t2, t0, 3        # t2 = t0 + 3
mul  t2, t2, t1       # t2 = t2 * t1
```

> :pencil: Hashmarks `#` represent line comments in RISC-V assembly, while in C we can use `//` for the same purpose.

> :fire: Warm-up: Try out this example in [RARS](/tutorials/rars)! Check whether you see the correct value in `t2` after executing the program.

# Registers in RISC-V

RISC-V is actually a collection of ISAs, it has different variants
and extensions for different purposes. You can find the descriptions of all base ISA variants and the
extensions in the [RISC-V specification](https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf).

In SOCS, we will use the RV32I (32-bit integer) instruction set. This specifies a total of 32 32-bit
registers and 47 instructions. The instructions are also encoded as 32-bit words.

> :pencil: You might have heard about computers switching from 32-bit instruction sets to 64-bit ones. One important
> reason for this change is that RAM is usually addressed by a value stored in a register. In other
> words, the size of one register limits the size of addressable memory. 32-bit registers can only store
> numbers up to 2^32, which means that you can only address about 4 GB of memory, which is increasingly
> insufficient today.

As mentioned previously, RISC-V instructions perform operations on values stored in registers,
which are located inside the CPU.
All registers `x0-x31` are given a standard name that refers to their conventional usage
(you can use these names when writing RISC-V assembly in RARS). These can be found
[here](https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md#general-registers)
in full. You can also find the short description and names of all registers on the [RISC-V card](/files/riscv-card.pdf).
For example, the first register, `x0`, is referred to as `zero` because reading from it
always returns `0` and writes to it are ignored.

Number | Name | Role
:-----:|:----:|-----
x0 | zero | Always returns 0
x2 | sp | Stack pointer
x5 | t0 | Temporary register 0
... | ... | ...

In theory, the other 31 registers (other than `zero`) could be used for any purpose, but in practice they all have assigned
roles. What does this mean? If all the software on the computer is written by you, you can choose to
use the registers as you please (e.g., storing your first variable in `x1`, the second in `x2`, ...),
as you have complete control over the instructions that are executing.

In most cases, however, the programs you write will have to cooperate with other software:
you will want to use the operating system to write to the console or into files, and you will
want to call functions defined in libraries (e.g., `printf`). This means that your programs will have
to use the registers in a way that's in line with the expectations of other software. This is very
important, for example, when passing arguments to a library function or saving the return value of
that same function call. You also don't want those function calls to overwrite important data that
you store in registers at the time of calling.

The rules for register usage are called *calling conventions*, and we will deal with them in more
detail in [later sessions](/exercises/3-functions-stack#summary-complete-calling-conventions).

## Breakdown of assembly instructions

We have already seen an example of RISC-V assembly:

```text
addi t2, t0, 3        # t2 = t0 + 3
mul  t2, t2, t1       # t2 = t2 * t1
```

We can already deduct some things from these instructions:
1. Instructions always start with the desired operation (`addi`, `mul`) called the **mnemonic**, followed by its **operands**.
2. If there is a destination register (where the result of the operation is written), it is the first parameter of the instruction.
3. The subsequent parameters are used for the operation, and they can be either other registers (`t2`, `t1`) or immediate values (`3`). The `i` at the end of `addi` also refers to this immediate value (adding two register values would use the `add` instruction).

There are four different types of instructions, the two above are called *I-type* (immediate) and *R-type* (register) instructions, respectively.
Later in the course we will see the other two types used for jump and branch instructions.

### Pseudo-instructions

When working with RARS, you might notice that after assembling your code, certain instructions
are assembled into two consecutive machine code instructions, or your instruction is switched out
for another one. This happens when you use *pseudo-instructions*. These instructions are part of the ISA,
but they do not have a machine code representation. Instead, they are implemented using other instructions,
which are automatically substituted by the assembler.

One example is the `mv t0, t1` instruction (copy `t1` into `t0`), which is implemented using the
`addi t0, t1, 0` instruction (adding `0` to the value in `t1` and writing it to `t0`).
You can also see how the `lw` (load word) instruction is translated to two separate instructions at the end of
the [RARS tutorial](/tutorials/rars).

