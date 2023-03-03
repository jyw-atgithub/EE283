#!/bin/bash
ref_gtf="/pub/jenyuw/EE283/Reference/dmel-all-r6.13.gtf"
results="/pub/jenyuw/EE283/RNAseq/results"


module load subread/2.0.3
# the gtf should match the genome you aligned to
# coordinates and chromosome names
# the program expects a space delimited set of files...

myfile=`cat /pub/jenyuw/EE283/RNAseq/shortRNAseq.names.txt | tr "\n" " "`
featureCounts -p -T 8 -t exon -g gene_id -Q 30 -F GTF -a ${ref_gtf} -o ${results}/fly_counts.txt $myfile

