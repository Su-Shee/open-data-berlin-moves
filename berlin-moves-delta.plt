# people moved in and out of berlin

reset

set terminal pngcairo size 800,600 enhanced font "Verdana, 10"
set output "berlin-moves.png"

set title  "People moving from and to Berlin" font "Verdana, 14"
set ylabel "numbers in thousands" font "Verdana, 12"
set xlabel "year" font "Verdana, 12"

set style line 1 lt 1 lc rgb "#ab003c"
set style line 2 lt 1 lc rgb "#006b55"
set style line 3 lt 1 lc rgb "#7f7f5f"

set style fill solid
set boxwidth 0.7
set grid ytics linestyle 3

set style histogram
set style data histogram
set yrange [-45:45]

unset key # don't display a legend

set lmargin at screen 0.08
set bmargin at screen 0.1

plot "berlin-moves-data.dat" using 1:4:($4 > 0 ? 1 : 2) with boxes lc variable, \
     "berlin-moves-data.dat" using 1:($4 > 0 ? $4 + 1.4 : $4 - 1.2):4 with labels font "Verdana, 8"

