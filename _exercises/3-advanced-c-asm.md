---
layout: default
title: "Session 3: Advanced C & assembly"
nav_order: 3
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

After the more theory-oriented sessions 1 & 2, this time we will dive into more
complicated exercises (after covering a few more concepts). Of course, if anything
is unclear, you can check back with the previous exercise,
ask your teaching assistant, or post in the Toledo forums!

Let's start off by practicing everything you've learned about RISC-V assembly in the previous
session.

### Exercise 1
A switch case is a more efficient way to denote multiple if statements on the same variable.

Take the following C code:

```c
switch (operation) {
    case 0: result = a + b; break; // If operation == 0, then result = ...
    case 1: result = a - b; break; // If operation == 1, then result = ...
    case 2: result = a + 5; break;
    case 3: result = b + 5; break;
}
```

Convert this code into RISC-V assembly!
Assume that the variables `operation`, `a`, and `b` are integers stored in memory (the data section).
You can store the result in the `a0` register.

> :bulb: Tip: If at first you're scared of the `switch` statement, don't be!
> Think about how you would convert it into consecutive `if` statements in C.

{% if site.solutions.show_session_3 %}
#### Solution
```text
{% include_relative 3-advanced-c-asm/sol1.S %}
```
{% endif %}

# Functions in C

In this session, we will briefly introduce functions in C, but the detailed description of how to
translate them into assembly will be the topic of the [fourth session](/exercises/4-functions-stack).

You probably remember that every C program must contain the `int main(void)` function,
this is where the execution will start. Remember that the first `int` means that
the function will return an integer value, while `(void)` shows that the function
does not take any arguments. The void is optional, it is also possible to write `int main()`

You can use the same syntax to define your own functions in your file:

```c
int difference(int, int);

int main(void) {
    int x = 5;
    int y = 13;
    int d = difference(x, y);
    // ...
}

int difference(int a, int b) {
    if (a >= b) {
        return a - b;
    } else {
        return b - a;
    }
}
```

## Function declarations

What is the role of the first line in the example above?

```c
int difference(int, int); // function declaration
```

The compiler moves linearly in the file, it needs to already know the *signature* (return type, parameters) of functions
when using them (in `main` or in other functions).
For this reason, it's sometimes necessary to include the **function declaration** at the
top of the file.

In the example above, it would have also been fine to just move the function definition
above `main`, in which case you don't need the declaration on the first line anymore.
(But think of an example where two functions call each other, in that case one of them
has to go above the other!)

