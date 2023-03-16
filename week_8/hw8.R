library(tidyverse)
library(nycflights13)
setwd("/Users/Oscar/Desktop/EE283_Adv-Bioinfo")
#a tibble is similar to data frame in base-R
# %>% is the pipe in tidyverse
# %in% 

# Before using tidyverse, it is better to make the data tidy!
# pivot_longer() is the function to make the table tidy

mal = read_tsv("allhaps.malathion.200kb.txt.gz")
#inspect the dataset first
levels(as.factor(mal$pool))
levels(as.factor(mal$founder))
summary(mal)

mal2 = mal %>% filter(chr=="chrX" & pos==316075)
mal2
levels(as.factor(mal2$pool))
levels(as.factor(mal2$founder))
mal2 = mal2 %>% mutate(treat=str_sub(pool,2,2))
treat=str_sub(mal2$pool,2,2)
anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data=mal2))
anova(lm(asin(sqrt(freq)) ~ founder + treat %in% founder, data=mal2))

#calculate the p value manually
mylog10pmodel <- function(df){
  out = anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data=df))
  myF = -log10(out[3,5])
  as.numeric(myF)
}

##extract the right P-value
mylog10pmodel2 <- function(df){
  out = anova(lm(asin(sqrt(freq)) ~ founder + treat %in% founder, data=df))
  myF = -log10(out[2,5])
  as.numeric(myF)
}
## remove the NA values!!
mal3 = mal  %>%
  na.omit() %>%
  mutate(treat=str_sub(pool,2,2)) %>%
  group_by(chr, pos) %>% 
  nest() %>% 
  mutate(logp = map_dbl(data, mylog10pmodel)) 
summary(mal3)

mal4 = mal  %>%
  na.omit() %>%
  mutate(treat=str_sub(pool,2,2)) %>%
  group_by(chr, pos) %>% 
  nest() %>%
  mutate(logp2 = map_dbl(data, mylog10pmodel2))

mal5 = mal3 %>%
  select(-data) %>%
  inner_join(mal4 %>% select(-data))

write.table(mal5[,c("chr","pos", "logp","logp2")] , file = "mal5.tsv")


#group_by, nest, and map.
