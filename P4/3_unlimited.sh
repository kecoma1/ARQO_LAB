result=0
rm -f data/3/*.log

echo -e "\n3.3"
for ((N = 512+3 ; N <= 2500 ; N += 64)); do
    echo "SERIE      - $N"
    result=$(./multiplication $N | grep 'time' | awk '{print $3}')
    echo -e "$N\t$result" >> data/3/time_chart_serie.log
    echo -e "multiplication 1000 done"
    echo
    echo "PARALLEL 3 - $N"
    result=$(./multiplication_par3 $N 4 | grep 'time' | awk '{print $3}')
    echo -e "$N\t$result" >> data/3/time_chart_parallel.log
    echo -e "multiplication_par3 2000 $N done"    
    echo
done

# Drawing the chart
gnuplot << END_GNUPLOT
call "3_chart.plot"
END_GNUPLOT