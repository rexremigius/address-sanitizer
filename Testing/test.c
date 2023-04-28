#include<stdio.h>
#include <stdlib.h>
int main() {
	//int *x=(int*)calloc(10,sizeof(int)) ;
    //int *x=(int*)malloc(10*sizeof(int)) ;
    int x[10];
    //int x[10][20];
    //x[1][30]=25;
    x[11]=20;
	//x[6]=12;
	printf("%d\n",x[11]);
    //free(x);
	printf("Hello McW\n");	
	return 0;
}
/*int main() {
    int *arr = malloc(sizeof(int) * 5); // allocate memory for 5 integers
    int i;

    for (i = 0; i < 10; i++) {
        // assign value to index out of bounds
        arr[i] = i;

        // print value at index
        printf("arr[%d] = %d", i, arr[i]);
    }

    free(arr); // free allocated memory

    return 0;
}*/