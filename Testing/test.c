#include<stdio.h>
#include <stdlib.h>
int a=50;
int main() {
    //int x[10];
	//int *x=(int*)calloc(sizeof(x),sizeof(int)) ;
    double *x=malloc(10*sizeof(double)) ;
    float *y=malloc(100*sizeof(float));
    // scanf("%d",&a);
    //char *x = calloc(10,sizeof(char));
    //int x[10][20];
    //x[1][30]=25;
    //memcpy(x,x,sizeof(x));
    scanf("%lf\n",&x[50]);
    scanf("%lf",&x[150]);
    //x[11]=20.12;
    //x[11]='a';
	//x[6]=12;
	//printf("%d\n",x[11]);
    printf("%lf\n",x[50]);
    printf("%lf\n",y[50]);
    //printf("%lf\n",x[11]);
    //printf("%c\n",x[11]);
    free(x);
    free(y);
	printf("Hello McW\n");	
	return 0;
}