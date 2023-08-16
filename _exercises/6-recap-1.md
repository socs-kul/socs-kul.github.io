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
The first test will take place on **November 8th**. It serves to examine your understanding of all the material we have seen up until this point. This includes:

| Session 1  | Introduction to C  |
| Session 2 | Assembly basics |
| Session 3 | Advanced C & assembly |
| Session 4 | Functions and the stack |
| Session 5 | Dynamic memory |

The first and second test contribute equally to your final grade for the exercises portion of SOCS. Refer to the ECTS course description for more information about how this course is graded.

The difficulty of the test will not be greater than the more difficult exercises from the exercise sessions. The test will take place on a computer, with a duration of 2 hours. You can access RARS and GCC, but you will not have internet access.

## Structure of this test
Test 1 will consist of two questions:

**Question 1**: A question where you have to write RISC-V assembly. You will receive a description of a program, which you will have to implement. We will check that your implementation gives the correct results and that you have respected the RISC-V calling conventions (see session 4). Try to create your own unit tests to check your implementation. This question should take *at most 40 minutes*.
**Question 2**: In this question you will be given a program description and an implementation in C. You have to translate this C code into RISC-V assembly. This question is usually a little harder than the first one. It should take *at most 1 hour*.
## Practice exam
To help you prepare for the first test, we have provided a practice exam. The format, difficulty and duration of the practice test are very similar to those of the real test, but the questions will obviously be different. Solutions to both questions will be provided a few days before the test. Try to solve these questions yourself before looking at the model solutions!

> :pencil: **Question 1**: Given a sorted array, the length of the array and a target value. If the target value is in the array,
> return its index. If it is not in the array, return the index where it should be inserted.
>
> Respect the RISC-V calling conventions. Do not make use of a custom exception handler (It will interfere with the test-suite). Try to write unit tests to test the validity of your implementation. Make sure to think about edge cases. Use .globl findIndex as the function name. Do not forget to ‘ret’ at the end of your function!
>
>
> Inputs (you can assume that these are given): a0 = array; a1=length; a2=target.
>
> *Examples*:
>
>    array = [1 3 5 7 9]
>    target = 1
>    -> return 0
>    
>    array = [1 3 5 7 9]
>    target = 6
>    -> return 3


> :pencil: **Question 2**: Determine if a word or phrase is an isogram.
> An isogram (also known as a "non-pattern word") is a word or phrase without a repeating letter.
>
>
> Examples of isograms:
>
>   *lumberjacks*
>
>   *background*
>
>   *downstream*
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

## Re-examination
The re-examination will take place in the third exam period. It will consist of only one test, and will cover the full material of the exercise sessions (1 through 11). The duration is 2 hours. The questions will have a format and difficulty similar to those of test 1 and 2.