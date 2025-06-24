# Auteur: Berend Veldthuis
# Functie: Hier plot ik de nodige KEGG pathways op basis van de resultagen uit de GO:BP analyse

library(pathview)
library(KEGGREST)
library(readr)

resultaten <- read.csv("./results/dds_resultaten.csv", sep = " ")

resultaten[1] <- NULL
resultaten[2:5] <- NULL

setwd("./results/") #Kegg plaatst *.pathview.png in wd ik wil het in ./resultaten

# De Reuma pathway: https://www.kegg.jp/pathway/hsa05323+102723407

pathview(
  gene.data = resultaten,
  pathway.id = c("hsa05323", "hsa04620"), # pathway ids
  species = "hsa",              # Homo Sapiens 
  gene.idtype = "SYMBOL",       # wij gebtuiken Genesymbols 
  limit = list(gene = 4),       # Kleurbereik voor log2FC van -5 tot +5
  low = list(gene = "red"),     # Gebruik deze kleuren voor laagste en hoogste log2FC 
  high = list(gene = "green"),
  kegg.dir = "./KEGG/"          # Dump je crap hier AUB
)

setwd('..') # Reset de wd