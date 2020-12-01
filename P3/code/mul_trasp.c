#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo3.h"

void compute_multi(tipo **input1, tipo **input2, tipo **output,int n);
void traspose(tipo **input, int n);

int main( int argc, char *argv[])
{
	int n;
	tipo **input1=NULL, **input2=NULL;
    tipo **output=NULL;
	struct timeval fin,ini;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	/* Check arguments */
	if( argc!=2 )
	{
		printf("Error: %s <matrix size>\n", argv[0]);
		return -1;
	}

	n=atoi(argv[1]);
	input1=generateMatrix(n);
	if( input1 == NULL ) {
		return -1;
	}

    input2=generateMatrix(n);
	if( input2 == NULL ) {
        free(input1);
        input1 = NULL;
		return -1;
	}
	
    output=generateEmptyMatrix(n);
	if( input2 == NULL ) {
        free(input1);
        input1 = NULL;
        free(input2);
        input1 = NULL;
		return -1;
	}
	gettimeofday(&ini,NULL);

    /* We traspose the matrix b */
    traspose(input2, n);

	/* Main computation */
	compute_multi(input1, input2, output, n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);

	/* Free memory */
    free(input1);
    free(input2);
    free(output);
    input1 = NULL;
    input2 = NULL;
    output = NULL;

	return 0;
}

void traspose(tipo **input, int n) {
    int i = 0, j = 0;
    tipo aux = 0;

    for (i = 0; i < n; i++) {
        for (j = i+1; j < n; j++) {
            aux = input[i][j];
            input[i][j] = input[j][i];
            input[j][i] = aux;
        }
    }
}

/* Traspose multiplication. Row by Row */
void compute_multi(tipo **input1, tipo **input2, tipo **output, int n)
{
	tipo sum = 0, mul = 0;
	int i, j, k;

    /* Traverse through the rows of matrix c */
    for (i = 0; i < n; i++) {
		/* Traverse through the columns of matrix c */
        for (j = 0; j < n; j++) {
            /* Traverse through the columns and rows of matrixes a and b */
            sum = 0;
            for (k = 0; k < n; k++) {
                mul = input1[i][k]*input2[j][k];
                sum += mul;
            }
			/* Store the value of the sum in the matrix c */
            output[i][j] = sum;
        }
    }
}
