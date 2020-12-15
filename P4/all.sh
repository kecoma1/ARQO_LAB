time1=0
total1=0
time2=0
total2=0
numcores=8
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

result=0
rm -f img/*_*

mkdir data/5
rm -f data/5/*.log

echo -e "Serie - 1 image"
echo -e "\t8K"
result=$(./edgeDetector_serie img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/serie1.log

echo -e "\t4K"
result=$(./edgeDetector_serie img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/serie1.log

echo -e "\tFHD"
result=$(./edgeDetector_serie img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/serie1.log

echo -e "\tHD"
result=$(./edgeDetector_serie img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/serie1.log

echo -e "\tSD"
result=$(./edgeDetector_serie img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/serie1.log

echo -e "Parallel - 1 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 1 img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel1.log

echo -e "\t4K"
result=$(./edgeDetector_par 1 img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel1.log

echo -e "\tFHD"
result=$(./edgeDetector_par 1 img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel1.log

echo -e "\tHD"
result=$(./edgeDetector_par 1 img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel1.log

echo -e "\tSD"
result=$(./edgeDetector_par 1 img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel1.log


echo -e "Parallel - 2 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 2 img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel1.log

echo -e "\t4K"
result=$(./edgeDetector_par 2 img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel1.log

echo -e "\tFHD"
result=$(./edgeDetector_par 2 img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel1.log

echo -e "\tHD"
result=$(./edgeDetector_par 2 img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel1.log

echo -e "\tSD"
result=$(./edgeDetector_par 2 img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel1.log


echo -e "Parallel - 4 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 4 img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel1.log

echo -e "\t4K"
result=$(./edgeDetector_par 4 img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel1.log

echo -e "\tFHD"
result=$(./edgeDetector_par 4 img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel1.log

echo -e "\tHD"
result=$(./edgeDetector_par 4 img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel1.log

echo -e "\tSD"
result=$(./edgeDetector_par 4 img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel1.log


echo -e "Parallel - 8 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 8 img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel1.log

echo -e "\t4K"
result=$(./edgeDetector_par 8 img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel1.log

echo -e "\tFHD"
result=$(./edgeDetector_par 8 img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel1.log

echo -e "\tHD"
result=$(./edgeDetector_par 8 img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel1.log

echo -e "\tSD"
result=$(./edgeDetector_par 8 img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel1.log

# Drawing the chart
gnuplot << END_GNUPLOT
call "3_chart.plot"
call "2_5_plot_serie_vs_parallel.plot"
call "2_5_plot_threads_performance.plot"
END_GNUPLOT

