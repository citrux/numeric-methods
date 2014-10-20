#!/bin/bash

if [[ -f $1 ]]; then
    gnuplot -e "plot '$1' using 1:2 title 'euler',\
                     '$1' using 1:3 title 'pceuler';\
                 pause -1"
else
    echo "Файл не найден"
fi
