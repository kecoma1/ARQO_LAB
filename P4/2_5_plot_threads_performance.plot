# Title
set title "Time spent in dot product depending in the number threads"

#Axis names
set xlabel "Size of the vector"
set ylabel "Time spent"

# Leyenda
set key left top
set grid

set terminal png size 1920,1080
set output "threads_performance.png"

#Plotting
plot "data/2_5_threads/performance_Threads1.log" using 1:2 title "Parallel version 1 thread" with lines,\
"data/2_5_threads/performance_Threads2.log" using 1:2 title "Parallel version 2 thread"  with lines,\
"data/2_5_threads/performance_Threads3.log" using 1:2 title "Parallel version 3 thread"  with lines,\
"data/2_5_threads/performance_Threads4.log" using 1:2 title "Parallel version 4 thread"  with lines,\
"data/2_5_threads/performance_Threads5.log" using 1:2 title "Parallel version 5 thread"  with lines,\
"data/2_5_threads/performance_Threads6.log" using 1:2 title "Parallel version 6 thread"  with lines,\
"data/2_5_threads/performance_Threads7.log" using 1:2 title "Parallel version 7 thread"  with lines,\
"data/2_5_threads/performance_Threads8.log" using 1:2 title "Parallel version 8 thread"  with lines
