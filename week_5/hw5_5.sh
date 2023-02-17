#!/bin/bash
#!/bin/bash

##path
SNP="/pub/jenyuw/EE283/DNAseq/results/SNP"
dest="/pub/jenyuw/EE283/DNAseq/results/extraction_w5"

##prep
module load bcftools/1.15.1
module load vcftools/0.1.16

##extract the first 1M of chromosome X

bcftools view  -O v --threads 4 ${SNP}/all_variants_filtered.vcf.gz X:1-1000000 |\
bcftools query -f '[%GT] \n' |\
tr "|" "\/" | sed -r 's/(.{3})/\1\t/g' > ${dest}/genotype.txt


vcftools --chr X --from-bp 1 --to-bp 1000000 --out out --012 --gzvcf ${SNP}/all_variants_filtered.vcf.gz 

#cut -f 10,11,12,13