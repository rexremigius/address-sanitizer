#include <stdio.h>
#include <stdlib.h>
int z[10];
// int a;
int main() {
  // int x[10];
  // int *x=(int*)calloc(sizeof(x),sizeof(int)) ;
  double *x = malloc(10 * sizeof(double));
  float *y = calloc(100, sizeof(float));
  int a;
  scanf("%d",&a);
  // int b=50;
  // char *x = calloc(10,sizeof(char));
  // int x[10][20];
  // x[1][30]=25;
  // memcpy(x,x,sizeof(x));
  scanf("%lf\n", &x[a]);
  scanf("%fn", &y[150]);
  // x[11]=20.12;
  // x[11]='a';
  // x[6]=12;
  // printf("%d\n",x[11]);
  //a = 50;
  //  scanf("%lf\n",&x[a]);
  printf("%lf\n", x[a]);
  printf("%f\n", y[150]);

  printf("%d\n",sizeof(x));
  printf("%d\n",sizeof(y));
  // a = 60;
  // printf("%lf\n",x[11]);
  // printf("%c\n",x[11]);
  free(x);
  free(y);
  printf("Hello McW\n");
  return 0;
}