library(pathview)
library(KEGGREST)
library(readr)

resultaten <- read.csv("./results/dds_resultaten.csv", sep = " ")

resultaten[1] <- NULL
resultaten[2:5] <- NULL

setwd("./results/") #Kegg plaatst *.pathview.png in wd ik wil het in ./resultaten

pathview(
  gene.data = resultaten,
  pathway.id = "hsa04650",  
  species = "hsa",         
  gene.idtype = "SYMBOL",     # wij gebtuiken Genesymbols 
  limit = list(gene = 5),    # Kleurbereik voor log2FC van -5 tot +5
  kegg.dir = "./KEGG/" # Dump je crap hier AUB
)

setwd('..') # Reset de wd