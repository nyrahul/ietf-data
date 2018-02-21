#!/bin/bash

#num  tot_nodes  lf_nodes  unconn_nodes  stale_entries  tot_par_sw  elap_time  dao_sent  dao_rcvd  npdao_sent  npdao_rcvd  dco_sent  dco_rcvd  udp_sent  udp_rcvd
#1    100        49        15            77             48          120        294       1674      0           0           40        165       155       152

finish()
{
    [[ -f "$TMP_F" ]] && rm $TMP_F
    echo "bye"
}
trap finish EXIT

usage()
{
    echo "Usage: $0 <data_dir> ... data_dir should contain csv files"
    exit
}

COL_ELAPTIME=7
COL_DCO_RCVD=13
COL_NPDAO_RCVD=11
COL_STALE_ENT=5

DATADIR="$1"

[[ ! -d $DATADIR ]] && usage

TMP_F=tmp_$$.tmp

common_plot_lines()
{
    echo "
    set datafile separator ','
    set key autotitle columnhead
    set key left
    set xlabel 'Time(sec)'
    set style line 1 lw 2
    set style line 2 lw 2
    set term png
    "
}

plot_ctrl_overhead()
{
    echo "
    `common_plot_lines`
    set title 'DCO vs NPDAO ctrl overhead' font ',15'
    set ylabel '#msgs'
    set output '$DATADIR/dco_vs_npdao_ctrl_overhead_r$1.png'

    plot '$NPDAO_F' using $COL_ELAPTIME:$COL_NPDAO_RCVD ls 1 title 'cumulative npdao' with lines, \
         '$DCO_F' using $COL_ELAPTIME:$COL_DCO_RCVD ls 2 title 'cumulative dco' with lines
    " | gnuplot
    echo "Plotted ctrl overhead"
}

plot_stale_stats()
{
    echo "
    `common_plot_lines`
    set title 'DCO vs NPDAO stale entries stats' font ',15'
    set xlabel 'Time(sec)'
    set ylabel 'Stale Routing Entries'
    set output '$DATADIR/dco_vs_npdao_stale_stats_r$1.png'

    plot '$NPDAO_F' using $COL_ELAPTIME:$COL_STALE_ENT title 'with NPDAO' with lines, \
         '$DCO_F' using $COL_ELAPTIME:$COL_STALE_ENT title 'with DCO' with lines
    " | gnuplot
    echo "Plotted stale stats"
}

for((i=0;i<5;i++)); do
    DCO_F=$DATADIR/dco_$i.csv
    NPDAO_F=$DATADIR/npdao_$i.csv

    [[ ! -f $DCO_F ]] && continue
    [[ ! -f $NPDAO_F ]] && continue
    
    set1=`wc -l $DCO_F | cut -d ' ' -f 1`
    set2=`wc -l $NPDAO_F | cut -d ' ' -f 1`
    
    [[ $set1 -ne $set2 ]] && echo "Data set sample size differs dco=$set1 npdao=$set2" && continue

    plot_ctrl_overhead $i
    plot_stale_stats $i
done

