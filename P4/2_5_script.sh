time1=0
total1=0
time2=0
total2=0
numcores=4 # Comprobar cuántos cores tiene el cluster
rm -f data/*.log data/2_5_threads/*.log
for ((N = 4000000 ; N <= 348000000 ; N += 16000000)); do
    echo -e "STEP $N / 348000000"
    total2=0
    time1=$(./pescalar_serie $N | grep 'Tiempo' | awk '{print $2}')
    for ((i = 1 ; i <= 2*$numcores ; i += 1)); do 
        for ((j = 1; j < 4 ; j += 1)); do
            time2=$(./pescalar_par3 $N $i | grep 'Tiempo' | awk '{print $2}')
            total2=$(bc <<< "scale=2;$total2+$time2")
        done
        total2=$(bc <<< "scale=2;$total2/4")
        echo -e "$N $total2" >> data/2_5_threads/performance_Threads$i.log
    done

    total2=$(bc <<< "scale=6;$total2/(2*$numcores)")

    echo -e "$N\t$time1\t$total2" >> data/serial_vs_par.log
done

gnuplot << END_GNUPLOT
call "2_5_plot_serie_vs_parallel.plot"
call "2_5_plot_threads_performance.plot"
END_GNUPLOT