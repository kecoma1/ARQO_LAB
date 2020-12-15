result=0
rm -f img/*_*

mkdir data/5
rm -f data/5/*.log

echo -e "Serie - 1 image"
echo -e "\t8K"
result=$(./edgeDetector_serie img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/serie1.log

echo -e "\t4K"
result=$(./edgeDetector_serie img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/serie1.log

echo -e "\tFHD"
result=$(./edgeDetector_serie img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/serie1.log

echo -e "\tHD"
result=$(./edgeDetector_serie img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/serie1.log

echo -e "\tSD"
result=$(./edgeDetector_serie img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/serie1.log

echo -e "Parallel - 1 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 1 img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel1.log

echo -e "\t4K"
result=$(./edgeDetector_par 1 img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel1.log

echo -e "\tFHD"
result=$(./edgeDetector_par 1 img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel1.log

echo -e "\tHD"
result=$(./edgeDetector_par 1 img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel1.log

echo -e "\tSD"
result=$(./edgeDetector_par 1 img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel1.log


echo -e "Parallel - 2 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 2 img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel1.log

echo -e "\t4K"
result=$(./edgeDetector_par 2 img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel1.log

echo -e "\tFHD"
result=$(./edgeDetector_par 2 img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel1.log

echo -e "\tHD"
result=$(./edgeDetector_par 2 img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel1.log

echo -e "\tSD"
result=$(./edgeDetector_par 2 img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel1.log


echo -e "Parallel - 1 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 4 img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel1.log

echo -e "\t4K"
result=$(./edgeDetector_par 4 img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel1.log

echo -e "\tFHD"
result=$(./edgeDetector_par 4 img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel1.log

echo -e "\tHD"
result=$(./edgeDetector_par 4 img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel1.log

echo -e "\tSD"
result=$(./edgeDetector_par 4 img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel1.log


echo -e "Parallel - 1 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 8 img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel1.log

echo -e "\t4K"
result=$(./edgeDetector_par 8 img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel1.log

echo -e "\tFHD"
result=$(./edgeDetector_par 8 img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel1.log

echo -e "\tHD"
result=$(./edgeDetector_par 8 img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel1.log

echo -e "\tSD"
result=$(./edgeDetector_par 8 img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel1.log
