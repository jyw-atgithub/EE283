#!/bin/bash
##This contains everything needed to be done only once ahead.

: <<'SKIP'
1.  The DNA samples were given arbitrary labels so
        A4 = ADL06
        A5 = ADL09
        A6 = ADL10
        A7 = ADL14

SKIP

DNA_bam="/pub/jenyuw/EE283/DNAseq/results/aligned_bam"
ls $DNA_bam/*.bam |grep -E 'ADL06|ADL09' > $DNA_bam/namelist.txt
