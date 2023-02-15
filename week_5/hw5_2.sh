#!/bin/bash

#SBATCH --job-name=HW5_2
#SBATCH -A ecoevo283
#SBATCH -p standard
#SBATCH --array=1-7 ##(because chrome.names.txt contains 7 chromosome arms)
#SBATCH --cpus-per-task=4


module load bcftools/1.15.1
module load samtools/1.15.1
module load java/1.8.0
module load gatk/4.2.6.1
module load picard-tools/2.27.1
module load samtools/1.15.1

ref_genome="/pub/jenyuw/EE283/Reference/dmel-all-chromosome-r6.13.fasta"
ref_path="/pub/jenyuw/EE283/Reference"
SNP="/pub/jenyuw/EE283/DNAseq/results/SNP"


mychr=`head -n $SLURM_ARRAY_TASK_ID ${ref_path}/chrome.names.txt | tail -n 1`

##calling the SNP with GATK, Step 3: really call the SNPs from merged GVCF
##we only care about major chromosomes
/opt/apps/gatk/4.2.6.1/gatk --java-options "-Xmx3g" GenotypeGVCFs \
--intervals $mychr -stand-call-conf 5 \
-R $ref_genome -V ${SNP}/allsample.g.vcf.gz \
-O ${SNP}/result.${mychr}.vcf.gz

wait

if XXXX in $(squeue -u jenyuw)
then
fi


if [ $SLURM_ARRAY_TASK_ID = 7 ]
then
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
fi

