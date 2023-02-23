#!/bin/bash

#SBATCH --job-name=Q1     ## Name of the job.
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1-6   ## number of tasks to launch (wc -l perfixes.txt)
#SBATCH --cpus-per-task=4    ## number of cores the job needs 

##alignment post-processing
##path
atac_bam="/pub/jenyuw/EE283/ATACseq/results/aligned_bam"
pro_bam="/pub/jenyuw/EE283/ATACseq/results/processed_bam"

#prep
module load samtools/1.15.1
module load picard-tools/2.27.1

file=`head -n $SLURM_ARRAY_TASK_ID ${atac_bam}/atac-A4-list.txt | tail -n 1`
prefix=$(basename $file|sed 's/.sort.bam// ; s/P.*.A/A/')

samtools index -@ $SLURM_CPUS_PER_TASK ${file}
samtools view -@ $SLURM_CPUS_PER_TASK -q 30 -b ${file} X 2L 2R 3L 3R Y 4 > ${pro_bam}/${prefix}.Q30.bam

# remove PCR duplicates
java -jar /opt/apps/picard-tools/2.27.1/picard.jar MarkDuplicates \
I=${pro_bam}/${prefix}.Q30.bam \
O=${pro_bam}/${prefix}.dedup.bam \
M=${pro_bam}/${prefix}.marked_dup_metrics.txt \
REMOVE_DUPLICATES=true