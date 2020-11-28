#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo3.h"

void compute_multi(tipo **input1, tipo **input2, tipo **output,int n);

int main( int argc, char *argv[])
{
	int n;
	tipo **input1=NULL, **input2=NULL;
    tipo **output=NULL;
	struct timeval fin,ini;
	tipo res=0;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	/* Comprueba argumentos */
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

	/* Main computation */
	compute_multi(input1, input2, output, n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	printf("Total: %lf\n",res);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f\t", input1[i][j]);
        }
        printf("\n");
    }
        printf("\n");
        printf("\n");

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f\t", input2[i][j]);
        }
        printf("\n");
    }
        printf("\n");
        printf("\n");


    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f\t", output[i][j]);
        }
        printf("\n");
    }

	/* Liberamos memoria */
    free(input1);
    free(input2);
    free(output);
    input1 = NULL;
    input2 = NULL;
    output = NULL;

	return 0;
}

void compute_multi(tipo **input1, tipo **input2, tipo **output, int n)
{
	tipo sum = 0, mul = 0;
	int i, j, k;

    /* Recorre las filas de la matriz c */
    for (i = 0; i < n; i++) {
		/* Recorre las columnas de la matriz c */
        for (j = 0; j < n; j++) {
            /* Recorre las columnas y filas de las matrices a y b */
            for (k = 0; k < n; k++) {
                mul = input1[i][k]*input2[k][j];
                sum += mul;
            }
			/* Guardamos el valor del sumatorio a la matriz c */
            output[i][j] = sum;
        }
    }
}
