library(Rsubread)
library(Rsamtools)

# Build de index for de refSeq
# Prefer to run once
buildindex(
  basename = './refSeqHomoSapiens/homoSapiens',
  reference = './refSeqHomoSapiens/GCF_000001405.40_GRCh38.p14_genomic.fna',
  memory = 14000, # use 14gig of ram
  indexSplit = TRUE)
stop() # Stop de run hier willen niet meer processen.

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
