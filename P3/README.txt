We are pair 2, so 2mod7 = 2 + 4 = 6. P = 6
We have to run the programs with sizes from 10000+1024*6 = 16144
to 10000+1024*(6+1) = 17168, incrementing 64 in each iteration
Call each program n_times and do the average taking into account that average (15)

If we don't measure performance several times we will not a have a good sample.
What we mean with good sample is that the generated plot will have too many sharp edges
which don't show us the performance in one moment, because if we generate again the plot
in that moment we could have a close value to the previous one, for that we run the program several times
and then we calculate the average, the value obtained represents the overall behavior of the
program.

Save the data in time_slow_fast.dat --> <N> <time "slow"> <time "fast">\n

Draw a plot and save it. time_slow_fast.png

Explain the results




2. 
Matrices NxN 
2000+512*6 -> 2000+512*7  --- Tamaño matriz
5072 -- +64 --> 5584

I1 y D1 - 1024, 2048, 4096 y 8192 Bytes
LL - 8*2²⁰

1 way 
64 bytes line sizes

Guardamos en 1024.dat 2048.dat ...
    Dentro tiene que haber
    N (size matriz) Misses read slow    Misses write slow   Misses read fast    Misses write fast

valgrind --tool=cachegrind --cachegrind-out-file=ls_out.dat ls
cg_annotate ls_out.dat | head -n 30

3.
Matrices NxN
256+256*6 --> 256+256*7  -- Tamaño matriz
1792 -- +32 --> 2048
