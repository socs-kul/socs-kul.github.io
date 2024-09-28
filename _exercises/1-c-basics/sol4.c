#include <stdio.h>

void swap(int *a, int *b);

int main(void) {
    int a = 1;
    int b = 2;

    swap(&a, &b);
    printf("a: %d\nb: %d\n", a, b);

    return 0;
}

void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
