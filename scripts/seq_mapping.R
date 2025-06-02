library(Rsubread)
library(Rsamtools)

## Build de index for de refSeq
# Uitgevoerd op 2025-06-02 17:12:58 UTC+1
#buildindex(
#  basename = './refSeqHomoSapiens/homoSapiens',
#  reference = './refSeqHomoSapiens/GCF_000001405.40_GRCh38.p14_genomic.fna',
#  memory = 14000, # use 14gig of ram
#  indexSplit = TRUE)

## Aling alle monster
# file collection
samples <- data.frame(readFile1 = list.files("./dataset", pattern = "_1_", full.names = TRUE),
                readFile2 = list.files("./dataset", pattern = "_2_", full.names = TRUE))
samples

align.out <- list()
# loop alle columen en run de aling functie
by(samples, seq_len(nrow(samples)), function(file){
  align.out[[file$readFile1]] <- align(index = "./refSeqHomoSapiens/homoSapiens",
                                       readfile1 = file$readFile1,
                                       readfile2 = file$readFile2,
                                       output_file = paste0("./bams/", file$readFile1, ".bam"),
                                       nthreads = 16)
})

# Ethanol monsters
align.eth1 <- align(index = "./ref_ecoli/ref_ecoli", 
                    readfile1 = "./dataset/SRR8394576_ethanol_12h_1.fasta.gz", 
                    output_file = "./bams/eth1.BAM")

# Pull de path van alle *.BAM files in ./bams/
samples <- list.files("./bams", pattern = "\\.BAM$", full.names = TRUE)
samples

# Voor elk monster: sorteer en indexeer de BAM-file
# Sorteer BAM-bestanden
lapply(samples, function(s) {sortBam(file = s, destination = paste0(s, '.sorted'))
})

# Index the bam files
samples <- list.files("./bams", pattern = "\\.sorted.bam$", full.names = TRUE) #Pak de juiste files
samples
lapply(samples, function(s) {indexBam(file = s, destination = paste0(s, '.sorted'))
})
