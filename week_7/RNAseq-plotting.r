library(tidyverse)
library( "gplots" )
library( "RColorBrewer" )
library( "genefilter" )


mytab = read_tsv("RNAseq.samcode.txt")
mytab
# SampleNumber_i7index_Lane.sort.bam
mytab2 <- mytab %>%
	select(RILcode, TissueCode, Replicate, FullSampleName, SampleNumber, i7index, Lane)
	
table(mytab2$RILcode)
table(mytab2$TissueCode)
table(mytab2$Replicate)

mytab2 <- mytab %>%
	filter(RILcode %in% c(21148, 21286, 22162, 21297, 21029, 22052, 22031, 21293, 22378, 22390)) %>%
	filter(TissueCode %in% c("B", "E")) %>%
	filter(Replicate == "0")

for(i in 1:nrow(mytab2)){
  cat("/pub/jenyuw/EE283/RNAseq/results/aligned_bam/", 
  mytab2$SampleNumber[i], "_", mytab2$i7index[i], "_", mytab2$Lane[i], ".sort.bam\n", 
  file="shortRNAseq.names.txt",append=TRUE,sep='')
	}

write_tsv(mytab2,"shortRNAseq.txt")

## After having the fly_counts.txt and fly_counts.txt.summary

library( "DESeq2" )
sampleInfo = read.table("shortRNAseq.txt", header=TRUE)
sampleInfo$FullSampleName = as.character(sampleInfo$FullSampleName)

## I am assuming feature counts finished
countdata = read.table("fly_counts.txt", skip = 1, header=TRUE, row.names=1)
# Remove first five columns (chr, start, end, strand, length)
# or do it the tidy way
countdata = countdata[ ,6:ncol(countdata)]
#countdata = countdata %>% select(-c(1:6))
temp = colnames(countdata)
temp = gsub("X.pub.jenyuw.EE283.RNAseq.results.aligned_bam.","",temp)
temp = gsub(".sort.bam","",temp)
colnames(countdata) = temp


#cbind(temp,sampleInfo$FullSampleName,temp == sampleInfo$FullSampleName)
#of course, it returns false

dds = DESeqDataSetFromMatrix(countData=countdata, colData=sampleInfo, design=~TissueCode)
# the column names of "countData" don't have to match the content of one column in "colData" 
## It is very important
dds <- DESeq(dds)
res <- results( dds )
res

pdf("res.pdf", width=4 , height=4)
plotMA( res, ylim = c(-1, 1) )
dev.off()

pdf("dds.pdf", width=4 , height=4)
plotDispEsts( dds )
dev.off()

pdf("hist.pdf", width=4 , height=4)
hist( res$pvalue, breaks=20, col="grey" )
dev.off()

rld = rlog( dds )
head( assay(rld) )
mydata = assay(rld)
sampleDists = dist( t( assay(rld) ) )

sampleDistMatrix = as.matrix( sampleDists )
rownames(sampleDistMatrix) = rld$TissueCode
colnames(sampleDistMatrix) = NULL

colours = colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)

pdf("heatmap.pdf", width=4 , height=4)
heatmap.2( sampleDistMatrix, trace="none", col=colours)
dev.off()

pdf("PCA.pdf", width=5 , height=3)
print( plotPCA( rld, intgroup = "TissueCode") )
dev.off()

pdf("heatmap2.pdf", width=8 , height=6)
heatmap.2( assay(rld)[ topVarGenes, ], margins = c(10, 10), cexRow=0.7, cexCol=0.5, scale="row", trace="none", dendrogram="column", col = colorRampPalette( rev(brewer.pal(9, "RdBu")) )(255))
dev.off()

ggplot(data=res, aes(x=log2FoldChange, y=pvalue)) + geom_point()

##Failed 
##BiocManager::install('EnhancedVolcano')
library('ggplot2')
tmp <- readRDS("de_df_for_volcano.rds")
de <- tmp[complete.cases(tmp), ]
ggplot(data=de, aes(x=log2FoldChange, y=pvalue)) + geom_point()

p <- ggplot(data=de, aes(x=log2FoldChange, y=-log10(pvalue))) + geom_point() + theme_minimal()

# add a column of NAs
de$diffexpressed <- "NO"
# if log2Foldchange > 0.6 and pvalue < 0.05, set as "UP" 
de$diffexpressed[de$log2FoldChange > 0.6 & de$pvalue < 0.05] <- "UP"
# if log2Foldchange < -0.6 and pvalue < 0.05, set as "DOWN"
de$diffexpressed[de$log2FoldChange < -0.6 & de$pvalue < 0.05] <- "DOWN"

p <- ggplot(data=de, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed)) + geom_point() + theme_minimal()

de$delabel <- NA
de$delabel[de$diffexpressed != "NO"] <- de$gene_symbol[de$diffexpressed != "NO"]

ggplot(data=de, aes(x=log2FoldChange, y=-log10(pvalue), col=diffexpressed, label=delabel)) + 
    geom_point() + 
    theme_minimal() +
    geom_text()