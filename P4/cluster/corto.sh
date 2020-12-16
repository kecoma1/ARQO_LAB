#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -o simple.out
#$ -j y

# Anadir valgrind y gnuplot al path
export PATH=$PATH:/share/apps/tools/valgrind/bin:/share/apps/tools/gnuplot/bin

export OMP_NUM_THREADS=8
./all_fast.sh