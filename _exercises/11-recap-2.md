---
layout: default
title: "Session 11: Recap session 2"
nav_order: 11
nav_exclude: false
search_exclude: false
has_children: false
has_toc: false
---
# Preparing for Test 2
## Information
The second test will take place on **December 20th**. It serves to examine your understanding of all the material we have seen since the first test, except for the last two sessions. This includes:

| Session 7  | Operating Systems |
| Session 8 | Linked Lists |

These two chapters have built upon the previous ones (sessions 1-5), which is why you still need to be familiar with the previous material. However, sessions 1 through 5 will not be explicitly examined on the test. Nevertheless, we still recommend going through these sessions if you're having difficulty with solving the linked lists excercises.

The material regarding caches and performance will not be asked on the test, but on the final exam in january. The test is centered entirely around writing RISC-V code, just like the first test.

The first and second test contribute equally to your final grade for the exercises portion of SOCS. Refer to the ECTS course description for more information about how this course is graded.

The difficulty of the test will not be greater than the more difficult exercises from the exercise sessions. The test will take place on a computer, with a duration of 2 hours. You can access RARS and GCC, but you will not have internet access.

## Structure of this test
Test 2 will consist of three questions:

**Question 1**: A question about linked lists. We provide a description of a program related to linked lists, and you must implement it in RISC-V assembly. We will check that your implementation gives the correct results, and that you have respected the RISC-V calling conventions (see session 4). You may receive certain auxiliary programs like *list_create*, *list_append*, etc. depending on the question. Your implementation will be assessed automatically using a test suite. Try to create your own unit tests to check the validity of your code. This question should take *at most 1 hour*.
## Practice exam
To help you prepare for the first test, we have provided a practice exam. The format, difficulty and duration of the practice test are very similar to those of the real test, but the questions will obviously be different. 

> :pencil: **Question 1**
> You are given a linked list in register a0. Write a RISC-V program that reverses the order of the elements in the list.
> This must happen in-place, meaning you will not create a new list, but reverse the original one. 
> Return the pointer to the list in register a0.

> Respect the RISC-V calling conventions. Do not make use of a custom exception handler (It will interfere with the test-suite). 
> Try to write unit tests to test the validity of your implementation. Make sure to think about edge cases. 
> Use .globl reverse_list as the function name. Do not forget to ‘ret’ at the end of your function!

Aside from attempting the practice exam, you should redo as many exercises from the previous sessions as possible. These materials will be sufficient for you to pass the test with flying colors.

> :bulb: Tip: Don't neglect the theoretical aspects of this course! 
> Having a solid grasp of the theory will make it a lot easier for you to
> (re)do the exercises and complete the practice exam.

## Re-examination
The re-examination will take place in the third exam period. It will consist of only one test, and will cover the full material of the exercise sessions (1 through 11). The duration is 2 hours. The questions will have a format and difficulty similar to those of test 1 and 2.