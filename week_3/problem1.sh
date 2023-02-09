#!/bin/bash

##for Problem 1, Week3

#SBATCH --job-name=test    ## Name of the job.
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1   ## number of tasks to launch (wc -l perfixes.txt)
#SBATCH --cpus-per-task=2    ## number of cores the job needs 

DNApath="/pub/jenyuw/EE283/DNAseq"
trimmed="/pub/jenyuw/EE283/DNAseq/results/trimmed"
destination="/pub/jenyuw/EE283/DNAseq/results/fastQC"
trimmomatic="/opt/apps/trimmomatic/0.39"

module load fastqc/0.11.9
module load trimmomatic/0.39

#gunzip -dk ADL06_1_{1,2}.original.fq.gz

#fastqc -o $destination ${DNApath}/raw/ADL06_1_{1,2}.original.fq

#trimming
:<SKIP
java -jar /opt/apps/trimmomatic/0.39/trimmomatic-0.39.jar PE -threads 8 -phred33 \
${DNApath}/raw/ADL06_1_1.original.fq ${DNApath}/raw/ADL06_1_2.original.fq \
-baseout ${trimmed}/ADL06_1.trimmed \
ILLUMINACLIP:${trimmomatic}/adapters/TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:20
SKIP


fastqc -o $destination ${trimmed}/ADL06_1.trimmed_{1,2}P
