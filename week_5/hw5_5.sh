#!/bin/bash

#SBATCH --job-name=HW5_5
#SBATCH -A ecoevo283
#SBATCH -p standard
#SBATCH --array=1  ##(This is not lopped)
#SBATCH --cpus-per-task=6

## filtering the SNPs

## prep
module load  bcftools/1.15.1
module load samtools/1.15.1

SNP="/pub/jenyuw/EE283/DNAseq/results/SNP"


##calling the SNP with GATK, Step 4: merge the split genome
java -jar /opt/apps/picard-tools/2.27.1/picard.jar MergeVcfs \
$(printf 'I=%s ' ${SNP}/result.*.vcf.gz) O=${SNP}/all_variants.vcf.gz

wait

## filtering the SNPs
bcftools filter -i 'FS<40.0 && SOR<3 && MQ>40.0 && MQRankSum>-5.0 && MQRankSum<5 && QD>2.0 && ReadPosRankSum>-4.0 && INFO/DP<16000' \
-O z -o - \
${SNP}/all_variants.vcf.gz |\
bcftools filter --threads $SLURM_CPUS_PER_TASK -S . -e 'FMT/DP<3 | FMT/GQ<20' -O z -o - - |\
bcftools filter --threads $SLURM_CPUS_PER_TASK -e 'AC==0 || AC==AN' --SnpGap 10 -o - - |\
bcftools view --threads $SLURM_CPUS_PER_TASK -m2 -M2 -v snps -O z -o ${SNP}/all_variants_filtered.vcf.gz
## indexing
tabix -p vcf ${SNP}/all_variants_filtered.vcf.gz