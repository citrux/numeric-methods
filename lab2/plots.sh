#!/bin/bash

if [[ -f $1 ]]; then
    gnuplot -e "plot '$1' using 1:2 title columnheader(2) with lines,\
                     '$1' using 1:3 title columnheader(3) with lines,\
                     '$1' using 1:4 title columnheader(4) with lines,\
                     '$1' using 1:5 title columnheader(5) with lines;\
                 pause -1"
else
    echo "Файл не найден"
fi
