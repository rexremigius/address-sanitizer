#include<stdio.h>
#include<stdlib.h>
int main() {
  int *arr = malloc(sizeof(int) * 5); // allocate memory for 5 integers
  int i;

  for (i = 0; i < 10; i++) {
    // assign value to index out of bounds
    arr[i] = i;

    // print value at index
        printf("arr[%d] = %d\n", i, arr[i]);
  }

  free(arr); // free allocated memory

  return 0;
}