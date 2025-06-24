# Auteur: Berend Veldthuis
# Functie: Dit script gebuik ik om mijn R packages gesynchroniseerd te houden
# tussen meerdere machines.

libPath = "~/R/x86_64-pc-linux-gnu-library/4.5/" #Check of deze werkt voor jouw systeem.

options(Ncpus = 10) #Niet iedereen heeft 10 threads voor packages builden check of dit kan.

if(!require(BiocManager)) {
  install.packages("BiocManager", lib = libPath)
}

if(!require(Rsubread)) {
  BiocManager::install("Rsubread", lib = libPath)
}

if(!require(Rsamtools)) {
  BiocManager::install("Rsamtools", lib = libPath)
}

if(!require(readr)) {
  install.packages("readr", lib = libPath)
}

if(!require(tidyverse)) {
  install.packages("tidyverse", lib = libPath)
}

if(!require(DESeq2)) {
  BiocManager::install("DESeq2", lib = libPath)
}

if(!require(KEGGREST)) {
  BiocManager::install("KEGGREST", lib = libPath)
}
if (!requireNamespace("EnhancedVolcano")) {
  BiocManager::install("EnhancedVolcano", lib = libPath)
}
if (!requireNamespace("pathview", quietly = TRUE)) {
  BiocManager::install("pathview", lib = libPath)
}
if(!require("goseq", quietly = TRUE)) {
  BiocManager::install("goseq", lib = libPath)
}
