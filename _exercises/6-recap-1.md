---
layout: default
title: "Session 6: Recap session 1"
nav_order: 6
nav_exclude: false
search_exclude: false
has_children: false
has_toc: false
---

# Preparing for Test 1

## Information

The first test will take place on **November 3rd**. It serves to examine your understanding of all the material we have seen up until this point. This includes:

| Session 1 | Introduction to C |
| Session 2 | Assembly basics |
| Session 3 | Advanced C & assembly |
| Session 4 | Functions and the stack |
| Session 5 | Dynamic memory |

The first and second test contribute equally to your final grade for the exercises portion of SOCS. Refer to the [ECTS course description](https://onderwijsaanbod.kuleuven.be/syllabi/n/G0Q33CN.htm#activetab=doelstellingen_idp994368) for more information about how this course is graded.

The difficulty of the test will not be greater than the more difficult exercises from the exercise sessions. The test will take place on a computer, with a duration of 2 hours. You can access RARS, but you will not have internet access.

## Structure of this test

Test 1 will consist of two questions:

**Question 1**: A question where you have to write RISC-V assembly. You will receive a description of a program, which you will have to implement. We will check that your implementation gives the correct results and that you have respected the RISC-V calling conventions (see session 4). Try to create your own unit tests to check your implementation. This question should take _at most 40 minutes_.

**Question 2**: In this question you will be given a program description and an implementation in C. You have to translate this C code into RISC-V assembly. This question is usually a little harder than the first one. It should take _at most 1 hour_.

## Practice exam

To help you prepare for the first test, we have provided a practice exam. The format, difficulty and duration of the practice test are very similar to those of the real test, but the questions will obviously be different.

> :pencil: **Question 1**: Given a sorted array, the length of the array and a target value. If the target value is in the array,
> return its index. If it is not in the array, return the index where it should be inserted.
>
> Respect the RISC-V calling conventions. Do not make use of a custom exception handler (it will interfere with the test-suite). Try to write unit tests to test the validity of your implementation. Make sure to think about edge cases. Use .globl findIndex as the function name. Do not forget to ‘ret’ at the end of your function!
>
> Inputs (you can assume that these are given): a0 = array; a1=length; a2=target.
>
> _Examples_:
>
> array = [1 3 5 7 9]
> target = 1
> -> return 0
>
> array = [1 3 5 7 9]
> target = 6
> -> return 3

> :pencil: **Question 2**: Determine if a word or phrase is an isogram.
> An isogram (also known as a "non-pattern word") is a word or phrase without a repeating letter.
>
> Examples of isograms:
>
> _lumberjacks_
>
> _background_
>
> _downstream_
>
> Create a RISC-V program that checks whether a given input string (given in register a0) is an isogram.
> An implementation in C is given below to help you solve this problem. Instead of printing the result,
> you should return 1 if the input string is an isogram, 0 if it isn’t.
> You can assume that the input strings only contain characters from the alphabet, so no hyphens, spaces… All input characters
> are lowercase. No input validation is needed.
>
> The C code is given below:

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int is_isogram(const char *str) {
	int char_count[26] = {0}; // Assuming only lowercase letters are considered

	for (int i = 0; str[i] != '\0'; i++) {
    	char c = tolower(str[i]);

    	if (isalpha(c)) {
        	int index = c - 'a';
        	if (char_count[index] > 0) {
            	return 0; // Not an isogram
        	}
        	char_count[index]++;
    	}
	}

	return 1; // Isogram
}

int main() {
	char input[1000];
	printf("Enter a string: ");
	fgets(input, sizeof(input), stdin);

	// Remove the newline character from fgets
	input[strcspn(input, "\n")] = '\0';

	if (is_isogram(input)) {
    	printf("The string is an isogram.\n");
	} else {
    	printf("The string is not an isogram.\n");
	}

	return 0;
}
```

Aside from attempting the practice exam, you should redo as many exercises from the previous sessions as possible. These materials will be sufficient for you to pass the test with flying colors. The additional exercises from session 3 are especially recommended. Try to apply your knowledge from session 4 and 5 to those questions if you want to be fully prepared for the exam.

> :bulb: Tip: Don't neglect the theoretical aspects of this course!
> Having a solid grasp of the theory will make it a lot easier for you to
> (re)do the exercises and complete the practice exam.

## Writing unit tests

To test the validity of your implementation, it is useful to write simple unit tests and test your program for different cases. To do this, you open a new file and make sure your testfile is in the same directory as your implementation or you assemble all the currently open files by going to `Settings` and selecting the box `Assemble all files currently open`. You then load the necessary input for your implementation into the correct registers and run your implementation with a _jump-and-link instruction_. To check if the return value is correct, you can simply put the correct value in a register and check if it matches the return value with a _Branch if equal instruction_. If the value is correct, load a certain value in a register and another value if it is wrong.

A simple unit test for question 1 above could for example be:

```text
.globl main
.data
    array: .space 12


.text
main:
    # Making an array [1,2,3] pointed to by a0
    la   a0, array
    li   t0, 1
    li   t1, 2
    li   t2, 3
    sw   t0, 0(a0)
    sw   t1, 4(a0)
    sw   t2, 8(a0)


    # Load the other input into the correct registers
    li   a1, 3     # a1 = length of the array
    li   a2, 2     # a2 = target value

    # Run your implementation
    jal findIndex

    # Load the expected value into a register (in this case the expected index is 1)
    li   t3, 1

    # Check if the returned value matches the expected value
    beq   a0, t3, test_success
    bne   a0, t3, test_fail


test_success:
    li t4, 1   # If success, load 1 into t4
    j end

test_fail:
    li t4, -1  # If failed, load -1 into t4

end:
    li a7, 93 # Exit system call ends program
    ecall
```

After you run the test, register t4 will contain the value 1 if the test was a succes and -1 if the test failed.

## Recursion

What happens when a function calls itself? Functions that depend on a simpler or previous version of themselves are called recursive functions. This also means we have to be very careful when considering the calling convetions mentioned before.

### Exercise Recursion

Consider the following recursive function which calculates `n!`.

```c
{% include_relative 4-functions-stack/ex5.c %}
```

1. Convert this function to RISC-V.
1. Consider the call `fact(3)`. What is the state of stack when it reaches its maximum size (at the deepest level of recursion)?
1. In [exercise 3 of the first session](/exercises/1-c-basics/#exercise-3) you implemented an iterative factorial function. Compare both factorial implementations in terms of memory usage. Which implementation do you prefer?

{% if site.solutions.show_session_6 %}

#### Solution

```text
{% include_relative 4-functions-stack/sol5.asm %}
```

{% endif %}

### Excursion: Tail recursion

A [_tail call_](https://en.wikipedia.org/wiki/Tail_call) occurs whenever the **last** instruction of a subroutine (before the return) calls a different subroutine.
Compilers can take advantage of tail calls to reduce memory usage. This is because for tail calls, no additional stack frame needs to be entered. Instead, we can simply overwrite the function parameters, jump to the function and execute from there by reusing the original function stack frame.
This is possible since we do not expect to be returned to and instead refer to our original caller that is on our stack frame. Thus, when the (tail-) called function returns, it will not return to us but directly to the original code that called us.

The benefit of tail calls is that they are very light on stack usage. While non-tail recursion adds a stack frame for each recursion depth, tail recursion only uses a single stack frame for any recursion depth.

> :bulb: The call `fact(n-1)` in the previous exercise is **not** a tail call. Why not?

<details closed markdown="block">
  <summary>
    Solution
  </summary>
  {: .text-gamma .text-blue-000 }

The multiplication must be performed after the recursive function returns. Thus, the recursive function call is **not** the last instruction in the function.

</details>

#### Excursion exercise

We have converted the factorial program to use tail recursion.
Translate this program to RISC-V.
Try to avoid using the call stack during the `fact_tail` implementation. Why is this possible?

```c
{% include_relative 4-functions-stack/ex6.c %}
```

{% if site.solutions.show_session_6 %}

##### Solution

```text
{% include_relative 4-functions-stack/sol6.asm %}
```

{% endif %}

## Re-examination

The re-examination will take place in the third exam period. It will consist of only one test, and will cover the full material of the previous two tests (1 through 8). The duration is 2 hours. The questions will have a format and difficulty similar to those of test 1 and 2.
