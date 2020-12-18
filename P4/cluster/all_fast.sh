#!/bin/bash
cd /home/arqo61/cluster
result=0
echo -e "Serie - 1 image"
echo -e "\t8K"
result=$(./edgeDetector_serie 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> serie1.log
echo -e "\t4K"
result=$(./edgeDetector_serie 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> serie1.log
echo -e "\tFHD"
result=$(./edgeDetector_serie FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> serie1.log
echo -e "\tHD"
result=$(./edgeDetector_serie HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> serie1.log
echo -e "\tSD"
result=$(./edgeDetector_serie SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> serie1.log
echo -e "Parallel - 1 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 1 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> parallel1.log
echo -e "\t4K"
result=$(./edgeDetector_par 1 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> parallel1.log
echo -e "\tFHD"
result=$(./edgeDetector_par 1 FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> parallel1.log
echo -e "\tHD"
result=$(./edgeDetector_par 1 HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> parallel1.log
echo -e "\tSD"
result=$(./edgeDetector_par 1 SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> parallel1.log
echo -e "Parallel - 2 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 2 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> parallel2.log
echo -e "\t4K"
result=$(./edgeDetector_par 2 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> parallel2.log
echo -e "\tFHD"
result=$(./edgeDetector_par 2 FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> parallel2.log
echo -e "\tHD"
result=$(./edgeDetector_par 2 HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> parallel2.log
echo -e "\tSD"
result=$(./edgeDetector_par 2 SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> parallel2.log
echo -e "Parallel - 4 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 4 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> parallel4.log
echo -e "\t4K"
result=$(./edgeDetector_par 4 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> parallel4.log
echo -e "\tFHD"
result=$(./edgeDetector_par 4 FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> parallel4.log
echo -e "\tHD"
result=$(./edgeDetector_par 4 HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> parallel4.log
echo -e "\tSD"
result=$(./edgeDetector_par 4 SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> parallel4.log
echo -e "Parallel - 8 thread"
echo -e "\t8K"
result=$(./edgeDetector_par 8 8k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "8k\t$result" >> parallel8.log
echo -e "\t4K"
result=$(./edgeDetector_par 8 4k.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "4k\t$result" >> parallel8.log
echo -e "\tFHD"
result=$(./edgeDetector_par 8 FHD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "FHD\t$result" >> parallel8.log
echo -e "\tHD"
result=$(./edgeDetector_par 8 HD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "HD\t$result" >> parallel8.log
echo -e "\tSD"
result=$(./edgeDetector_par 8 SD.jpg | grep 'Tiempo' | awk '{print $2}')
echo -e "SD\t$result" >> parallel8.log