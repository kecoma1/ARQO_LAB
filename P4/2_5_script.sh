time1=0
total1=0
time2=0
total2=0
numcores=4
rm -f data/*.log data/2_5_threads/*.log
for ((N = 4000000 ; N <= 348000000 ; N += 16000000)); do
    echo -e "\nSTEP $N / 348000000"
    for ((i = 1 ; i <= 2*$numcores ; i += 1)); do 
        time1=$(./pescalar_serie $N | grep 'Tiempo' | awk '{print $2}')
        total1=$(bc <<< "scale=2;$total1+$time1")
        time2=$(./pescalar_par3 $N $i | grep 'Tiempo' | awk '{print $2}')
        total2=$(bc <<< "scale=2;$total2+$time2")
        echo -e "$N $time2" >> data/2_5_threads/performance_Threads$i.log
    done

    total1=$(bc <<< "scale=6;$total1/5")
    total2=$(bc <<< "scale=6;$total2/5")
    echo "$total1 Average serial"
    echo "$total2 Average parallel"

    echo -e "$N\t$time1\t$time2" >> data/serial_vs_par.log
done
