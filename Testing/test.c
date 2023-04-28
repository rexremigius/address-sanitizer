#include<stdio.h>
#include <stdlib.h>
int main() {
	int *x=(int*)calloc(10,sizeof(int)) ;
    //double *x=malloc(10*sizeof(double)) ;
    //float *x=malloc(10*sizeof(float));
    //char *x = calloc(10,sizeof(char));
    //int x[10];
    //int x[10][20];
    //x[1][30]=25;
    x[11]=20;
    //x[11]=20.12;
    //x[11]='a';
	//x[6]=12;
	printf("%d\n",x[11]);
    //printf("%f\n",x[11]);
    //printf("%lf\n",x[11]);
    //printf("%c\n",x[11]);
    free(x);
	printf("Hello McW\n");	
	return 0;
}