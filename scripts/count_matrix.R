library(tidyverse)
library(readr)
library(Rsamtools)
library(Rsubread)

# Hall ale .BAM files uit ./bams/
allsamples <- list.files("./bams", pattern = "\\.BAM$", full.names = TRUE)
allsamples

# Genereer de count matrix
count_matrix <- featureCounts(
  files = allsamples,
  annot.ext = "./refSeqHomoSapiens/Homo_sapiens.GRCh38.114.gtf.gz",
  isPairedEnd = TRUE,
  isGTFAnnotationFile = TRUE,
  GTF.attrType = "gene_id",
  useMetaFeatures = TRUE,
  nthreads = 16
)

# Bekijk restultaten
head(count_matrix$annotation)
head(count_matrix$counts)

# we willen voor het volgende aleen de counts
counts <- count_matrix$counts
colnames(counts) <- c("ctrl1","ctrl2","ctrl3","ctrl4",
                      "ra1","ra2","ra3","ra4")
write.csv(counts, "./results/reuma_count_matrix.csv")
