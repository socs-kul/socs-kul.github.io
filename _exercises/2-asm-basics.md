---
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
After the introductory session to the C programming language, we will now dive into the lower-level assembly code in which the high-level concepts are translated by the compiler. The majority of the sessions will focus on writing assembly programs from scratch. This session is more theoretical and might be a bit overwhelming, but understanding the concepts covered now will be very important for the later sessions. You can also come back here to refresh your knowledge when these concepts come up in later sessions.

If you have any questions or anything is unclear, ask your teaching assistant or reach out to us on the Toledo forums!

# Instruction set architectures (ISAs)

How do we know which instructions we (or the compiler) can use when writing assembly/machine code?
Different processors can execute different instructions. The list of instructions a given CPU can
execute is defined in the instruction set architecture (ISA). This specification includes the list of
possible instructions (and their behavior), but also the list of registers or other hardware features that must be supported
to be able to execute these instructions.

The most widely used ISA today is x86, which is implemented by almost all Intel and AMD processors. x86 is called a
CISC (*complex* instruction set computer) ISA, its specification has evolved over many years and currently includes
thousands of instructions, some of which are very specialized to increase performance (e.g., dedicated
instructions for performing AES encryption).

In this course, we will focus on a RISC (*reduced* instruction set computer) ISA, namely **RISC-V**. RISC ISAs
contain a lot fewer instructions and are easier to write by hand and understand. This does not necessarily mean
worse performance however! Apple's M1 processor also uses a RISC ISA (ARMv8) and outperforms many other
commercial CPUs.

RISC-V is an open standard, both the [specification](https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf) of the ISA and many of the development tools and
reusable components are open-source, which makes using the ISA, experimenting with it, and extending
it easier. These days it is being increasingly used not only in academia, but also in industry.

# RISC-V assembly

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
detail in [later sessions](/exercises/4-functions-stack/#summary-complete-calling-conventions).

# Memory sections in assembly

So far, we have only used registers to store values in assembly. But in many cases, we want to store
values in memory (e.g., if we have more variables than the number of available registers). This is of
course also possible in assembly.

A program is made up of multiple **memory sections**. The C compiler manages this for us transparently,
but when writing assembly, we need to note these explicitly. If you go back to the [first assembly example](https://socs-kul.github.io/exercises/1-c-basics/#compiling-c)
we've seen, you'll see the string `"Hello world"` is stored in `.section .rodata`.

## The `.text` section

In RISC-V assembly, we will make use of two sections. The program code (the instructions) are
stored in the `.text` section. If you only write instructions in RARS, it will automatically put
them in this section, this is why the warm-up program worked as it did. But it's good practice to always define it:

```text
.text
main:
    addi t2, t0, 3
    mul  t2, t2, t1
```

Notice that we've also added `main:` to our program. This is called a **label**, and it can be used to
point to a certain instruction or data in memory. In the x86 example above, you can also find a `main:` label,
but also `.LC0:`, which points to the string literal.

`main:` is a special label, RARS will start execution from here if it can find it. This is useful if you have
a longer file, and you don't necessarily want RARS to start executing from the first line. (This will be useful
for example when you define multiple functions in the same file)(Remember to enable "*Initialize Program Counter to global 'main' if defined*" in the settings of RARS)

To enable external programs to also use these labels, you can use the `.globl` directive. For example,
writing `.globl main` will allow other programs to start executing your program from the `main:` label.
We will always add this directive when working in RARS.

```text
.globl main
.text
main:
    addi t2, t0, 3
```

## The `.data` section

We can store variables in the `.data` section. These will work very similarly to C variables, but there is
a weaker notion of data types in assembly. For integers, we will usually reserve a word (32 bits) of memory,
which corresponds to the size of `int` in C in most cases (an `int` in C does not have a concretely defined
size in the specification).

We also use a label (`a:`) to give a name to our word in memory, otherwise it would be difficult to
refer back to it.

```text
.data
    a: .word 5
.text
    la t0, a       # load address of `a` into `t0`
    lw t1, (t0)    # load value at address `t0` into `t1`
    addi t1, t1, 3
    sw t1, (t0)    # store value from `t1` to address `t0`
```

When reserving a `word`, we can also give it an initial value in memory. In the above example,
we chose to give our variable `a` the initial value 5. In our program, we first load the address
of `a` into `t0` (`la`), then load the word at this address (now contained in `t0`)
into `t1`. After increasing this value by 3, we write it back to the original memory location.

If you want to reserve space in the data section with a byte granularity (not full words),
you can use the `.space N` directive, where `N` is the number of bytes you want to reserve.
For example, you can reserve 4 bytes of space with `empty: .space 4`. In this case,
you can't provide initial values for the memory, you need to store a value to it
from your program explicitly.

In the example above we first loaded the address of `a` into `t0` to then load the value stored at the address of `a` into `t1`. We can also do this in a single step, which gives us the same end result:\
(Under the hood there is a [slight difference](https://stackoverflow.com/a/54011727) but that would take us too far)
```text
.data
    a: .word 5
.text
    lw t1, a
```

To generalize:

Instruction                         | Usage/Meaning
-----------------------------------:|:-------------
la register,symbol                  | Place the address of the symbol into the register (Does **not** perform memory access)
lw register,symbol                  | Place the value of the symbol (So which the address points to) into the register (Does perform memory access)
lb register,symbol                  | The same as lw, but for byte-sized memory accesses
(t0)                                | Dereference a pointer, * operator in C




### Exercise 1

Write a RISC-V program that calculates the following: `c = a^2 + b^2`.
Use the data section to reserve memory for `a`, `b`, and `c`.
Use the debugging features in RARS (memory viewer, register contents) to make sure
that your program works as intended!

{% if site.solutions.show_session_1 %}
#### Solution
```text
{% include_relative 2-asm-basics/sol1.S %}
```
{% endif %}

# Branches

In C, you can create conditional branches and loops like in other languages:

```c
if (a != b) {
    a = b;
} else {
    calculate(a);
}
```

```c
while (a <= b) {
    a++;
}
```

In assembly, constructing these control structures is a bit more tricky. We will
once again need to make use of the labels that were previously introduced.
In the branch and jump instructions we include these labels as jump targets.

```text
loop:
    addi t0, t0, 1
    j loop
```

The above is a simple example of an infinite loop; `j loop` will always jump back
to the instruction following the `loop:` label, so the `t0` register will be incremented
until the heat death of the universe.

This is of course not very useful, so there are many instructions that perform
conditional branching.

```text
    mv t0, zero
    addi t1, zero, 5
loop:
    addi t0, t0, 1
    bne t0, t1, loop
    mul t2, t0, t1
```

In this example, we used the `bne` instruction, which only jumps to the `loop:` label
if the two register operands are not equal. Otherwise, the program continues executing
at the next instruction (`mul`). You can find other useful branching instructions on the
[RISC-V card](/files/riscv-card.pdf).

### Exercise 2

Translate the following program from the [previous session](/exercises/1-c-basics) to RISC-V. The C-program asks the user for a positive integer and iteratively computes the factorial of this integer. You don't have to ask for user input,
store the input integer in the data section.

```c
{% include_relative 1-c-basics/sol3.c %}
```

{% if site.solutions.show_session_1 %}
#### Solution
```text
{% include_relative 2-asm-basics/sol2.S %}
```
{% endif %}

### Exercise 3

Write a RISC-V program that calculates: `c = a^b`.
Make sure that your solution works for all `b >= 0`!

{% if site.solutions.show_session_1 %}
#### Solution
```text
{% include_relative 2-asm-basics/sol3.S %}
```
{% endif %}

