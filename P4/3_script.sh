result=0
rm -f data/3/*.log

echo "10 seconds"

result=$(./multiplication 1000 | grep 'time' | awk '{print $3}')
echo -e "serie\t1\t$result" >> data/3/table10s.log
echo -e "multiplication 1000 done"

for ((N = 1 ; N <= 4 ; N += 1)); do
    echo "$N THREAD"
    result=$(./multiplication_par1 1000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop1\t$N-thread\t$result" >> data/3/table10s.log
    echo -e "multiplication_par1 1000 $N done"

    result=$(./multiplication_par2 1000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop2\t$N-thread\t$result" >> data/3/table10s.log
    echo -e "multiplication_par2 1000 $N done"

    result=$(./multiplication_par3 1000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop3\t$N-thread\t$result" >> data/3/table10s.log
    echo -e "multiplication_par3 1000 $N done"    
done

echo -e "\n60 seconds"

result=$(./multiplication 2000 | grep 'time' | awk '{print $3}')
echo -e "serie\t1\t$result" >> data/3/table60s.log
echo -e "multiplication 2000 done"

for ((N = 1 ; N <= 4 ; N += 1)); do
    echo "$N THREAD"
    result=$(./multiplication_par1 2000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop1\t$N-thread\t$result" >> data/3/table60s.log
    echo -e "multiplication_par1 2000 $N done"

    result=$(./multiplication_par2 2000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop2\t$N-thread\t$result" >> data/3/table60s.log
    echo -e "multiplication_par2 2000 $N done"

    result=$(./multiplication_par3 2000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop3\t$N-thread\t$result" >> data/3/table60s.log
    echo -e "multiplication_par3 2000 $N done"    
done

echo -e "\n3.3"
for ((N = 512+3 ; N <= 1024+512+3 ; N += 64)); do
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