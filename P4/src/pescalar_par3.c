// ----------- Arqo P4-----------------------
// pescalar_par1
// ¿Funciona correctamente?
//
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include "arqo4.h"

int main(int argc, char *argv[])
{
	int nproc = 0;
	float *A=NULL, *B=NULL;
	long long k=0;
    int size=0;
	struct timeval fin,ini;
	long double sum=0;

    if (argc == 3) {
 		size = atoi( argv[1] );	
 		nproc = atoi( argv[2] );
    } else {
        printf("Error with arguments <size> <num_threads>.\n");
        return -1;
    }  

       
	A = generateVectorOne(size);
	B = generateVectorOne(size);
	if ( !A || !B )
	{
		printf("Error when allocationg matrix\n");
		freeVector(A);
		freeVector(B);
		return -1;
	}
	
    omp_set_num_threads(nproc);

    printf("Se han lanzado %d hilos.\n",nproc);

	gettimeofday(&ini,NULL);
	/* Bloque de computo */
	sum = 0;
	
    /**/
    #pragma omp parallel for reduction(+:sum) if (size>40000)
        for(k=0;k<size;k++) {
	        sum = sum + A[k]*B[k];
        }

	/* Fin del computo */
	gettimeofday(&fin,NULL);

	printf("Resultado: %Lf\n",sum);
	printf("Tiempo: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	freeVector(A);
	freeVector(B);

	return 0;
}
