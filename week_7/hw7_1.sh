#!/bin/bash
ref_gtf="/pub/jenyuw/EE283/Reference"


module load subread/2.0.3
# the gtf should match the genome you aligned to
# coordinates and chromosome names

# the program expects a space delimited set of files...
RNAseq/bam/21148B0.bam
SampleNumber_i7index_Lane.sort.bam
211_GCTGTCA_L005.sort.bam

myfile=`cat /pub/jenyuw/EE283/RNAseq/shortRNAseq.names.txt | tr "\n" " "` | sed 's@RNAseq\/bam\/@@g'
featureCounts -p -T 8 -t exon -g gene_id -Q 30 -F GTF -a ${ref_gtf} -o fly_counts.txt $myfile