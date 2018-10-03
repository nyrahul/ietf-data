set xtics ("40s256B" 1,"80s512B" 2,"160s1024B" 3)
set term pngcairo lw 2
set title "MAC transmit failure comparision"
set output "macfail.png"
set xlabel  "scenario"
set ylabel  "MAC Failure count"
plot "macfail.csv" using 1:2 title 'PerHopReassembly' with linespoints, '' using 1:3 title 'FragFwdingNoPacing' with linespoints, '' using 1:4 title 'FragFwdingPacing50ms' with linespoints, '' using 1:5 title 'FragFwdingPacing100ms' with linespoints
