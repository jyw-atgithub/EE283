#!/bin/bash

#SBATCH --job-name=hw5_1
#SBATCH -A ecoevo283
#SBATCH -p standard
#SBATCH --array=1-4
#SBATCH --cpus-per-task=6

#paths
ref_genome="/pub/jenyuw/EE283/Reference/dmel-all-chromosome-r6.13.fasta"
aligned_bam="/pub/jenyuw/EE283/DNAseq/results/aligned_bam"
processed_bam="/pub/jenyuw/EE283/DNAseq/results/processed_bam"
SNP="/pub/jenyuw/EE283/DNAseq/results/SNP"
##prep
module load java/1.8.0
module load gatk/4.2.6.1 
module load picard-tools/2.27.1  
module load samtools/1.15.1

#variables
perfix=`head -n $SLURM_ARRAY_TASK_ID  ${aligned_bam}/fullnamelist.txt | tail -n 1`


##merging and sort bams
samtools merge -@ $SLURM_CPUS_PER_TASK -o - \
${aligned_bam}/${perfix}_1.sort.bam \
${aligned_bam}/${perfix}_2.sort.bam \
${aligned_bam}/${perfix}_3.sort.bam |\
samtools sort -@ $SLURM_CPUS_PER_TASK - -o ${processed_bam}/${perfix}.sort.bam


##give readgroup info that is required by GATK
java -jar /opt/apps/picard-tools/2.27.1/picard.jar AddOrReplaceReadGroups \
I=${processed_bam}/${perfix}.sort.bam O=${processed_bam}/${perfix}.RG.bam SORT_ORDER=coordinate \
RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=${perfix} RGSM=${perfix} \
VALIDATION_STRINGENCY=LENIENT
##mark duplication, remember"REMOVE_DUPLICATES=TRUE"
java -jar /opt/apps/picard-tools/2.27.1/picard.jar MarkDuplicates REMOVE_DUPLICATES=true \
I=${processed_bam}/${perfix}.RG.bam O=${processed_bam}/${perfix}.dedup.bam M=${processed_bam}/${perfix}_marked_dup_metrics.txt
#indexing
samtools index ${processed_bam}/${perfix}.dedup.bam


##calling the SNP with GATK, Step 1: Haplotype caller (assume diploid)
##this is fucking slow
/opt/apps/gatk/4.2.6.1/gatk HaplotypeCaller --minimum-mapping-quality 30 -ERC GVCF \
--native-pair-hmm-threads 4 \
-R $ref_genome -I ${processed_bam}/${perfix}.dedup.bam -O ${SNP}/${perfix}.g.vcf.gz
