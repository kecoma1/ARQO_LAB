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

echo -e "Parallel - 1 image"
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


echo -e "Serie - 2 images"
echo -e "\t8K"
result=$(./edgeDetector_serie img/8k.jpg img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/serie2.log

echo -e "\t4K"
result=$(./edgeDetector_serie img/4k.jpg img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/serie2.log

echo -e "\tFHD"
result=$(./edgeDetector_serie img/FHD.jpg img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/serie2.log

echo -e "\tHD"
result=$(./edgeDetector_serie img/HD.jpg img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/serie2.log

echo -e "\tSD"
result=$(./edgeDetector_serie img/SD.jpg img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/serie2.log

echo -e "Parallel - 2 images"
echo -e "\t8K"
result=$(./edgeDetector_par 1 img/8k.jpg img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel2.log

echo -e "\t4K"
result=$(./edgeDetector_par 1 img/4k.jpg img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel2.log

echo -e "\tFHD"
result=$(./edgeDetector_par 1 img/FHD.jpg img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel2.log

echo -e "\tHD"
result=$(./edgeDetector_par 1 img/HD.jpg img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel2.log

echo -e "\tSD"
result=$(./edgeDetector_par 1 img/SD.jpg img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel2.log


echo -e "Serie - 4 images"
echo -e "\t8K"
result=$(./edgeDetector_serie img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/serie4.log

echo -e "\t4K"
result=$(./edgeDetector_serie img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/serie4.log

echo -e "\tFHD"
result=$(./edgeDetector_serie img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/serie4.log

echo -e "\tHD"
result=$(./edgeDetector_serie img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/serie4.log

echo -e "\tSD"
result=$(./edgeDetector_serie img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/serie4.log

echo -e "Parallel - 4 images"
echo -e "\t8K"
result=$(./edgeDetector_par 1 img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel4.log

echo -e "\t4K"
result=$(./edgeDetector_par 1 img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel4.log

echo -e "\tFHD"
result=$(./edgeDetector_par 1 img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel4.log

echo -e "\tHD"
result=$(./edgeDetector_par 1 img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel4.log

echo -e "\tSD"
result=$(./edgeDetector_par 1 img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel4.log


echo -e "Serie - 8 images"
echo -e "\t8K"
result=$(./edgeDetector_serie img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/serie8.log

echo -e "\t4K"
result=$(./edgeDetector_serie img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/serie8.log

echo -e "\tFHD"
result=$(./edgeDetector_serie img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/serie8.log

echo -e "\tHD"
result=$(./edgeDetector_serie img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/serie8.log

echo -e "\tSD"
result=$(./edgeDetector_serie img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/serie8.log

echo -e "Parallel"
echo -e "\t8K"
result=$(./edgeDetector_par 1 img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg img/8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> data/5/parallel8.log

echo -e "\t4K"
result=$(./edgeDetector_par 1 img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg img/4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> data/5/parallel8.log

echo -e "\tFHD"
result=$(./edgeDetector_par 1 img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg img/FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> data/5/parallel8.log

echo -e "\tHD"
result=$(./edgeDetector_par 1 img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg img/HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> data/5/parallel8.log

echo -e "\tSD"
result=$(./edgeDetector_par 1 img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg img/SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> data/5/parallel8.log
