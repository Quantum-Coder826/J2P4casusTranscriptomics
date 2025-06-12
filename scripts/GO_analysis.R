library(tidyverse)
library(readr)
library(goseq)

resultaten <- read_rds("./results/dds_results.rds")

#supportedOrganisms() %>% filter(str_detect(Genome, "hg")) # we gaan hg19 gebuiken


sigData <- as.integer(!is.na(resultaten$padj) & resultaten$padj < 0.01)
names(sigData) <- resultaten$GeneID

pwf <- nullp(sigData, "hg19", "ensGene", bias.data = resultaten$medianTxLength)
