---
layout: default
title: Installing and using RARS
nav_order: 1
nav_exclude: false
has_children: false
---

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


# Installing and using RARS

[RARS - RISC-V Assembler and Runtime
Simulator](https://github.com/TheThirdOne/rars) is an assembler and simulator
for the RISC-V architecture. It allows you to write, execute and debug the programs that you have written in RISC-V assembly. There are different flavours of assembly, for example the typical AMD/Intel CPUs you are probably most familiar with only understand x86-64 assembly. RISC-V is easier to start off with, since there are less instructions and thus serves as a good foundation for understanding other architectures. The differences between RISC-V and other instruction set architectures (ISAs) will be examined in the theoretical part of SOCS.


## Installation instructions
Make sure you have at least Java 8 installed. 

**On Ubuntu/Mac: (NO WSL)**
```bash
$ java -version
# If this returns something with Java version > 8 or
# openjdk version > 1.8 you have it installed
```

If you do not have it installed, install it using your favourite package manager.\
For Ubuntu:
```bash
$ sudo apt install openjdk-<version>-jdk
# Replace <version> with the version you want
```
For Mac, see [stackoverflow](https://stackoverflow.com/questions/65601196/how-to-brew-install-java):
```bash
$ brew install java
```
Check if the installation was successful by running `java -version`. If so, proceed to the installation of RARS.


**On Windows:**\
If you are running Windows, you should follow these steps:

    1) Download Java: https://java.com/en/download/
    2) Run the installer
    3) Add Java to your PATH environment variables
        (My Computer > Properties > Advanced > Environment Variables > Path)
        (In a Dutch System, Environment Variables is called Omgevingsvariabelen)
        Lots of documentation can be found online on how to do this. One example is https://explainjava.com/java-path/

Check if the installation was successful with `java -version` in a command prompt (Windows key + R, type cmd). If so, proceed to the installation of RARS.

**Installing RARS:**\
Once you have Java installed, download the JAR file of the [last RARS
release](https://github.com/TheThirdOne/rars/releases/tag/continuous).

To execute it, simply run `java -jar rars_xxxxxx.jar` (replace x with the
numbers of your specific file) when your terminal is in the same folder as the
JAR file. Double-clicking the .jar file may also work, depending on how you set up
your system.\
\
![Example on how to run RARS](/tutorials/img/opening-rars.png "Example on how to run RARS")

> :warning: It is **not** necessary to run RARS from inside the **WSL** terminal on Windows. Instead, open it by double-clicking it, or run the `java` command in windows `cmd` shell.


## How to use RARS
1. Write your RISC-V assembly program in the `Edit` window:
   - Define a `.text` section for code with a `main` function,
   - Make your `main` function visible to other files (and to the simulator) with `.globl main`,
   - Don't forget to activate `Settings > "Initialize program counter to global main if defined"`.

   ![A program written in RARS](/tutorials/img/rars_program.png "Example of program written in RARS")

2. Assemble your program:
   - Once your program is ready, you can assemble it using the wrench icon (or `run > Assemble`).
   - Before you can assemble your program, you have to save it!

3. Execute your program from the `Execute` window,
   - Execute the whole program using the first green arrow,
   - Other arrows can be used for single-stepping instructions,
   - Memory and register contents are displayed during and after execution.

The pictures below illustrate the execution of the program defined above. You
may notice that some instructions of your program (in the `Source` column) are
translated to multiple RISC-V instructions (in the `Basic` column). This is
because these source instructions are **pseudo instructions** (basically
syntactic sugar) that are converted to a sequence of RISC-V instructions by the
assembler.

The `Data Segment` window holds the values `2` (corresponding to variable `a`)
at address `0x10010000`, and `3` (corresponding to variable `b`) at addresses
`0x10010000+4`. The prefix `0x` indicates that the following number is given in
hexadecimal. Note that you can change the display of the data segment to decimal
numbers by unchecking the `Hexadecimal Values` box at the bottom of the window.

   ![Example of program ready to execute](/tutorials/img/rars_execute1.png "Example of program ready to execute in RARS")

At the end of the execution, the `Data Segment` window holds the value `9`
(corresponding to `a * b + b`) at address `0x10010000+8`:

   ![Result of the execution of the previous
   program](/tutorials/img/rars_execute_final.png "Result of the execution of
   the previous program")


## FAQ

- **Why can't I click on the wrench icon / why can't I assemble my program?**  
  Make sure that you have saved your program before you try to assemble it.
