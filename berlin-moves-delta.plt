# berlin moves deltachart
reset
set style line 1 lt 1 lc rgb "green"
set style line 2 lt 1 lc rgb "red"
set style fill solid
set grid ytics linestyle 1
set style histogram
set style data histogram
set title  'people moving to and from Berlin'
set ylabel 'number in thousands'
set xlabel 'year'
set yrange [-45:45]
set boxwidth 0.5
plot 'berlin-moves-data.dat'  using 1:4:($4 > 0 ? 1 : 2) with boxes lc variable

