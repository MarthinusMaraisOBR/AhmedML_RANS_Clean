#!/bin/bash

gnuplot -persist > /dev/null 2>&1 << EOF
set termopt enhanced
set xrange [5:80]
set title "C_{S} vs. Time" font "Helvetica,14"
set xlabel "Time (s)" font "Helvetica,14"
set ylabel "C_{S}" font "Helvetica,14"
set tics font "Helvetica,14"
set style line 5 lt rgb "cyan" lw 3 pt 6
plot "postProcessing/forceCoeffs1/0/coefficient.dat" u 1:11 with lines lw 2 title "C_{S}",\
"postProcessing/Average/0/regionFunctionObject.dat" u 1:6 with lines lw 4 title "Mean C_{S}"

call "save_plot" "cs" "size 1600,900" # size is an argument and is optional

EOF
