Ninicio=5072
Nfinal=5584
Npaso=64
cache_size=1024
cache_size2=8192

rm -f 1024.dat 2048.dat 4096.dat 8192.dat
echo "Ejecutando Valgrind ..."
for ((N = cache_size ; N <= cache_size2 ; N *= 2)); do
    echo -e "STEP $N / 8192 -- $(bc <<< "scale=5;($N/8192)*100")%"
    for ((i = Ninicio ; i <= Nfinal ; i += Npaso)); do
        echo -e "SIZE MATRIX $i / $Nfinal -- $(bc <<< "scale=5;( ($i/($Nfinal - $Ninicio) )*100")%"
        valgrind --tool=cachegrind --I1=$N,1,64 --D1=$N,1,64 --LL=8388608,1,64 --cachegrind-out-file=ls_out.dat ls ./slow $i  &>/dev/null
        D1mr_slow=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}') # D1mr slow
        D1mw_slow=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw slow
        valgrind --tool=cachegrind --I1=$N,1,64 --D1=$N,1,64 --LL=8388608,1,64 --cachegrind-out-file=ls_out.dat ls ./fast $i  &>/dev/null
        D1mr_fast=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $5}') # D1mr fast
        D1mw_fast=$(cg_annotate ls_out.dat | head -n 30 | grep 'PROGRAM TOTALS'| awk '{print $8}') # D1mw fast
        echo $i $D1mr_slow $D1mw_slow $D1mr_fast $D1mw_fast >> $N.dat
    done
done