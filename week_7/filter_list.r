library(tidyverse)
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