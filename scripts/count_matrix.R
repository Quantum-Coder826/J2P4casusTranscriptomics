library(tidyverse)
library(readr)
library(Rsamtools)
library(Rsubread)

## Omzetten van `.gff3` naar `.gtf`
# Inlezen en filteren van GFF3-bestand
gff_E_Coli <- read_tsv("./refSeqEColi/Escherichia_coli_str_k_12_substr_mg1655_gca_000005845.ASM584v2.61.gff3",
                comment = "#", col_names = FALSE)
# Kolomnamen toevoegen
colnames(gff_E_Coli) <- c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")
# Alleen genregels selecteren
gff_gene <- gff_E_Coli %>% filter(type == "gene")
# 'type' aanpassen naar 'exon' zodat featureCounts het accepteert
gff_gene$type <- "exon"
# Extraheer de chromosoomnaam uit BAM-header
bam_chr <- names(scanBamHeader("./bams/eth1.BAM")[[1]]$targets)[1]
gff_gene$seqid <- bam_chr
write_delim(gff_gene, "./refSeqEColi/ecoli_ready_for_featureCounts.gtf",
            delim = "\t", col_names = FALSE)

# Je definieert een vector met namen van BAM-bestanden. Elke BAM bevat reads van een RNA-seq-experiment (bijv. behandeld vs. controle).

allsamples <- list.files("./bams", pattern = "\\.BAM$", full.names = TRUE)
allsamples

count_matrix <- featureCounts(
  files = allsamples,
  annot.ext = "./refSeqEColi/ecoli_ready_for_featureCounts.gtf",
  isPairedEnd = FALSE,
  isGTFAnnotationFile = TRUE,
  GTF.attrType = "gene_id",
  useMetaFeatures = TRUE,
  nthreads = 8
)

# Bekijk restultaten
head(count_matrix$annotation)
head(count_matrix$counts)

# we willen voor het volgende aleen de counts
counts <- count_matrix$counts
colnames(counts) <- c("ctrl1","ctrl2","ctrl3","eth1","eth2","eth3")
write.csv(counts, "./results/EColiCountMatrix.csv")
