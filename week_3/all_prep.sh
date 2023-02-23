#!/bin/bash
##This contains everything needed to be done only once ahead.
##1. collecting the pefix of files
##2. index the genome
DNApath=/pub/jenyuw/EE283/DNAseq
ATACpath="/pub/jenyuw/EE283/ATACseq"
RNApath="/pub/jenyuw/EE283/RNAseq"
ref_path="/pub/jenyuw/EE283/Reference"
ref_genome="$ref_path/dmel-all-chromosome-r6.13.fasta"
ref_gtf="$ref_path/dmel-all-r6.13.gtf"

##DNAseq
cd $DNApath
mkdir -p scripts results results/aligned_bam

ls $DNApath/raw/*_1.fq.gz | sed 's/_1.fq.gz//g' > ${DNApath}/raw/prefix.txt
head -n 10 ${DNApath}/raw/prefix.txt

##ATACseq
cd $ATACpath
mkdir -p scripts results/aligned_bam

ls $ATACpath/raw/*.R1.fq.gz | sed 's/.R1.fq.gz//g' > $ATACpath/raw/ATAC_perfix.txt
head -n 10 $ATACpath/raw/ATAC_perfix.txt

##RNAseq
cd $RNApath
mkdir -p scripts results/aligned_bam
ls $RNApath/raw/*_R1_001.fastq.gz | sed 's/_R1_001.fastq.gz//g' > $RNApath/raw/RNA_perfix.txt


##preperation
module load picard-tools/2.27.1
module load bwa/0.7.17
module load samtools/1.15.1
module load trimmomatic/0.39
module load hisat2/2.2.1


##indexing for genome
bwa index $ref_genome
samtools faidx $ref_genome
java -jar /opt/apps/picard-tools/2.27.1/picard.jar CreateSequenceDictionary \
R=$ref_genome O=${ref_genome}.dict
#indexing for RNA
python /opt/apps/hisat2/2.2.1/bin/hisat2_extract_splice_sites.py $ref_gtf > $ref_path/dm6.ss
python /opt/apps/hisat2/2.2.1/bin/hisat2_extract_exons.py $ref_gtf > $ref_path/dm6.exon
hisat2-build -p 8 --exon dm6.exon --ss dm6.ss $ref_genome $ref_path/dm6_trans
