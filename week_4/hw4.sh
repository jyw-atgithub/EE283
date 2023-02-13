#!/bin/bash


#SBATCH --job-name=Q123&4    ## Name of the job.
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1-6   ## number of tasks to launch (wc -l perfixes.txt)
#SBATCH --cpus-per-task=2    ## number of cores the job needs 
: <<'SKIP'
SKIP

DNA_bam="/pub/jenyuw/EE283/DNAseq/results/aligned_bam"
extract="/pub/jenyuw/EE283/DNAseq/results/extraction_w4"
assemble_um="/pub/jenyuw/EE283/DNAseq/results/assemble_unmapped"
coverage="/pub/jenyuw/EE283/DNAseq/results/coverage"

## prep
module load samtools/1.15.1 bedtools2/2.30.0
file=`head -n $SLURM_ARRAY_TASK_ID $DNA_bam/namelist.txt | tail -n 1`
perfix=$(basename $file|sed 's/.sort.bam//')


## extracting reads
samtools index -@ $SLURM_CPUS_PER_TASK -b $file
samtools view -@ $SLURM_CPUS_PER_TASK -q 30 --bam -o $extract/${perfix}.X.bam $file X:1880000-2000000 
samtools view -@ $SLURM_CPUS_PER_TASK  -f 4 -F 8 --bam -o $extract/${perfix}.unmapped.bam $file X:1880000-2000000 

##transfrom bam to fastq
bedtools bamtofastq -i $extract/${perfix}.unmapped.bam -fq $extract/${perfix}.unmapped.1.fq
gzip -f $extract/${perfix}.unmapped.1.fq

##assemble the unmapped read
source ~/.bashrc
conda activate SPAdes
mkdir -p $assemble_um/${perfix}
spades.py -o $assemble_um/${perfix} -s $extract/${perfix}.unmapped.1.fq.gz


source ~/.bashrc
conda activate deeptools
samtools index -@ $SLURM_CPUS_PER_TASK -b ${extract}/${perfix}.X.bam
bamCoverage -b ${extract}/${perfix}.X.bam -o ${coverage}/${perfix}.X.bw --outFileFormat bigwig --normalizeUsing RPKM --binSize 10
bamCoverage -b ${extract}/${perfix}.X.bam -o ${coverage}/${perfix}.Xe.bw --outFileFormat bigwig --normalizeUsing RPKM --binSize 10 --extendReads

#samtools view -@ 8 -q 30 ADL06_1.sort.bam X:1880000-2000000
#samtools view -@ 8 -q 30 -o $extract/$(echo ADL06_1.sort.bam |sed 's/ADL06/A4/ ; s/ADL09/A5/; s/.sort.bam//').X2.bam ADL06_1.sort.bam X:1880000-2000000 
#samtools view -@ 8 -f 4 -F 8 --bam -o $extract/$(echo ADL06_1.sort.bam|sed 's/.sort.bam//').unmapped.bam ADL06_1.sort.bam X:1880000-2000000 