> :pencil: When you include a header file, such as `#include <stdio.h>`, that file
> also [contains](https://www.tutorialspoint.com/c_standard_library/stdio_h.htm) a list of function declarations, just like this one! This is how your
> compiler knows the list of functions implemented by the standard library.

### Exercise 2

Write a C program that computes the factorial of every number between 1 and 10.
Avoid duplicating code (use loops and functions where applicable).

> Hint: Example syntax of a `for` loop in C: `for (int i; condition; i++){}`

> :pencil: `i++` or `++i` both increment the variable `i` but there is a [slight difference](https://stackoverflow.com/questions/24853/what-is-the-difference-between-i-and-i) in their behaviour (Not relevant for loops)
{% if site.solutions.show_session_3 %}
#### Solution
```c
{% include_relative 3-advanced-c-asm/sol2.c %}
```
{% endif %}

# Structs

We often want to group different variables into one object. For example if our
program handles user data, and we want to store the name and age of each user,
it's a lot more convenient to group these two variables into one object.

This is possible in C using structs.

```c
struct person {
    int age;
    char *name; // Notice the pointer to a string, this will become more clear later
};

int main(void) {
    struct person John;
    John.age = 42;
    John.name = "John";
    // ...
}
```

You can refer to the variables inside the struct with the `.` operator. These values
are going to be placed in consecutive memory by the compiler, but sometimes the compiler
leaves some empty space between the different fields (e.g., for optimization reasons). This is called
**padding**.

If you have _a pointer_ to a struct, you can still refer to the fields of the pointed object:

```c
void birthday(struct person *sp) {
    (*sp).age += 1;
}
```

This notation is a bit cumbersome, so you can replace it with the `->` operator:

```c
void birthday(struct person *sp) {
    sp->age += 1;
}
```

Think about this function! Would it work as intended if we passed the struct itself as the parameter,
not a pointer to it? Try it out!

<details>
  <summary>Solution</summary>

Whenever we call a function, the parameters passed to that function are copied.
If we pass the struct itself, the function will operate on a copy of it. We can
update the fields of this copy, but those changes will not be reflected in the
original struct. This is why we need to pass a pointer (= create a copy of the pointer),
because by pointing to the location of the original struct, we allow
the function to update it.
</details>

### Exercise 3

Define a struct containing a float *f*, double *d*, long *l*, integer *pointer* *p*, and a
single char *c*.
* Print the size of the struct.
* Create a new instance of this struct and print the addresses of each field.
* Draw the memory layout chosen by the compiler.
* Did the compiler introduce padding? If so, where and how much?

{% if site.solutions.show_session_3 %}
#### Solution
```c
{% include_relative 3-advanced-c-asm/sol3.c %}
```

The memory layout might be different on your computer, but here is an example execution:

```
The size of the struct is 40 bytes
f: 0x7ffe33ed6b20
d: 0x7ffe33ed6b28
l: 0x7ffe33ed6b30
p: 0x7ffe33ed6b38
c: 0x7ffe33ed6b40
```

To know whether padding was introduced, we need to know the real sizes of the data
types. The real size of a data type [is not fixed](https://www.tutorialspoint.com/cprogramming/c_data_types.htm) in C.
There's one thing we can immediately notice: the size of a char is
always 1 byte, and here it is the last element of the struct, placed at
byte `0x..40`. But the struct has a size of 40 bytes, so the last byte that belongs to it
in hexadecimal is `0x..20 + 0x27 (39 in decimal) = 0x..47`, meaning there are 7 unused bytes after the
character.

{% endif %}

# Fixed-length arrays

We have already seen integer variables in both C and assembly. How can we create
an array of many integers? Let's say, for example, that we want to store how many
classes we have on each day. We could of course just declare a variable for each
day (`int monday, tuesday, ...;`), but this would get out of hand quickly if we
want to perform an operation on all variables.

We can instead create an array with a fixed number of elements:

```c
int classes[7] = {4, 3, 1, 4, 2, 0, 0};
```

> :pencil: You might be wondering: isn't it redundant to first declare that the array
> will contain 7 elements, then list 7 elements? You're right, you can omit the number
> from between the square brackets: `int pair[] = {32, 64};`.
>
> You can also
> omit elements from the *initializer list* on the right side (if you first specify the length of the array): `int classes_two[7] = {4, 3, 1, 4, 2};`.
> This array will be the same as the `classes` array declared above. If you specify fewer elements
> in the list than the number on the left, the remaining elements will be initialized to
> zero.

## Representation in memory

Arrays are a collection of homogeneous elements, and they are stored contiguously in memory.
The array from above would have the following (partial) representation in memory:

<center>
<img src="/exercises/img/array.png" alt="Values of the array in memory" />
</center>

Notice two things: first, in this example, `int` values take up 4 bytes in memory: the
first integer is stored in bytes `0x100-0x103`, the second in `0x104-0x107`, and
so on. Second, this example uses [big-endian](https://nl.wikipedia.org/wiki/Endianness) notation for demonstration purposes, while the x86 and RISC-V
architectures use little-endian representation.

When we create an array, the variable (`classes`) itself will point to the first element of the array.
It has some special properties, but for the purposes of this course we can think of it as
a regular pointer. This means for example that we can copy it to another pointer
or pass it to a function expecting a pointer argument:

```c
int classes[7] = {4, 3, 1, 4, 2, 0, 0};
int *copy = classes; // Note: only the pointer is copied, not the entire array!
```
At the end of this example, `classes` and `copy` will refer to the same memory location, namely the beginning of the array, which contains the value 4.

## Elements of the array

So now we know that the `classes` variable points to the first element of the array. That means that if
we want to read or write that value, we can just dereference the pointer with `*classes`, as we've done with other pointers.

But how can we access the other elements of the array? Since we know that they are placed next to each
other in memory, we can simply add an offset to the starting pointer to access further elements! If we want to get the
third element of the array, we can write `*(classes + 2)`, because we know that we have to move 2 places to the right in
memory compared to the first element.

> :pencil: Hold on! How come we increment the pointer by 1 for each element
> if the memory addresses increase by 4 for each `int`? If `int`s take up 4 bytes
> in memory, we should also increment the pointer by 4 to get to the next `int`, right?
>
> Well, in C, when you increment an `int` pointer by `N`, it will increment by `N * sizeof(int)` so that it automatically points to the next `int` in memory. [The same is true for other pointer types.](https://stackoverflow.com/a/5610311/3680834)
>
> Keep this in mind though for when you're doing arithmetic with pointers in assembly,
> as there you will have to take care of this yourself!

So for example, if we want to change the value stored for Thursday, we can just write:

```c
*(classes + 3) = 5;
```

This notation is a bit verbose, so C allows us to shorten it using the index notation:
```c
classes[3] = 5;
```

Of course, you can also use a variable as an index for an array. If you want to iterate over all
the elements of the array, this is a very handy way of doing it (keep in mind that
the first element is at index `0`!):

```c
for (int i = 0; i < 7; ++i) {
    printf("%d ", classes[i]);
}
```

## Where do arrays end?

With regular arrays, it's problematic to detect how long an array is. If all the information we have available
is the starting address, how can we tell where the last value of the array is?

In the example above, we explicitly iterated over 7 values, because we know that the week has 7 days.
But what happens if we want to write a function that operates on arrays of varying sizes?

A possible option is to designate a special value as a termination indicator; if our arrays can only contain
positive numbers, we can use a special 0 or negative number as the last value of the array. This way, we can just
iterate over the values of the array until we encounter that special value. This, however, only works if
the possible values are limited. If our array can contain any integer values, what can we do?

### Exercise 4

Write a C program that prints the array `1, 2, 3, 4, 5` (so you know the length) on a single
line separated by spaces, together with the addresses of the elements.
Ask the user for an integer, multiply all elements
of the original array with this integer and print the array again. Now, define
a function to print the array to avoid duplicating your code. Don’t hardcode the size of the array in the printing function: your function should work with various array sizes!

Hint: Don't be discouraged if your solution looks ugly, you can ask the teaching assistant whether it's correct! :)

{% if site.solutions.show_session_3 %}
#### Solution
```c
{% include_relative 3-advanced-c-asm/sol4.c %}
```
{% endif %}

## Strings

How can strings be represented in C? If you think about it, strings are just arrays of characters,
that's also how C handles them. One advantage of characters in the [ASCII encoding](https://www.asciitable.com/)
(used by C) is that they have a
limited set of valid values, so we will be able to use the approach outlined above for indicating the end
of strings.

In C, we always use a null byte `\0` to indicate the end of strings. All the functions in the standard library
that operate on strings will expect to see a null byte at the end of the strings they receive as parameters.

That means that if we want to create a string containing the word `hello`, we need to write the following:

```c
char hello[] = {'h', 'e', 'l', 'l', 'o', '\0'};
```

Notice that this means that we use one extra byte to store the string, compared to the number of characters!

C also has special syntax for strings (that we have seen before) to make it easier to work with them.

```c
char hello[] = "hello"; // Notice the [] 
```

This will allocate the same array as the example before, complete with the terminating null byte.

### Exercise 5

Write a C program that asks the user for a string and outputs
the length of the string.
You can use
the function `fgets` [with the parameter `stdin`](http://www.cplusplus.com/reference/cstdio/fgets/) to read a whole string from the console.

> :pencil: stdin refers to the standard input, stdout to the standard output. When you run a program in a terminal, stdin is the input from the terminal you can provide.


First, write a version using the function `unsigned long strlen(char *)`
declared in the header `string.h` to get the length. Then create a second version where `strlen`
is not used, so you have to implement your own method to count the length of the entered string. Note that the last character of the string will be the null byte
(`\0`).

{% if site.solutions.show_session_3 %}
#### Solution
```c
{% include_relative 3-advanced-c-asm/sol5.c %}
```
{% endif %}

### Exercise 6

Modify the program above so that it prints the hexadecimal
representation of each character in the string in order. Verify the
output using an ASCII table. Hint: use the format
string `%02x`.

{% if site.solutions.show_session_3 %}
#### Solution

We add one extra line in our function:

```c
{% include_relative 3-advanced-c-asm/sol6.c %}
```
{% endif %}

# Arrays in assembly

In RISC-V assembly, there is no strong notion of arrays. But since we
know that arrays are just consecutive values in memory, we can implement them the
same way in assembly as they work in C. You can use comma-separated values to reserve consecutive
words in memory:

```text
.data
    array: .word 1, 2, 3, 4 # Will reserve 4 consecutive words in memory
```

### Exercise 7

Write a RISC-V program that multiplies all numbers in an
array with a constant number without using the `mul` instruction.

{% if site.solutions.show_session_3%}
#### Solution

In this program, we move in reverse order of the elements to avoid explicitly
needing to take care of which element we're dealing with.

```text
{% include_relative 3-advanced-c-asm/sol7.S %}
```
{% endif %}

## Strings in assembly

For strings, we again have special syntax:

```text
.data
    str: .string "hello"
```

This string notation behaves the same way as in C, complete with the terminating
zero byte. You can also see this in RARS, consider the following 'program':

```text
.data
    str1: .string "hello"
    str2: .string "world"
```
If you assemble this program and look at the 'Data Segment' you will find both strings, each `\0` terminated:

<center>
<img src="/exercises/img/string-layout.png" alt="Values of the array in memory" />
</center>
Each hexadecimal digit represents 4 bits, and you know a char consists of a single byte. Reading it out gives:

Value                               | To text
-----------------------------------:|:-------------
0x6c6c6568                          | lleh
0x6f77006f                          | ow`\0`o
0x00646c72                          | `\0`dlr



### Exercise 8

Translate the C program calculating the length of a string without `strlen` from exercise 5
to RISC-V. The string can be provided in the data section. The resulting
length should be stored in register `a0`.

{% if site.solutions.show_session_3 %}
#### Solution
```text
{% include_relative 3-advanced-c-asm/sol8.S %}
```
{% endif %}

### Exercise 9

Write a RISC-V program that searches for a given zero-terminated
substring in a string (e.g., `"loss"` in `"blossom"`) and returns 1 if it is present, 0 if it isn’t. Define the
strings in the data section and place the result in register `a0`. First, write
a solution assuming that the characters of the string are 32-bit words (use
`.word` instead of `.string`). What changes if the characters are bytes (using
`.string`)?

{% if site.solutions.show_session_3 %}
#### Solution

A possible solution for comparing strings:

```text
{% include_relative 3-advanced-c-asm/sol9.S %}
```

If we compare words instead of characters in a string, we need to be careful with
two things:

1. Using `lw` instead of `lbu` to load individual words (instead of characters)
2. Increasing the array pointers by 4 (one word is 4 bytes long)

{% endif %}

# Additional exercises
### Exercise 10
A palindrome is a word that reads the same forward and backward. An example would be 'racecar'. Write a program that, given a string containing one or more words (separated by spaces), returns the amount of palindromes in the given sentence (in register a0). You can assume that all input sentences contain only lowercase letters and no other characters.

**Example**:

    Input (in register a0): "this honda civic can hardly be called a racecar"
    Output (in register a0): 3
    Explanation: 'civic', 'racecar' and 'a' are all palindromes. The other words are not.

### Exercise 11
The following C program checks if two strings are anagrams of each other. An anagram is a word that is created by rearranging the letters in another word. An example would be 'night' and 'thing'. Translate the C program to RISC-V assembly. You do not have to ask the strings as user input, and you should not print anything to the console like in the C program. Instead, simply return 1 if both strings are anagrams of each other, and 0 otherwise. You can assume that there are no spaces and no non-letter characters in the strings. 

```c
#include <stdio.h>
#include <conio.h>
#include <string.h>

int main()
{
    char str1[20], str2[20];
    int len, len1, len2, i, j, found=0, not_found=0;
    printf("Enter first string: ");
    gets(str1);
    printf("Enter second string: ");
    gets(str2);

    len1 = strlen(str1);
    len2 = strlen(str2);
    
    if(len1 == len2)
    {
        len = len1;
        for(i=0; i<len; i++)
        {
            found = 0;
            for(j=0; j<len; j++)
            {
                if(str1[i] == str2[j])
                {
                    found = 1;
                    break;
                }
            }
            if(found == 0)
            {
                not_found = 1;
                break;
            }
        }
        if(not_found == 1)
            printf("\nStrings are not Anagram");
        else
            printf("\nStrings are Anagram");
    }
    else
        printf("\nBoth string must contain same number of character to be an Anagram Strings");
    getch();
    return 0;
}
```
[Source](https://codescracker.com/c/program/c-anagram-program.htm)


Load two strings into register a0 and a1 to test your program. Write a few [unit tests](https://socs-kul.github.io/exercises/6-recap-1/#writing-unit-tests) to test your implementation.

### Exercise 12
The following C program finds the two elements in an array whose sum is closest to zero. Translate this program into RISC-V assembly.

```c
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

void findMinSumPair(int *arr1, int arr_size)
{
  int i, j, sum, minSum, min1Pair, min2Pair;

  if(arr1 == NULL || arr_size < 2)
      return;
  min1Pair = arr1[0];
  min2Pair = arr1[1];
  minSum = min1Pair + min2Pair;
  
  for(i = 0; i < arr_size-1; i++) 
  {
    for(j = i+1; j < arr_size; j++) 
	{
      sum = arr1[i] + arr1[j];
      if(abs(sum) < abs(minSum)) 
	  {
        minSum = sum;
        min1Pair = arr1[i];
        min2Pair = arr1[j];
      }
    }
  }
  printf("[%d, %d]\n", min1Pair, min2Pair);
}
 
int main()
{
    int arr1[] = {38, 44, 63, -51, -35, 19, 84, -69, 4, -46}; 
    int ctr = sizeof(arr1)/sizeof(arr1[0]);
    int i;  

    // print original array
	printf("The given array is :  ");
	for(i = 0; i < ctr; i++)
	{
	printf("%d  ", arr1[i]);
    } 
    printf("\n");

    printf("The Pair of elements whose sum is minimum are: \n");
    findMinSumPair(arr1, ctr);
    return 0;
}
```

[Source](https://www.w3resource.com/c-programming-exercises/array/c-array-exercise-45.php)