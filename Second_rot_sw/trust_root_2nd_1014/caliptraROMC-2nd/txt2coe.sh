#!/bin/bash

cd $1
pwd

rm -rf $3

echo "memory_initialization_radix=16;" > $3
echo "memory_initialization_vector=" >> $3

awk '{  
    len = length($0);  
    if (len > 0) {
        padded = (len % 2 == 0) ? $0 : substr($0 "0", 1, len+1);  
        for (i=length(padded); i>0; i-=2)   
            printf "%s", substr(padded, i-1, 2);  
        printf "\n";  
    } 
}' "$2" >> "$3" 




