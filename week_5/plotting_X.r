setwd("/Users/Oscar/Desktop/EE283_Adv-Bioinfo")
tab0 <- read.table("out.012",header=FALSE, sep="\t")
tab1 <- as.data.frame(t(tab0))[-1,]
colnames(tab1) <- c("ADL06","ADL09","ADL10","ADL14")
row.names(tab1) <- paste("row", (1:nrow(tab1)))

tab2 <-tab1[,tab1$ADL06 == 0]

mtx1 <- as.matrix(tab1)
image(mtx1, col=c("green","yellow","red"), breaks=c(-0.5,0.5,1.5,2.5))


tab2 <- as.data.frame(tab0)[,-1]
mtx2 <- as.matrix(tab2)
#y <- c(0:3)
#x <- c(-1:2)
image(mtx2, col=c("green","yellow","red"), breaks=c(-0.5,0.5,1.5,2.5))

#heatmap(tab1, scale="column")

library(ggplot2)
library(reshape)

mtab <- melt(mtx1)
mtab$value=as.factor(mtab$value)

p <- ggplot(mtab, aes(x = X1, y = X2, fill=value))
p+geom_tile()


p+scale_discrete_manual(aes(values = c('1'='blue', 'green', 'red','black')))
p+ scale_fill_manual(values = c('blue', 'green', 'red','black'))
p +  geom_tile(aes(fill=factor(value)))
p+ scale_fill_manual(values = c('blue', 'green', 'pink','black'))
p+ scale_color_manual(values = c('0' = 'blue', '1' = 'green', '2' = 'red'), aesthetics = c("colour", "fill"))
p+ scale_color_manual(values = c('blue', 'green', 'red','black'))
p + scale_colour_manual(values = c('-1' = 'black','0' = 'blue', '1' = 'green', '2' = 'red'))
p +  scale_color_manual(name = "qsec",
                     values = c("-1" = "black", "0" = "yellow", "1" = "red",  "2" = "gray"),
                     labels = c("-1", "0", "1", "2"))
p+  scale_fill_gradient(colours = c("green","yellow","red"), breaks = c(-0.5,0.5,1.5))

m <- matrix(round(rnorm(200), 2), 10, 10)
colnames(m) <- paste("Col", 1:10)
rownames(m) <- paste("Row", 1:10)
df <- melt(m)

