#!/bin/bash

#SBATCH --job-name=HW5_3
#SBATCH -A ecoevo283
#SBATCH -p standard
#SBATCH --array=1-7 ##(because chrome.names.txt contains 7 chromosome arms)
#SBATCH --cpus-per-task=1

#path
ref_genome="/pub/jenyuw/EE283/Reference/dmel-all-chromosome-r6.13.fasta"
ref_path="/pub/jenyuw/EE283/Reference"
SNP="/pub/jenyuw/EE283/DNAseq/results/SNP"

#prep
module load bcftools/1.15.1
module load samtools/1.15.1
module load java/1.8.0
module load gatk/4.2.6.1
module load picard-tools/2.27.1

#perfix
mychr=`head -n $SLURM_ARRAY_TASK_ID ${ref_path}/chrome.names.txt | tail -n 1`

##calling the SNP with GATK, Step 3: really call the SNPs from merged GVCF
##we only care about major chromosomes
/opt/apps/gatk/4.2.6.1/gatk --java-options "-Xmx3g" GenotypeGVCFs \
--intervals $mychr -stand-call-conf 5 \
-R $ref_genome -V ${SNP}/allsample.g.vcf.gz \
-O ${SNP}/result.${mychr}.vcf.gz

wait
