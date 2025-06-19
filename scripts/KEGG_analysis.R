library(pathview)
library(KEGGREST)
library(readr)

resultaten <- read.csv("./results/dds_resultaten.csv", sep = " ")

resultaten[1] <- NULL
resultaten[2:5] <- NULL

setwd("./results/") #Kegg plaatst *.pathview.png in wd ik wil het in ./resultaten

# De Reuma pathway: https://www.kegg.jp/pathway/hsa05323+102723407
# Alle IG___ https://www.kegg.jp/entry/hsa:102723407

pathview(
  gene.data = resultaten,
  pathway.id = c("hsa05323", "hsa04612", "hsa04620", "hsa04625", "hsa04659"), # pathway ids voor RA
  species = "hsa",              # Homo Sapiens 
  gene.idtype = "SYMBOL",       # wij gebtuiken Genesymbols 
  limit = list(gene = 4),       # Kleurbereik voor log2FC van -5 tot +5
  low = list(gene = "red"),     # Gebruik deze kleuren voor laagste en hoogste log2FC 
  high = list(gene = "green"),
  kegg.dir = "./KEGG/"          # Dump je crap hier AUB
)

setwd('..') # Reset de wd