#!/bin/bash
$MAX = 256 #17168
$MIN = 1 #16144
for i in $(seq 6 16 $MAX); do # Esta mal
    echo "SIZE: $i"
    ./slow $i
done