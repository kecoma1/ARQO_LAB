# Title
set title "Time spent in dot product - Parallel vs serie"

#Axis names
set xlabel "Size of the vector"
set ylabel "Time spent"

# Leyenda
set key left top
set grid

set terminal png size 1920,1080
set output "serie_vs_parallel.png"

#Plotting
plot "data/serial_vs_par.log" using 1:2 title "Serie version" with lines,\
"data/serial_vs_par.log" using 1:3 title "Average parallel version"  with lines
