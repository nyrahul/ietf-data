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
    set style line 1 lw 2 lc rgb '#aa0000'
    set style line 2 lw 2 lc rgb '#0000ff'
    set style line 3 lw 1 lc rgb '#aa0000' dt 2
    set style line 4 lw 1 lc rgb '#0000ff' dt 2
    set term pngcairo dashed
    "
}

plot_ctrl_overhead()
{
    tot=`column -s, -t $DCO_F | tr -s ' ' | cut -d ' ' -f $COL_DCO_RCVD | tail -n +2 | paste -sd+  | bc -q`
    dco_mean=`echo "scale=2; $tot/$sample_sz" | bc -q`
    tot=`column -s, -t $NPDAO_F | tr -s ' ' | cut -d ' ' -f $COL_NPDAO_RCVD | tail -n +2 | paste -sd+  | bc -q`
    npdao_mean=`echo "scale=2; $tot/$sample_sz" | bc -q`

    echo "
    `common_plot_lines`
    set title 'DCO vs NPDAO ctrl overhead' font ',15'
    set ylabel '#messages'
    set output '$DATADIR/dco_vs_npdao_ctrl_overhead_r$1.png'

    plot '$NPDAO_F' using $COL_ELAPTIME:$COL_NPDAO_RCVD ls 1 title 'cumulative npdao' with lines, $npdao_mean ls 3 notitle, \
         '$DCO_F' using $COL_ELAPTIME:$COL_DCO_RCVD ls 2 title 'cumulative dco' with lines, $dco_mean ls 4 notitle
    " | gnuplot
    echo "Plotted ctrl overhead"
}

plot_stale_stats()
{
    tot=`column -s, -t $DCO_F | tr -s ' ' | cut -d ' ' -f $COL_STALE_ENT | tail -n +2 | paste -sd+  | bc -q`
    dco_mean=`echo "scale=2; $tot/$sample_sz" | bc -q`
    tot=`column -s, -t $NPDAO_F | tr -s ' ' | cut -d ' ' -f $COL_STALE_ENT | tail -n +2 | paste -sd+  | bc -q`
    npdao_mean=`echo "scale=2; $tot/$sample_sz" | bc -q`

    echo "
    `common_plot_lines`
    set title 'DCO vs NPDAO stale entries stats' font ',15'
    set xlabel 'Time(sec)'
    set ylabel 'Stale Routing Entries'
    set output '$DATADIR/dco_vs_npdao_stale_stats_r$1.png'

    plot '$NPDAO_F' using $COL_ELAPTIME:$COL_STALE_ENT ls 1 title 'with NPDAO' with lines, $npdao_mean ls 3 notitle, \
         '$DCO_F' using $COL_ELAPTIME:$COL_STALE_ENT ls 2 title 'with DCO' with lines, $dco_mean ls 4 notitle
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
    sample_sz=$set1

    plot_ctrl_overhead $i
    plot_stale_stats $i
done

