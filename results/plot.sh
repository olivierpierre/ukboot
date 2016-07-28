#!/bin/sh

TITLE="Unikernels boot time"

if [ "$1" == "" ]; then
	echo "Usage: $0 <result file>"
	exit -1
fi

if [ ! -e $1 ]; then
	echo "ERROR: $1 does not exist"
	exit -2
fi

gnuplot -persist <<-EOFMarker
    set title "$TITLE"
    set term png
    set output "./$1.png"
    set datafile separator ";"
    set datafile commentschars "#"
    set grid
    set y2tics
    
    set ylabel "Phase1 durantion - usec"
    set y2label "Phase2 durantion - cycles"
    
    plot "./$1" using 1:2 with linespoints axes x1y1 ti "Phase1", "./$1" using 1:3 with linespoints axes x1y2 ti "Phase2"
EOFMarker
