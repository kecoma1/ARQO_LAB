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
plot "performance_Threads1.log" using 1:2 title "Parallel version 1 thread" with lines,\
"performance_Threads2.log" using 1:2 title "Parallel version 2 thread"  with lines,\
"performance_Threads3.log" using 1:2 title "Parallel version 3 thread"  with lines,\
"performance_Threads4.log" using 1:2 title "Parallel version 4 thread"  with lines,\
"performance_Threads5.log" using 1:2 title "Parallel version 5 thread"  with lines,\
"performance_Threads6.log" using 1:2 title "Parallel version 6 thread"  with lines,\
"performance_Threads7.log" using 1:2 title "Parallel version 7 thread"  with lines,\
"performance_Threads8.log" using 1:2 title "Parallel version 8 thread"  with lines,\
"performance_Threads9.log" using 1:2 title "Parallel version 9 thread"  with lines,\
"performance_Threads10.log" using 1:2 title "Parallel version 10 thread"  with lines,\
"performance_Threads11.log" using 1:2 title "Parallel version 11 thread"  with lines,\
"performance_Threads12.log" using 1:2 title "Parallel version 12 thread"  with lines,\
"performance_Threads13.log" using 1:2 title "Parallel version 13 thread"  with lines,\
"performance_Threads14.log" using 1:2 title "Parallel version 14 thread"  with lines,\
"performance_Threads15.log" using 1:2 title "Parallel version 15 thread"  with lines,\
"performance_Threads16.log" using 1:2 title "Parallel version 16 thread"  with lines,\
"performance_Threads17.log" using 1:2 title "Parallel version 17 thread"  with lines,\
"performance_Threads18.log" using 1:2 title "Parallel version 18 thread"  with lines,\
"performance_Threads19.log" using 1:2 title "Parallel version 19 thread"  with lines,\
"performance_Threads20.log" using 1:2 title "Parallel version 20 thread"  with lines,\
"performance_Threads21.log" using 1:2 title "Parallel version 21 thread"  with lines,\
"performance_Threads22.log" using 1:2 title "Parallel version 22 thread"  with lines,\
"performance_Threads23.log" using 1:2 title "Parallel version 23 thread"  with lines,\
"performance_Threads24.log" using 1:2 title "Parallel version 24 thread"  with lines