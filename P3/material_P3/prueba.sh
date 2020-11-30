Ninicio=32
Nfinal=128
Npaso=16
EX_3_Cache_png=mult_cache.png
EX_3_Time_png=mult_time.png
rm -f mult.dat
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
