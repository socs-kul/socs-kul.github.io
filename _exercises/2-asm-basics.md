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

