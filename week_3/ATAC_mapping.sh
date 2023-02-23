#!/bin/bash

#SBATCH --job-name=test    ## Name of the job.
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1-24   ## number of tasks to launch (wc -l prefixes.txt)
#SBATCH --cpus-per-task=4    ## number of cores the job needs 

##global setting
DNApath="/pub/jenyuw/EE283/DNAseq"
ATACpath="/pub/jenyuw/EE283/ATACseq"
RNApath="/pub/jenyuw/EE283/RNAseq"
ref_path="/pub/jenyuw/EE283/Reference"
ref_genome="$ref_path/dmel-all-chromosome-r6.13.fasta"
trimmomatic="/opt/apps/trimmomatic/0.39"

##preperation
module load picard-tools/2.27.1
module load bwa/0.7.17
module load samtools/1.15.1
module load trimmomatic/0.39

##ATACseq
cd $ATACpath
trimmed=${ATACpath}/results/trimmed_fq
destination=${ATACpath}/results/aligned_bam
echo $SLURM_ARRAY_TASK_ID
prefix=`head -n $SLURM_ARRAY_TASK_ID  ${ATACpath}/raw/ATAC_perfix.txt | tail -n 1`
echo $prefix
base_prefix=`basename $prefix`


#if do not trim
#bwa mem -M -t $SLURM_CPUS_PER_TASK $ref_genome ${prefix}.R1.fq.gz ${prefix}.R2.fq.gz | samtools view -bS - |\
#samtools sort -@ $SLURM_CPUS_PER_TASK - -o $destination/${base_prefix}.sort.bam

#trimming
java -jar /opt/apps/trimmomatic/0.39/trimmomatic-0.39.jar PE -threads $SLURM_CPUS_PER_TASK -phred33 \
${prefix}.R1.fq.gz ${prefix}.R2.fq.gz \
–baseout ${trimmed}/${base_prefix} \
ILLUMINACLIP:${trimmomatic}/adapters/TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:20



##ATACseq mapping to USCS-version Reference genome
ref_genome2="/pub/jenyuw/EE283/Reference"
trimmed=${ATACpath}/results/trimmed_fq 
destination=${ATACpath}/results/aligned_bam
echo $SLURM_ARRAY_TASK_ID

bwa mem -M -t $SLURM_CPUS_PER_TASK ${ref_genome2} ${trimmed}/${base_prefix}.1P ${trimmed}/${base_prefix}.2P | samtools view -bhS - |\
samtools sort -@ $SLURM_CPUS_PER_TASK - -o $destination/${base_prefix}.sort2.bam

