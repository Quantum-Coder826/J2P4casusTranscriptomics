library(tidyverse)
library(dplyr)
library(readr)
library(goseq)

resultaten <- read.csv("./results/dds_resultaten.csv", sep = " ")
head(resultaten)

#supportedGeneIDs() %>% filter(str_detect(Genome, "hg")) # we gaan hg19 gebuiken

# Go seq wilt een named-vecotr waar de names de gene's zijn en de values bools
# Die 1 verhoging 0 verlaging representeren.
sigData <- as.integer(!is.na(resultaten$padj) & resultaten$padj < 0.01 & resultaten$log2FoldChange > 3)
names(sigData) <- rownames(resultaten)
head(sigData)

pwf <- nullp(sigData, "hg19", "geneSymbol")
goResults <- goseq(pwf, "hg19", "geneSymbol", test.cats=c("GO:BP"))

goResults %>% 
  top_n(10, wt=-over_represented_pvalue) %>% 
  mutate(hitsPerc=numDEInCat*100/numInCat) %>% 
  ggplot(aes(x=hitsPerc, 
             y=term, 
             colour=over_represented_pvalue, 
             size=numDEInCat)) +
  geom_point() +
  expand_limits(x=0) +
  labs(x="Hits (%)", y="GO term", colour="p value", size="Count")
