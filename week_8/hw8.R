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

mylog10pmodel <- function(df){
  out = anova(lm(asin(sqrt(freq)) ~ treat + founder + treat:founder, data=df))
  myF = -pf(out[1,3]/out[2,3],out[1,1],out[2,1],lower.tail=FALSE,
            log.p=TRUE)/log(10)
  as.numeric(myF)
}

mylog10pmodel2 <- function(df){
  out = anova(lm(asin(sqrt(freq)) ~ founder + treat %in% founder, data=df))
  myF = -pf(out[1,3]/out[2,3],out[1,1],out[2,1],lower.tail=FALSE,
            log.p=TRUE)/log(10)
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

mal5 = inner_join(
  mal3,mal4,
copy = FALSE
)




#group_by, nest, and map.
