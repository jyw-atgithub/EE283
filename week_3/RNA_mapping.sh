#!/bin/bash

#SBATCH --job-name=RNAalign    ## Name of the job.
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1-376   ## number of tasks to launch (wc -l perfixes.txt)
#SBATCH --cpus-per-task=4    ## number of cores the job needs 

##global setting
DNApath=/pub/jenyuw/EE283/DNAseq
ATAGpath="/pub/jenyuw/EE283/ATAGseq"
RNApath="/pub/jenyuw/EE283/RNAseq"
ref_path="/pub/jenyuw/EE283/Reference"
ref_genome="$ref_path/dmel-all-chromosome-r6.13.fasta"
ref_gtf="$ref_path/dmel-all-r6.13.gtf"

##preperation
module load picard-tools/2.27.1
module load bwa/0.7.17
module load samtools/1.15.1
module load trimmomatic/0.39
module load hisat2/2.2.1

##RNAseq alignemnt
cd $RNApath

destination=${RNApath}/results/aligned_bam
echo $SLURM_ARRAY_TASK_ID
perfix=`head -n $SLURM_ARRAY_TASK_ID  ${RNApath}/raw/RNA_perfix.txt | tail -n 1`
echo ${perfix}
base_perfix=`basename $perfix`


hisat2 -p $SLURM_CPUS_PER_TASK -x ${ref_path}/dm6_trans -1 ${perfix}_R1_001.fastq.gz -2 ${perfix}_R1_001.fastq.gz |\
samtools view -bS - |\
samtools sort -@ $SLURM_CPUS_PER_TASK - -o $destination/${base_perfix}.sort.bam
