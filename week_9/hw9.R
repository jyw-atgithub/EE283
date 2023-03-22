#install.packages("qqman")
library(qqman)
#vignette('qqman')
library(tidyverse)
#library(gridExtra)
#library(grid)
library(cowplot)
library(gridGraphics)
setwd("/Users/Oscar/Desktop/EE283_Adv-Bioinfo")
tab <- read.table("mal5.tsv", header=TRUE)
str(tab)
tab2 = tab %>% mutate(SNP=paste(chr,"_",pos)) %>% mutate(chr=recode(chr, "chrX"=1,"chr2L"=2,
                                                                   "chr2R"=3,"chr3L"=4,"chr3R"=5,
                                                                   "chr4"=6,"chrY"=7))
as.data.frame(table(tab2$chr))
levels(as.factor(tab2$chr))

pdf("firstplot.pdf", width=6, height=3,family="serif")
manhattan(tab2, chr = "chr", bp = "pos", p = "logp2",
          suggestiveline = -log10(1e-05),
          genomewideline = -log10(5e-08),
          chrlabs = c("X", "2L", "2R", "3L", "3R"),
          logp = FALSE, annotateTop = FALSE,
          main = "Manhattan Plot", ylim = c(0, 8),
          cex = 0.3, cex.axis = 1,
          col = c("blue3", "orange")
)
dev.off()

#annotatePval cannot co-exist with cex
par(mfrow=c(2,1),cex=0.7, mai=c(0.4,0.9,0.4,0.3))
manhattan(tab2, chr = "chr", bp = "pos", p = "logp", 
          annotatePval = 5, annotateTop = TRUE,
          chrlabs = c("X", "2L", "2R", "3L", "3R"),
          col = c("green2", "orange"), ylim = c(0, 7),
          main = "logp Plot", cex.axis = 1)
manhattan(tab2, chr = "chr", bp = "pos", p = "logp2", 
          annotatePval = 5, annotateTop = TRUE,
          chrlabs = c("X", "2L", "2R", "3L", "3R"),
          col = c("green2", "orange"),ylim = c(0, 7),
          main = "logp2 Plot")

qq(tab2$logp2, main = "Q-Q plot of GWAS p-values", 
   xlim = c(0, 4.2), ylim = c(0,7), pch = 18, 
   col = "blue4", cex = 0.5, las = 1   )
x = tab2$logp
y = tab2$logp2
# normal QQ plot in R
qqplot(x, y, xlab = "first model", ylab = "second model", main = "EmpiricalQ-Q Plot")

pdf("secondplot.pdf", width=12, height=8,family="serif")
layoutmatrix <- matrix(c(1,2,3,3), ncol=2)
layout(layoutmatrix, widths=c(2,1), heights=c(1,1))
manhattan(tab2, chr = "chr", bp = "pos", p = "logp",
          annotatePval = 5, annotateTop = TRUE,
          chrlabs = c("X", "2L", "2R", "3L", "3R"),
          col = c("green2", "orange"), ylim = c(0, 7),
          main = "logp Plot", cex.axis = 0.6)
manhattan(tab2, chr = "chr", bp = "pos", p = "logp2", 
          annotatePval = 5, annotateTop = TRUE,
          chrlabs = c("X", "2L", "2R", "3L", "3R"),
          col = c("green2", "orange"),ylim = c(0, 7),
          main = "logp2 Plot", cex.axis = 0.6)
x = tab2$logp
y = tab2$logp2
# normal QQ plot in R
qqplot(x, y, xlab = "first model", ylab = "second model", main = "EmpiricalQ-Q Plot")
dev.off()

qq(tab2$logp2, main = "Q-Q plot of GWAS p-values", 
   xlim = c(0, 4.2), ylim = c(0,7), pch = 18, 
   col = "blue4", cex = 0.5, las = 1   )

#Total <- plot_grid(p1, p2, labels = c("a", "b"), ncol = 1)

