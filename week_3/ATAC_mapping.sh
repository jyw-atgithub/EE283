#!/bin/bash

#SBATCH --job-name=test    ## Name of the job.
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1-24   ## number of tasks to launch (wc -l prefixes.txt)
#SBATCH --cpus-per-task=4    ## number of cores the job needs 

##global setting
DNApath="/pub/jenyuw/EE283/DNAseq"
ATAGpath="/pub/jenyuw/EE283/ATAGseq"
RNApath="/pub/jenyuw/EE283/RNAseq"
ref_path="/pub/jenyuw/EE283/Reference"
ref_genome="$ref_path/dmel-all-chromosome-r6.13.fasta"

##preperation
module load picard-tools/2.27.1
module load bwa/0.7.17
module load samtools/1.15.1
module load trimmomatic/0.39

##ATAGseq
cd $ATAGpath
trimmed=${ATAGpath}/results/trimmed_fq
destination=${ATAGpath}/results/aligned_bam
echo $SLURM_ARRAY_TASK_ID
prefix=`head -n $SLURM_ARRAY_TASK_ID  ${ATAGpath}/raw/ATAG_perfix.txt | tail -n 1`
echo $prefix
base_prefix=`basename $prefix`

#java -jar /opt/apps/trimmomatic/0.39/trimmomatic-0.39.jar PE -threads $SLURM_CPUS_PER_TASK -phred33 \
#${ATAGpath}/raw/${prefix}.R1.fq.gz ${ATAGpath}/raw/${prefix}.R2.fq.gz –baseout ${trimmed}/${perfix}\
#ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:20

#if do not trim
bwa mem -M -t $SLURM_CPUS_PER_TASK $ref_genome ${prefix}.R1.fq.gz ${prefix}.R2.fq.gz | samtools view -bS - |\
samtools sort -@ $SLURM_CPUS_PER_TASK - -o $destination/${base_prefix}.sort.bam
