#!/bin/bash
#rm final_part2.txt
#echo "Tmax: 5" >> f2_op.txt
#for (( i = 1 ; i <= 10 ; i++ ))
#do
#	./extra_f2 25 SN3Extra/tmax_5-$i.txt 5
#done

echo "" >> f2_op.txt
echo "Tmax: 10" >> f2_op.txt
for (( i = 1 ; i <= 10 ; i++ ))
do
        ./extra_f2 40 SN3Extra/tmax_10-$i.txt 10
done

#echo "" >> f2_op.txt
#echo "Tmax: 20" >> f2_op.txt
#for (( i = 1 ; i <= 10 ; i++ ))
#do
#        ./extra_f2 150 SN3Extra/tmax_20-$i.txt 20
#done

#echo "" >> f2_op.txt
#echo "Tmax: 40" >> f2_op.txt
#for (( i = 1 ; i <= 10 ; i++ ))
#do
#        ./extra_f2 250 SN3Extra/tmax_40-$i.txt 40
#done
