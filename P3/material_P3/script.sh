#!/bin/bash
Nfinal=256 #17168
Ninicio=0 #16144
Npaso=16

rm -f raw_output.log just_times.log
for i in $(seq $Ninicio $Npaso $(($Nfinal-$Npaso)) ); do

    for n in $(seq 1 1 15); do
        echo -e -n "SLOW\t$i\t" >> "raw_output.log"
        ./slow $i | grep "time" >> "raw_output.log"

        $slow_1 += slow_1
        $slow_2

        echo -e -n "SLOW\t$(($i+$Npaso))\t" >> "raw_output.log"
        ./slow $i+$Npaso | grep "time" >> "raw_output.log"
        echo -e -n "FAST\t$i\t" >> "raw_output.log"
        ./fast $i | grep "time" >> "raw_output.log"
        echo -e -n "FAST\t$(($i+$Npaso))\t" >> "raw_output.log"
        ./fast $i+$Npaso | grep "time" >> "raw_output.log"
    done

    echo 
done
