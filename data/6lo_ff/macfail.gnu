set xtics ("40s256B" 1,"80s512B" 2,"160s1024B" 3)
set term png
set title "MAC transmit failure comparision"
set output "macfail.png"
set xlabel  "scenario"
set ylabel  "MAC Failure count"
plot "macfail.csv" using 1:2 title 'PerHopReassembly' with linespoints lw 3, '' using 1:3 title 'FragFwding' with linespoints lw 3, '' using 1:4 title 'FragFwdingPacing50ms' with linespoints lw 3
