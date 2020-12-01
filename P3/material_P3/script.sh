#!/bin/bash
Ninicio=16144
Nfinal=17168
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

echo "Exercise 1"
echo "Executing time ..."
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

# Drawing time execution
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

Ninicio=5072
Nfinal=5584
Npaso=64

echo "Exercise 2"
echo "Executing Valgrind ..."
for ((N = cache_size ; N <= cache_size2 ; N *= 2)); do
    echo -e "STEP $N / 8192"
    for ((i = Ninicio ; i <= Nfinal ; i += Npaso)); do
        valgrind --tool=cachegrind --I1=$N,1,64 --D1=$N,1,64 --LL=8388608,1,64 --cachegrind-out-file=ls_out.dat ./slow $i &>/dev/null
        D1mr_slow=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}') # D1mr slow
        D1mw_slow=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw slow
        valgrind --tool=cachegrind --I1=$N,1,64 --D1=$N,1,64 --LL=8388608,1,64 --cachegrind-out-file=ls_out.dat ./fast $i &>/dev/null
        D1mr_fast=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}' ) # D1mr fast
        D1mw_fast=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw fast
        echo -e "$i\t$D1mr_slow\t$D1mw_slow\t$D1mr_fast\t$D1mw_fast" | tr -d , >> $N.dat
    done
done

# Drawing read and write misses
gnuplot << END_GNUPLOT
set title "Valgrind Execution - Read Misses"
set ylabel "Read misses"
set xlabel "Matrix size"
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

Ninicio=1792
Nfinal=2048
Npaso=32
EX_3_Cache_png=mult_cache.png
EX_3_Time_png=mult_time.png
total1=0
total2=0

echo "Exercise 3"
echo "Executing time ..."
for i in $(seq $Ninicio $Npaso $Nfinal ); do
    echo -e "SIZE $i / $Nfinal"
    for n in $(seq 1 1 15); do
        size1=$(./multiplication $i | grep 'time' | awk '{print $3}')
        total1=$(bc <<< "scale=2;$total1+$size1")
        size2=$(./mul_trasp $i | grep 'time' | awk '{print $3}')
        total2=$(bc <<< "scale=2;$total2+$size2")
    done

    total1=$(bc <<< "scale=6;$total1/15")
    total2=$(bc <<< "scale=6;$total2/15")

    echo -e "\tValgrind - Normal multiplication"
    rm -f ls_out_normal.dat
    valgrind --tool=cachegrind --cachegrind-out-file=ls_out_normal.dat ./multiplication $i &>/dev/null
    D1mr_multiplication=$(cg_annotate ls_out_normal.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}') # D1mr multiplication
    D1mw_multiplication=$(cg_annotate ls_out_normal.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw multiplication

    echo -e "\tValgrind - Traspose multiplication"
    rm -f ls_out_tras.dat
    valgrind --tool=cachegrind --cachegrind-out-file=ls_out_tras.dat ./mul_trasp $i &>/dev/null
    D1mr_mult_trasp=$(cg_annotate ls_out_tras.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}') # D1mr mult_trasp
    D1mw_mult_trasp=$(cg_annotate ls_out_tras.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw mult_trasp
    echo -e "$i\t$total1\t$D1mr_multiplication\t$D1mw_multiplication\t$total2\t$D1mr_mult_trasp\t$D1mw_mult_trasp" | tr -d , >> mult.dat
done

# Drawing cache misses and execution time for exercise 3
gnuplot << END_GNUPLOT
set title "Runtime"
set ylabel "Execution time"
set xlabel "Matrix size"
set key left top
set grid
set terminal png size 1920,1080
set output "$EX_3_Time_png"
plot "mult.dat" using 1:2 with lines lw 2 title "Normal multiplication", \
"mult.dat" using 1:5 with lines lw 2 title "Traspose multiplication"
replot

set title "Valgrind Execution - Cache misses"
set ylabel "Cache misses"
set output "$EX_3_Cache_png"
plot "mult.dat" using 1:7 with lines lw 2 title "Write misses - Traspose multiplication", \
"mult.dat" using 1:4 with lines lw 2 title "Write misses - Normal multiplication", \
"mult.dat" using 1:6 with lines lw 2 title "Read misses - Traspose multiplication", \
"mult.dat" using 1:3 with lines lw 2 title "Read misses - Normal multiplication"
replot
quit
END_GNUPLOT
