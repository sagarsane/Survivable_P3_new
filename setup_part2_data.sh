#!/bin/bash
rm final_part2.txt
for (( i = 1 ; i <= 9 ; i++ ))
do
	for (( j = 1 ; j <= 9 ; j++  ))
	do
		if [ $i -ne $j ]
		then
			./edge_disjoint part2_input.txt $i $j >> temp_ij.txt
			./remove_edge temp_ij.txt part2_input.txt
			rm temp_ij.txt
			./edge_disjoint tempGraph.txt $i $j
			rm tempGraph.txt
			echo " " >> final_part2.txt
		fi
	done
done

