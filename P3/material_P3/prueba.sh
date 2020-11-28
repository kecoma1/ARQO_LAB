Ninicio=128 #5072
Nfinal=256 #5584
Npaso=64
cache_size=1024
cache_size2=8192
Lect_png=cache_lectura.png
Escr_png=cache_escritura.png

rm -f 1024.dat 2048.dat 4096.dat 8192.dat $Lect_png $Escr_png
echo "Ejecutando Valgrind ..."
for ((N = cache_size ; N <= cache_size2 ; N *= 2)); do
    echo -e "STEP $N / 8192"
    for ((i = Ninicio ; i <= Nfinal ; i += Npaso)); do
        valgrind --tool=cachegrind --I1=$N,1,64 --D1=$N,1,64 --LL=8388608,1,64 --cachegrind-out-file=ls_out.dat ./slow $i &>/dev/null
        D1mr_slow=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}') # D1mr slow
        D1mw_slow=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw slow
        valgrind --tool=cachegrind --I1=$N,1,64 --D1=$N,1,64 --LL=8388608,1,64 --cachegrind-out-file=ls_out.dat ./fast $i &>/dev/null
        D1mr_fast=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}') # D1mr fast
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
