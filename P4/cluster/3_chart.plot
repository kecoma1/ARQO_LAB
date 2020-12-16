# Title
set title "Time spent in matrix multiplication - Parallel loop 3 VS Serial version"

#Axis names
set xlabel "Size of the matrix"
set ylabel "Time spent"

# Leyenda
set key left top
set grid

set terminal png size 1920,1080
set output "3_chart.png"

#Plotting
plot "time_chart_parallel.log" using 1:2 title "Parallel version 3 performance"  with lines,\
"time_chart_serie.log" using 1:2 title "Serie version performance"  with lines
