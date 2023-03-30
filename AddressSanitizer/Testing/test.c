#include<stdio.h>
#include <stdlib.h>
int main() {
	int *x=(int*)calloc(10,sizeof(int)) ;
	x[11]=20;
	printf("%p\n",x[11]);
	free(x);
	return 0;
}