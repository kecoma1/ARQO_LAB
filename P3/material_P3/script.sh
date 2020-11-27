#!/bin/bash
Ninicio=0
Nfinal=1512 #17168
Npaso=8
fDAT=time_slow_fast.dat
fPNG=time_slow_fast.png

rm -f $fDAT $fPNG *.dat
total1=0
total2=0
size1=0
size2=0

# Ejecutando time
echo "Ejecutando time ..."
for i in $(seq $Ninicio $Npaso $Nfinal ); do
    echo -e "SIZE $i / $Nfinal -- $(bc <<< "scale=5;($i/$Nfinal)*100")%"
    for n in $(seq 1 1 15); do
        size1=$(./slow $i | grep 'time' | awk '{print $3}')
        total1=$(bc <<< "scale=2;$total1+$size1")
        size2=$(./fast $i | grep 'time' | awk '{print $3}')
        total2=$(bc <<< "scale=2;$total2+$size2")
    done

    total1=$(bc <<< "scale=6;$total1/15")
    total2=$(bc <<< "scale=6;$total2/15")
    echo -e "$i\t$total1\t $total2" >> $fDAT
done

gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
"$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT

Ninicio=0  #5072
Nfinal=1512 #5584
Npaso=8 #64
cache_size=1024
cache_size2=8192

# Ejecutando valgrid
echo "Ejecutando Valgrind ..."
for ((N = cache_size ; N <= cache_size2 ; N *= 2)); do

    size1=$(./slow $i | grep 'time' | awk '{print $3}')
    total1=$(bc <<< "scale=2;$total1+$size1")
    size2=$(./fast $i | grep 'time' | awk '{print $3}')
    total2=$(bc <<< "scale=2;$total2+$size2")


    total1=$(bc <<< "scale=6;$total1/15")
    total2=$(bc <<< "scale=6;$total2/15")
    echo -e "$i\t$total1\t $total2" >> $fDAT
done