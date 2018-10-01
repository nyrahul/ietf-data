set xtics ("40s256B" 1,"80s512B" 2,"160s1024B" 3)
set xlabel  "scenario"
set ylabel  "latency in ms"
plot "latency.csv" using 1:2 title 'PerHopReassembly' with linespoints lw 3, '' using 1:3 title 'FragFwding' with linespoints lw 3
