set datafile separator ","
set xlabel "Inner Iteration"
set ylabel "log10(Residuo)"
set grid
set title "Convergenza residui"
set key outside
plot 'history.csv' using 3:4  with lines lw 2 title 'rms Rho (Ar)', \
     ''             using 3:5  with lines lw 2 title 'rms Rho (H2)', \
     ''             using 3:6  with lines lw 2 title 'rms Rho (H)', \
     ''             using 3:7  with lines lw 2 title 'rms RhoU', \
     ''             using 3:8  with lines lw 2 title 'rms RhoV', \
     ''             using 3:9  with lines lw 2 title 'rms RhoE', \
     ''             using 3:10 with lines lw 2 title 'rms RhoEve'
pause -1 "Premi invio per chiudere"
