install.packages("cli")
install.packages("Rtools")

install.packages("tidyverse")
install.packages("BiocManager", force=TRUE)
BiocManager::install("ATACseqQC", force=TRUE)
# while at it, lets install DEseq2
BiocManager::install("DESeq2")

setwd("/Users/Oscar/Desktop/EE283_Adv-Bioinfo")

## load the library
library("ATACseqQC")
# load a bamfile in the working directory
bamfile <- "A4.ED.2.dedup.bam"
# BAM file name
bamfile.labels <- gsub(".dedup.bam", "", basename(bamfile))
# generate fragement size distribution
fragSize <- fragSizeDist(bamfile, bamfile.labels)
estimateLibComplexity(readsDupFreq(bamfile, index=bamfile))