# Title
set title "Slow-Fast Execution Time"

# Axis
set ylabel "Execution time (s)"
set xlabel "Matrix Size"

set key right bottom
set grid
set output "$fPNG"

plot "time_slow_fast.dat" using 1:2 with lines lw 2 title "slow",\
     "time_slow_fast.dat" using 1:3 with lines lw 2 title "fast"