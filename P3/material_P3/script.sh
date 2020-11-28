#!/bin/bash
Ninicio=0 #16144
Nfinal=1024 #17168
Npaso=64
fDAT=time_slow_fast.dat
fPNG=time_slow_fast.png
cache_size=1024
cache_size2=8192
Lect_png=cache_lectura.png
Escr_png=cache_escritura.png

make clean all

rm -f $fDAT $fPNG *.dat $Lect_png $Escr_png
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
set key left top
set grid
set terminal png size 1920,1080
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
"$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT

Ninicio=128 #5072
Nfinal=256 #5584
Npaso=64

echo "Ejecutando Valgrind ..."
for ((N = cache_size ; N <= cache_size2 ; N *= 2)); do
    echo -e "STEP $N / 8192"
    for ((i = Ninicio ; i <= Nfinal ; i += Npaso)); do
        valgrind --tool=cachegrind --I1=$N,1,64 --D1=$N,1,64 --LL=8388608,1,64 --cachegrind-out-file=ls_out.dat ./slow $i &>/dev/null
        D1mr_slow=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}') # D1mr slow
        D1mw_slow=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw slow
        valgrind --tool=cachegrind --I1=$N,1,64 --D1=$N,1,64 --LL=8388608,1,64 --cachegrind-out-file=ls_out.dat ./fast $i &>/dev/null
        D1mr_fast=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}' ) # D1mr fast
        D1mw_fast=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw fast
        echo $i $D1mr_slow $D1mw_slow $D1mr_fast $D1mw_fast | tr -d , >> $N.dat
    done
done

# Drawing read misses
gnuplot << END_GNUPLOT
set title "Valgrind Execution - Read Misses"
set ylabel "Read misses"
set xlabel "Cache size"
set key left top
set grid
set terminal png size 1920,1080
set output "$Lect_png"
plot "1024.dat" using 1:2 with lines lw 2 title "slow - 1024", \
"1024.dat" using 1:4 with lines lw 2 title "fast - 1024", \
"2048.dat" using 1:2 with lines lw 2 title "slow - 2048", \
"2048.dat" using 1:4 with lines lw 2 title "fast - 2048", \
"4096.dat" using 1:2 with lines lw 2 title "slow - 4096", \
"4096.dat" using 1:4 with lines lw 2 title "fast - 4096", \
"8192.dat" using 1:2 with lines lw 2 title "slow - 8192", \
"8192.dat" using 1:4 with lines lw 2 title "fast - 8192"
replot

set title "Valgrind Execution - Write Misses"
set ylabel "Write misses"
set output "$Escr_png"
plot "1024.dat" using 1:3 with lines lw 2 title "slow - 1024", \
"1024.dat" using 1:5 with lines lw 2 title "fast - 1024", \
"2048.dat" using 1:3 with lines lw 2 title "slow - 2048", \
"2048.dat" using 1:5 with lines lw 2 title "fast - 2048", \
"4096.dat" using 1:3 with lines lw 2 title "slow - 4096", \
"4096.dat" using 1:5 with lines lw 2 title "fast - 4096", \
"8192.dat" using 1:3 with lines lw 2 title "slow - 8192", \
"8192.dat" using 1:5 with lines lw 2 title "fast - 8192"
replot
quit
END_GNUPLOT
