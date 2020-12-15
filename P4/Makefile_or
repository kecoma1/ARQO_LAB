LIBS = 
LIB_DIR =  
FLAGS = -g -lgomp -lm -Wall -D_GNU_SOURCE -fopenmp

.PHONY: clean all

all: clean omp1 omp2 pescalar_serie pescalar_par1 pescalar_par2 pescalar_par3 mul pi edgeDetector_serie edgeDetector_par clear

omp1: omp1.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

omp2: omp2.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

pescalar_serie: pescalar_serie.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

pescalar_par1: pescalar_par1.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

pescalar_par2: pescalar_par2.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
	
pescalar_par3: pescalar_par3.c arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

mul: 
	gcc $(FLAGS) -c arqo3.c
	gcc $(FLAGS) -c multiplication.c
	gcc $(FLAGS) -o multiplication multiplication.o arqo3.o
	gcc $(FLAGS) -c multiplication_par1.c
	gcc $(FLAGS) -o multiplication_par1 multiplication_par1.o arqo3.o
	gcc $(FLAGS) -c multiplication_par2.c
	gcc $(FLAGS) -o multiplication_par2 multiplication_par2.o arqo3.o
	gcc $(FLAGS) -c multiplication_par3.c
	gcc $(FLAGS) -o multiplication_par3 multiplication_par3.o arqo3.o

pi:
	gcc $(FLAGS) -c pi_serie.c
	gcc $(FLAGS) -o pi_serie pi_serie.o
	gcc $(FLAGS) -c pi_par1.c
	gcc $(FLAGS) -o pi_par1 pi_par1.o
	gcc $(FLAGS) -c pi_par2.c
	gcc $(FLAGS) -o pi_par2 pi_par2.o
	gcc $(FLAGS) -c pi_par3.c
	gcc $(FLAGS) -o pi_par3 pi_par3.o
	gcc $(FLAGS) -c pi_par4.c
	gcc $(FLAGS) -o pi_par4 pi_par4.o
	gcc $(FLAGS) -c pi_par5.c
	gcc $(FLAGS) -o pi_par5 pi_par5.o
	gcc $(FLAGS) -c pi_par6.c
	gcc $(FLAGS) -o pi_par6 pi_par6.o
	gcc $(FLAGS) -c pi_par7.c
	gcc $(FLAGS) -o pi_par7 pi_par7.o

edgeDetector_serie: edgeDetector_serie.c stb_image_write.h stb_image.h
	gcc $(FLAGS) -std=gnu99 $(LIB_DIR) -o $@ edgeDetector_serie.c $(LIBS) -lm

edgeDetector_par: edgeDetector_par.c stb_image_write.h stb_image.h
	gcc $(FLAGS) -std=gnu99 $(LIB_DIR) -o $@ edgeDetector_par.c $(LIBS) -lm

stb_image.h:
	@echo "Los ficheros de cabecera de stb se deberían descarga automáticamente"
	@echo "En caso de fallo, descargadlo de https://raw.githubusercontent.com/nothings/stb/master/stb_image.h"
	wget --no-check-certificate https://raw.githubusercontent.com/nothings/stb/master/stb_image.h

stb_image_write.h:
	@echo "Los ficheros de cabecera de stb se deberían descarga automáticamente"
	@echo "En caso de fallo, descargadlo de https://raw.githubusercontent.com/nothings/stb/master/stb_image_write.h"
	wget --no-check-certificate https://raw.githubusercontent.com/nothings/stb/master/stb_image_write.h

clean:
	rm -f *.o *~ omp1 omp2 pescalar_serie pescalar_par1 pescalar_par2 pescalar_par3 edgeDetector_serie edgeDetector_par multiplication multiplication_par1 multiplication_par2 multiplication_par3 pi_serie pi_par1 pi_par2 pi_par3 pi_par4 pi_par5 pi_par6 pi_par7
	
clear:
	rm -f *.o *~
