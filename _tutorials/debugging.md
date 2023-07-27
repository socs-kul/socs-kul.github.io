---
layout: default
title: Debugging essentials
nav_order: 3
nav_exclude: false
has_children: false
---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}
# Debugging
Debugging code is an essential skill and thought process. It involves identifying and fixing errors, bugs and unexpected behaviour in code. There are many reasons and ways to debug code, we will mainly focus on using debuggers. Some people like to put print statements in their code to debug which also works from time to time. Usually you use some form of **unit tests** as an indicator for incorrect behaviour in your code. Once the behaviour has been identified you can start using a debugger to figure out why this behaviour is occuring. Obviously, if your program just crashes you know there is a problem somewhere so this could also be an indicator to start debugging.

## Debugging in RARS:
RARS allows you to execute your assembly code step by step, see the red rectangle for the controls. You can walk forwards and backwards. Meanwhile you can also see the current instruction being executed in the green rectangle. In the blue rectangle you can see the registers and the ones that are being changed are indicated with a green background. It is also possible to set a breakpoint (purple arrow) at a certain instruction, this means that the program will pause when it encounters that specific instruction.

Usually you try to look for the exact location where the execution is going wrong, thus isolating the problem. Then you try to reproduce it consistently and understand why it's going wrong. Once that step is done you can fix the problem and afterwards you test to see if the solution is working as intended.

You should also notice in the green square that some instructions we wrote down in our program (source) actually consist of multiple (basic) instructions.

![debugging rars](/tutorials/img/debugging-rars.png)

Please note that debugging is a skill that needs practice to become fluent at it, the best way to learn is through practice. Take a simple program and go through it step by step and try to understand what is happening and why.

There's also built in help available (Top bar: Help -> RARS -> Debugging)

## Debugging C:
We will not dive too deep into debugging C programs. A useful tip is using the compiler itself, it will notify you if it detects an obvious error. This doesn't mean to say that a succesfully compiled program doesn't have any bugs!
### A short example:
```c
#include <stdio.h>

int main(void){
    int x;
    printf("Please enter an integer: \n");
    scanf("%d", x);
    printf("The integer you entered is: %d \n", x);
    return 0;
}
```
If you try to compile this program with the `-Werror` (treat warnings as errors) and `-Wformat` (consider format errors) flags you'll get an error:

![error](/tutorials/img/debugging-gcc-error.png)

This error boils down to the `scanf()` function expecting the address of an integer to store the user's input in. So we need to change that line to `scanf("%d", &x);`. Notice the `&`

## Extra Resources:
If you want to dive deeper in how to debug C programs, GDB is a very capable debugger. Here is a [short introduction video](https://youtu.be/Dq8l1_-QgAc) on the basics of GDB, please notice that when you compile a C program you usually compile it to x86-64 assembly which differs from RISC-V.
