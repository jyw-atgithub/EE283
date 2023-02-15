#!/bin/bash

## for first sbatch submission
## retrive sample names
aligned_bam="/pub/jenyuw/EE283/DNAseq/results/aligned_bam"
ls $aligned_bam/*.bam |gawk -F / '{print $8}'| gawk -F _ '{print $1}'| sort -h |uniq > ${aligned_bam}/fullnamelist.txt

## for second sbatch submission
##calling the SNP with GATK, Step 0: prepare the chromosome name list for fater process
ref_genome="/pub/jenyuw/EE283/Reference/dmel-all-chromosome-r6.13.fasta"
ref_path="/pub/jenyuw/EE283/Reference"
cat $ref_genome | grep ">" | cut -f 1 -d " " | tr -d ">" | head -n 7 > ${ref_path}/chrome.names.txt