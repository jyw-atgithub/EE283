#!/bin/bash

#SBATCH --job-name=hw5_2
#SBATCH -A ecoevo283
#SBATCH -p standard
#SBATCH --array=1
#SBATCH --cpus-per-task=6

#paths
ref_genome="/pub/jenyuw/EE283/Reference/dmel-all-chromosome-r6.13.fasta"
aligned_bam="/pub/jenyuw/EE283/DNAseq/results/aligned_bam"
processed_bam="/pub/jenyuw/EE283/DNAseq/results/processed_bam"
SNP="/pub/jenyuw/EE283/DNAseq/results/SNP"
##prep
module load java/1.8.0
module load gatk/4.2.6.1 


#variables
perfix=`head -n $SLURM_ARRAY_TASK_ID  ${aligned_bam}/fullnamelist.txt | tail -n 1`


##calling the SNP with GATK, Step 2: merge the GVCF files
##this is not looped so set --array=1. We must wait for all the GVCF are generated


/opt/apps/gatk/4.2.6.1/gatk CombineGVCFs -R $ref_genome $(printf -- '-V %s ' ${SNP}/*.g.vcf.gz) -O ${SNP}/allsample.g.vcf.gz
fi

## Syntax: $printf [-v var] format [arguments]
## The -- is used to tell the program that whatever follows should not be interpreted as a command line option to 'printf'.
## %s specifier: It is basically a string specifier for string output
