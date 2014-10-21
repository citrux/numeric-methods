#!/bin/bash

if [[ -f $1 ]]; then
    gnuplot -e "plot '$1' using 1:2 title columnheader(2),\
                     '$1' using 1:3 title columnheader(3),\
                     '$1' using 1:4 title columnheader(4);\
                 pause -1"
else
    echo "Файл не найден"
fi
