; RUN: clang %s -o %t
; RUN: %t < input.txt | FileCheck %s

#include <stdio.h>
#include <stdlib.h>
int a;
int main() {
  scanf("%d",&a);
  double *x = malloc(a * sizeof(double));
  float *y = calloc(a, sizeof(float));
  scanf("%lf\n", &x[a]);
  scanf("%fn", &y[150]);
  printf("%d\n",a);
  printf("%lf\n", x[a]);
  printf("%f\n", y[150]);
  printf("%d\n",sizeof(x));
  printf("%d\n",sizeof(y));
  free(x);
  free(y);
  printf("Hello McW\n");
  return 0;
}
