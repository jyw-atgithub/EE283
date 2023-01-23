#!/bin/bash
mypath="/pub/jenyuw/EE283"
cd /pub/jenyuw/EE283
mkdir -p DNAseq/raw
mkdir -p RNAseq/raw
mkdir -p ATAGseq/raw

#for DNA sequences
cd $mypath/DNAseq/raw

for f in /data/class/ecoevo283/public/RAWDATA/DNAseq/*
do
echo $f
ln -s $f .
done

#for ATAGseq
cd $mypath/ATAGseq/raw

target="/data/class/ecoevo283/public/RAWDATA/ATACseq"
#file=$(tail -n +2 $target/README.ATACseq.txt|head -n -3)
##"tail -n +2" removes the first line; "head -n -3" removed the last 2 lines

while read -r line
do
echo $line
#Here is a complcation frmo "while read". A tab is replaced by a space, so be carefule while using "cut" finction.
barcode=$(echo $line | cut -f1 -d " ")
#echo $barcode
genotype=$(echo $line|cut -f 2 -d " ")
tissue=$(echo $line|cut -f 3 -d " ")
bio_rep=$(echo $line|cut -f 4 -d " ")

#echo "barcode is ${barcode}, genotype is $genotype, tissue is $tissue, biological replicate is $bio_rep"

read1=$(find $target/ -type f -iname "*_${barcode}_R1.fq.gz")
#echo $read1
#echo $(basename $read1)
ln -s $read1 ${barcode}.${genotype}.${tissue}.${bio_rep}.R1.fq.gz

read2=$(find $target/ -type f -iname "*_${barcode}_R2.fq.gz")
ln -s $read2 ${barcode}.${genotype}.${tissue}.${bio_rep}.R2.fq.gz

done <<< $(tail -n +2 $target/README.ATACseq.txt|head -n -3)

#for RNAseq
cd $mypath/RNAseq/raw
target="/data/class/ecoevo283/public/RAWDATA/RNAseq"

file=$(find $target -type f -iname "*.gz"|grep -v "Undetermined")

for line in $file
do

#echo -e "this is $line \n"
ln -s  $line  .

done
