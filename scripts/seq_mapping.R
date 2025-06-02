library(Rsubread)
library(Rsamtools)

# Map de E.coli RefSeq
buildindex(
  basename = './ref_ecoli/ref_ecoli',
  reference = './ref_ecoli/GCF_000005845.2_ASM584v2_genomic.fna',
  memory = 8000, # use 8gig of ram
  indexSplit = TRUE)

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
