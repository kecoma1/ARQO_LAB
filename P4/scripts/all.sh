#!/bin/bash
cd /home/arqo61/cluster
time1=0
total1=0
time2=0
total2=0
numcores=8
rm -f *.log
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
        echo -e "$N $total2" >> performance_Threads$i.log
    done
    total2=$(bc <<< "scale=6;$total2/(2*$numcores)")
    echo -e "$N\t$time1\t$total2" >> serial_vs_par.log
done
result=0
echo "10 seconds"
result=$(./multiplication 1000 | grep 'time' | awk '{print $3}')
echo -e "serie\t1\t$result" >> table10s.log
echo -e "multiplication 1000 done"
for ((N = 1 ; N <= 4 ; N += 1)); do
    echo "$N THREAD"
    result=$(./multiplication_par1 1000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop1\t$N-thread\t$result" >> table10s.log
    echo -e "multiplication_par1 1000 $N done"

    result=$(./multiplication_par2 1000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop2\t$N-thread\t$result" >> table10s.log
    echo -e "multiplication_par2 1000 $N done"

    result=$(./multiplication_par3 1000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop3\t$N-thread\t$result" >> table10s.log
    echo -e "multiplication_par3 1000 $N done"    
done
echo -e "\n60 seconds"
result=$(./multiplication 2000 | grep 'time' | awk '{print $3}')
echo -e "serie\t1\t$result" >> table60s.log
echo -e "multiplication 2000 done"
for ((N = 1 ; N <= 4 ; N += 1)); do
    echo "$N THREAD"
    result=$(./multiplication_par1 2000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop1\t$N-thread\t$result" >> table60s.log
    echo -e "multiplication_par1 2000 $N done"

    result=$(./multiplication_par2 2000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop2\t$N-thread\t$result" >> table60s.log
    echo -e "multiplication_par2 2000 $N done"

    result=$(./multiplication_par3 2000 $N | grep 'time' | awk '{print $3}')
    echo -e "P-loop3\t$N-thread\t$result" >> table60s.log
    echo -e "multiplication_par3 2000 $N done"    
done
echo -e "\n3.3"
for ((N = 512+3 ; N <= 2500 ; N += 64)); do
    echo "SERIE      - $N"
    result=$(./multiplication $N | grep 'time' | awk '{print $3}')
    echo -e "$N\t$result" >> time_chart_serie.log
    echo -e "multiplication 1000 done"
    echo
    echo "PARALLEL 3 - $N"
    result=$(./multiplication_par3 $N 4 | grep 'time' | awk '{print $3}')
    echo -e "$N\t$result" >> time_chart_parallel.log
    echo -e "multiplication_par3 2000 $N done"    
    echo
done
result=0
echo -e "Serie - 1 image"
echo -e "\t8K"
result=$(./edgeDetector_serie 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> serie1.log
echo -e "\t4K"
result=$(./edgeDetector_serie 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> serie1.log
echo -e "\tFHD"
result=$(./edgeDetector_serie FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> serie1.log
echo -e "\tHD"
result=$(./edgeDetector_serie HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> serie1.log
echo -e "\tSD"
result=$(./edgeDetector_serie SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> serie1.log
echo -e "Parallel - 1 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 1 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> parallel1.log
echo -e "\t4K"
result=$(./edgeDetector_par 1 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> parallel1.log
echo -e "\tFHD"
result=$(./edgeDetector_par 1 FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> parallel1.log
echo -e "\tHD"
result=$(./edgeDetector_par 1 HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> parallel1.log
echo -e "\tSD"
result=$(./edgeDetector_par 1 SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> parallel1.log
echo -e "Parallel - 2 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 2 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> parallel2.log
echo -e "\t4K"
result=$(./edgeDetector_par 2 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> parallel2.log
echo -e "\tFHD"
result=$(./edgeDetector_par 2 FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> parallel2.log
echo -e "\tHD"
result=$(./edgeDetector_par 2 HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> parallel2.log
echo -e "\tSD"
result=$(./edgeDetector_par 2 SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> parallel2.log
echo -e "Parallel - 4 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 4 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> parallel4.log
echo -e "\t4K"
result=$(./edgeDetector_par 4 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> parallel4.log
echo -e "\tFHD"
result=$(./edgeDetector_par 4 FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> parallel4.log
echo -e "\tHD"
result=$(./edgeDetector_par 4 HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> parallel4.log
echo -e "\tSD"
result=$(./edgeDetector_par 4 SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> parallel4.log
echo -e "Parallel - 8 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 8 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> parallel8.log
echo -e "\t4K"
result=$(./edgeDetector_par 8 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> parallel8.log
echo -e "\tFHD"
result=$(./edgeDetector_par 8 FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> parallel8.log
echo -e "\tHD"
result=$(./edgeDetector_par 8 HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> parallel8.log
echo -e "\tSD"
result=$(./edgeDetector_par 8 SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> parallel8.log
# Drawing the chart
gnuplot << END_GNUPLOT
call "3_chart.plot"
call "2_5_plot_serie_vs_parallel.plot"
call "2_5_plot_threads_performance.plot"
END_GNUPLOT