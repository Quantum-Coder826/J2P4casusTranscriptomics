# Auteur: Berend Veldthuis
# Functie: Dit script neemt de .BAM files gegenereerd door seq_mapping.R
# en maakt de count matrix en saved deze. 
# Ook produceert het wat metadata aan hoeveel counts gevonden zijn.

library(readr)
library(tidyverse)
library(Rsamtools)
library(Rsubread)

# Hall ale .BAM files uit ./bams/
allsamples <- list.files("./bams", pattern = "\\.BAM$", full.names = TRUE)
allsamples

# Genereer gtf uit gff3 file
gff <- read_tsv("./refSeqHomoSapiens/Homo_sapiens.GRCh38.114.chr.gff3.gz", comment = "#", col_names = FALSE)
colnames(gff) <- c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")
gff_gene <- gff %>% filter(type == "gene")
gff_gene$type <- "exon"
bam_chr <- names(scanBamHeader("./bams/ctrl1.BAM")[[1]]$targets)[1]
gff_gene$seqid <- bam_chr
write_delim(gff_gene, "./refSeqHomoSapiens/HomoSapiens_ready.gtf", delim = "\t", col_names = FALSE)

# Genereer de count matrix
count_matrix <- featureCounts(
  files = allsamples,
  annot.ext = "./refSeqHomoSapiens/HomoSapiens_ready.gtf",
  isPairedEnd = TRUE,
  isGTFAnnotationFile = TRUE,
  GTF.attrType = "gene_id",
  useMetaFeatures = FALSE,
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
